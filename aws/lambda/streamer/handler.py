import json
import yt_dlp


def lambda_handler(event, context):
    path = event.get("rawPath", "")
    method = event.get("requestContext", {}).get("http", {}).get("method", "")

    if path == "/playable" and method == "POST":
        body = json.loads(event.get("body", "{}"))
        video_id = body.get("videoId")
        if not video_id:
            return {"statusCode": 400, "body": json.dumps({"error": "Missing videoId"})}
        return get_playable_url(video_id)

    return {"statusCode": 404, "body": json.dumps({"error": "Not found"})}


def get_playable_url(video_id):
    try:
        ydl_opts = {
            "format": "bestaudio/best",
            "quiet": True,
            "no_warnings": True,
        }
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(video_id, download=False)

        formats = info.get("formats", [])
        audio_only = [
            f
            for f in formats
            if f.get("vcodec") == "none" and f.get("acodec") != "none"
        ]
        audio_only.sort(key=lambda f: f.get("abr", 0) or 0, reverse=True)

        best = audio_only[0] if audio_only else formats[0]

        return {
            "statusCode": 200,
            "body": json.dumps({
                "url": best.get("url"),
                "bitrate": best.get("abr"),
                "mimeType": best.get("ext"),
                "duration": info.get("duration"),
                "title": info.get("title"),
            }),
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
        }
