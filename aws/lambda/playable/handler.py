from __future__ import annotations

import base64
import json
import logging
import os
import time
import traceback
from typing import Any

import yt_dlp
from yt_dlp.utils import DownloadError, ExtractorError, GeoRestrictedError


class JsonFormatter(logging.Formatter):
    """Output every log line as a JSON object for CloudWatch Insights queries."""

    def format(self, record: logging.LogRecord) -> str:
        log_entry: dict[str, Any] = {
            "timestamp": self.formatTime(record, self.datefmt),
            "level": record.levelname,
            "message": record.getMessage(),
        }
        request_id = getattr(record, "request_id", None)
        if request_id:
            log_entry["request_id"] = request_id
        if record.exc_info and record.exc_info[0]:
            log_entry["traceback"] = "".join(traceback.format_exception(*record.exc_info))
        return json.dumps(log_entry)


logger = logging.getLogger()
logger.setLevel(os.environ.get("LOG_LEVEL", "INFO").upper())

_handler = logging.StreamHandler()
_handler.setFormatter(JsonFormatter())
logger.handlers = [_handler]

# Clients to try in order (SABR enforcement workaround — YouTube blocks
# datacenter IPs for some clients but not others).
CLIENTS: list[str] = ["android_vr", "android", "ios", "web"]

DEFAULT_BASE_OPTIONS: dict[str, Any] = {
    "format": "bestaudio[ext=m4a]/bestaudio/best",
    "skip_download": True,
    "quiet": True,
    "no_warnings": True,
    "noplaylist": True,
    "no_color": True,
}


def build_options(client: str) -> dict[str, Any]:
    return {
        **DEFAULT_BASE_OPTIONS,
        "extractor_args": {"youtube": {"client": [client]}},
    }


def resolve_audio(video_id: str, request_id: str) -> dict[str, Any]:
    logger.info("resolve_audio entry", extra={"request_id": request_id, "video_id": video_id})
    logger.info(
        "yt-dlp version: %s", yt_dlp.version.__version__,
        extra={"request_id": request_id},
    )

    last_error: Exception | None = None

    for client in CLIENTS:
        opts: dict[str, Any] = build_options(client)
        logger.info(
            "Trying client=%s", client,
            extra={"request_id": request_id, "client": client, "video_id": video_id},
        )

        t0: float = time.monotonic()
        try:
            with yt_dlp.YoutubeDL(opts) as ydl:
                info: dict[str, Any] = ydl.extract_info(video_id, download=False)
        except GeoRestrictedError as exc:
            elapsed: float = time.monotonic() - t0
            logger.exception(
                "Geo-restricted with client=%s after %.2fs",
                client, elapsed,
                extra={"request_id": request_id, "client": client, "video_id": video_id, "elapsed_s": round(elapsed, 3)},
            )
            return {"error": f"Video is geo-restricted: {exc}", "status": 451}
        except (DownloadError, ExtractorError) as exc:
            elapsed = time.monotonic() - t0
            logger.exception(
                "Client=%s failed after %.2fs",
                client, elapsed,
                extra={"request_id": request_id, "client": client, "video_id": video_id, "elapsed_s": round(elapsed, 3)},
            )
            last_error = exc
            continue
        except Exception as exc:
            elapsed = time.monotonic() - t0
            logger.exception(
                "Unexpected error with client=%s after %.2fs",
                client, elapsed,
                extra={"request_id": request_id, "client": client, "video_id": video_id, "elapsed_s": round(elapsed, 3)},
            )
            last_error = exc
            continue

        elapsed = time.monotonic() - t0
        logger.info(
            "Client=%s succeeded in %.2fs", client, elapsed,
            extra={"request_id": request_id, "client": client, "video_id": video_id, "elapsed_s": round(elapsed, 3)},
        )

        # ── Metadata ────────────────────────────────────────────────────
        title: str = info.get("title", "Unknown")
        duration: int | None = info.get("duration")
        extractor: str = info.get("extractor", "youtube")

        formats: list[dict[str, Any]] = info.get("formats", [])
        logger.info(
            "Extracted %d total formats", len(formats),
            extra={"request_id": request_id, "video_id": video_id},
        )

        audio_formats: list[dict[str, Any]] = [
            f
            for f in formats
            if f.get("vcodec") == "none"
            and f.get("acodec") != "none"
            and f.get("url")
        ]

        if not audio_formats:
            logger.warning(
                "No audio-only format with URL – trying all formats",
                extra={"request_id": request_id, "video_id": video_id},
            )
            audio_formats = [f for f in formats if f.get("url")]

        if not audio_formats:
            logger.error(
                "No format with a URL found",
                extra={"request_id": request_id, "video_id": video_id},
            )
            return {"error": "No playable format found", "status": 500}

        audio_formats.sort(key=lambda f: f.get("abr") or 0, reverse=True)
        best: dict[str, Any] = audio_formats[0]

        url: str | None = best.get("url")
        if not url:
            return {"error": "Selected format has no URL", "status": 500}

        bitrate: int | None = best.get("abr")
        ext: str = best.get("ext", "mp4")
        mime_type: str = f"audio/{ext}"

        logger.info(
            "Resolved id=%s title=%s bitrate=%s ext=%s url_len=%s client=%s",
            video_id, title, bitrate, ext, len(url), client,
            extra={"request_id": request_id, "video_id": video_id, "client": client},
        )

        return {
            "url": url,
            "title": title,
            "duration": duration,
            "bitrate": bitrate,
            "mime_type": mime_type,
            "extractor": extractor,
            "client": client,
        }

    # ── All clients failed ──────────────────────────────────────────────
    exc_type: str = type(last_error).__name__ if last_error else "Unknown"
    exc_msg: str = str(last_error) if last_error else "All clients failed without a specific error"
    logger.error(
        "All clients failed for video_id=%s. Last error: %s: %s",
        video_id, exc_type, exc_msg,
        extra={"request_id": request_id, "video_id": video_id},
    )

    return {
        # TODO: strip exception type/message from production responses —
        # included during debugging so curl shows why it failed.
        "error": f"All extraction clients failed. [{exc_type}] {exc_msg}",
        "status": 500,
    }


