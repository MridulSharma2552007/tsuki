"""
Lambda handler for tsuki-streamer.

Resolves a YouTube video ID into a direct playable audio URL via yt-dlp.
Exposes a single POST endpoint: /stream/playable { "videoId": "..." }
"""

from __future__ import annotations

import base64
import json
import logging
import os
from typing import Any

import yt_dlp
from yt_dlp.utils import DownloadError, ExtractorError, GeoRestrictedError

logger = logging.getLogger()
logger.setLevel(os.environ.get("LOG_LEVEL", "INFO").upper())

# ── Default extraction options ─────────────────────────────────────────
# The "android" client is forced via extractor_args so that YouTube returns
# a raw progressive audio URL without requiring a PoToken or JS challenge.
# This keeps the function lightweight (no Deno, no cookies).
DEFAULT_OPTIONS: dict[str, Any] = {
    "format": "bestaudio[ext=m4a]/bestaudio/best",
    "extractor_args": {"youtube": {"client": ["android"]}},
    "skip_download": True,
    "quiet": True,
    "no_warnings": True,
    "noplaylist": True,
    "no_color": True,
}


# ── Core extraction (identical logic to player/player.py) ──────────────


def resolve_audio(video_id: str) -> dict[str, Any]:
    """Return a result dict for *video_id*."""

    opts: dict[str, Any] = {**DEFAULT_OPTIONS}

    logger.info("Resolving video_id=%s", video_id)

    try:
        with yt_dlp.YoutubeDL(opts) as ydl:
            info: dict[str, Any] = ydl.extract_info(video_id, download=False)

    except GeoRestrictedError as exc:
        logger.error("Geo-restricted: %s", exc)
        return {"error": f"Video is geo-restricted: {exc}", "status": 451}

    except ExtractorError as exc:
        logger.error("Extractor error: %s", exc)
        return {"error": f"Extraction failed: {exc}", "status": 500}

    except DownloadError as exc:
        logger.error("Download error: %s", exc)
        return {"error": f"yt-dlp could not resolve video: {exc}", "status": 500}

    except Exception as exc:
        logger.exception("Unexpected error")
        return {"error": f"Unexpected error: {exc}", "status": 500}

    # ── Metadata ────────────────────────────────────────────────────────
    title: str = info.get("title", "Unknown")
    duration: int | None = info.get("duration")
    extractor: str = info.get("extractor", "youtube")

    # ── Pick best audio format that carries a direct URL ────────────────
    formats: list[dict[str, Any]] = info.get("formats", [])

    audio_formats: list[dict[str, Any]] = [
        f
        for f in formats
        if f.get("vcodec") == "none"
        and f.get("acodec") != "none"
        and f.get("url")
    ]

    if not audio_formats:
        logger.warning("No audio-only format with URL – trying all formats")
        audio_formats = [f for f in formats if f.get("url")]

    if not audio_formats:
        logger.error("No format with a URL found")
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
        "Resolved id=%s title=%s bitrate=%s ext=%s url_len=%s",
        video_id,
        title,
        bitrate,
        ext,
        len(url),
    )

    return {
        "url": url,
        "title": title,
        "duration": duration,
        "bitrate": bitrate,
        "mime_type": mime_type,
        "extractor": extractor,
        "client": opts.get("extractor_args", {})
        .get("youtube", {})
        .get("client", ["unknown"])[0],
    }


# ── Lambda entry-point ─────────────────────────────────────────────────


def lambda_handler(event: dict[str, Any], context: Any) -> dict[str, Any]:
    logger.info("Event: %s", json.dumps(event))

    path: str = event.get("rawPath", "")
    method: str = (
        event.get("requestContext", {})
        .get("http", {})
        .get("method", "")
    )

    if path != "/stream/playable" or method != "POST":
        logger.warning("No route matched: %s %s", method, path)
        return _response(404, {"error": "Not found"})

    # ── Parse body (handle base64 encoding) ─────────────────────────────
    raw_body: str = event.get("body") or "{}"
    if event.get("isBase64Encoded", False):
        raw_body = base64.b64decode(raw_body).decode("utf-8")
    body: dict[str, Any]
    try:
        body = json.loads(raw_body)
    except (json.JSONDecodeError, UnicodeDecodeError) as exc:
        return _response(400, {"error": f"Invalid JSON body: {exc}"})

    video_id: str | None = body.get("videoId")
    if not video_id:
        return _response(400, {"error": "Missing videoId"})

    result: dict[str, Any] = resolve_audio(video_id)

    if "error" in result:
        status: int = result.pop("status", 500)
        return _response(status, result)

    return _response(200, result)


def _response(status_code: int, body: dict[str, Any]) -> dict[str, Any]:
    return {
        "statusCode": status_code,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body),
    }
