import json
import logging
import traceback

import yt_dlp

logger = logging.getLogger()
logger.setLevel("INFO")


def lambda_handler(event, context):
    logger.info(f"Event: {json.dumps(event)}")

    path = event.get("rawPath", "")
    method = event.get("requestContext", {}).get("http", {}).get("method", "")

    logger.info(f"Path: {path}, Method: {method}")

    if path == "/stream/playable" and method == "POST":
        try:
            body = json.loads(event.get("body", "{}"))
        except Exception as e:
            logger.error(f"Failed to parse body: {e}")
            return {
                "statusCode": 400,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": f"Invalid JSON body: {str(e)}"}),
            }

        video_id = body.get("videoId")
        logger.info(f"Requested videoId: {video_id}")

        if not video_id:
            return {
                "statusCode": 400,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": "Missing videoId"}),
            }

        return get_playable_url(video_id)

    logger.warning(f"No route matched: {path} {method}")
    return {
        "statusCode": 404,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"error": "Not found"}),
    }


def get_playable_url(video_id):
    try:
        logger.info(f"Starting yt-dlp extraction for {video_id}")

        ydl_opts = {
            "format": "bestaudio/best",
            "quiet": True,
            "no_warnings": True,
            "extract_flat": False,
        }

        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            logger.info("Calling ydl.extract_info...")
            info = ydl.extract_info(video_id, download=False)
            logger.info(f"Extraction complete. Keys in info: {list(info.keys())}")

        title = info.get("title", "Unknown")
        duration = info.get("duration")
        logger.info(f"Title: {title}, Duration: {duration}")

        formats = info.get("formats", [])
        logger.info(f"Total formats: {len(formats)}")

        audio_only = [
            f
            for f in formats
            if f.get("vcodec") == "none" and f.get("acodec") != "none"
        ]
        logger.info(f"Audio-only formats: {len(audio_only)}")

        for f in audio_only:
            logger.info(
                f"  Audio format - ext: {f.get('ext')}, "
                f"abr: {f.get('abr')}, "
                f"url: {'present' if f.get('url') else 'MISSING'}"
            )

        if not audio_only:
            logger.warning("No audio-only formats found, falling back to all formats")
            best = formats[0] if formats else None
        else:
            audio_only.sort(key=lambda f: f.get("abr", 0) or 0, reverse=True)
            best = audio_only[0]

        if not best:
            logger.error("No formats available at all")
            return {
                "statusCode": 500,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": "No available formats"}),
            }

        url = best.get("url")
        logger.info(f"Selected format: ext={best.get('ext')}, abr={best.get('abr')}")
        logger.info(f"URL present: {bool(url)}")

        if not url:
            logger.error("Best format has no URL")
            return {
                "statusCode": 500,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": "Extracted format has no URL"}),
            }

        response = {
            "url": url,
            "bitrate": best.get("abr"),
            "mimeType": f'audio/{best.get("ext", "mp4")}',
            "duration": duration,
            "title": title,
        }
        logger.info(f"Returning response: {json.dumps(response, default=str)[:500]}")
        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps(response),
        }

    except Exception as e:
        tb = traceback.format_exc()
        logger.error(f"Error extracting video: {e}\n{tb}")
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": str(e), "trace": tb}),
        }