def lambda_handler(event: dict[str, Any], context: Any) -> dict[str, Any]:
    request_id: str = context.aws_request_id

    logger.info(
        "Incoming event: %s", json.dumps(event),
        extra={"request_id": request_id},
    )

    path: str = event.get("rawPath", "")
    method: str = (
        event.get("requestContext", {})
        .get("http", {})
        .get("method", "")
    )

    if path != "/playable" or method != "POST":
        logger.warning(
            "No route matched: %s %s", method, path,
            extra={"request_id": request_id, "path": path, "method": method},
        )
        return _response(404, {"error": "Not found"}, request_id)

    # ── Parse body (handle base64 encoding) ─────────────────────────────
    raw_body: str = event.get("body") or "{}"
    if event.get("isBase64Encoded", False):
        raw_body = base64.b64decode(raw_body).decode("utf-8")

    body: dict[str, Any]
    try:
        body = json.loads(raw_body)
    except (json.JSONDecodeError, UnicodeDecodeError) as exc:
        return _response(400, {"error": f"Invalid JSON body: {exc}"}, request_id)

    video_id: str | None = body.get("videoId")
    if not video_id:
        return _response(400, {"error": "Missing videoId"}, request_id)

    result: dict[str, Any] = resolve_audio(video_id, request_id)

    if "error" in result:
        status: int = result.pop("status", 500)
        return _response(status, result, request_id)

    return _response(200, result, request_id)


def _response(
    status_code: int,
    body: dict[str, Any],
    request_id: str,
) -> dict[str, Any]:
    response: dict[str, Any] = {
        "statusCode": status_code,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body),
    }

    logger.info(
        "Response status=%d body_size=%d",
        status_code, len(response["body"]),
        extra={"request_id": request_id, "status_code": status_code},
    )

    return response
