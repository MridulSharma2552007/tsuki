"""
player.py — Resolve a YouTube video ID into a direct playable audio URL.

Uses yt-dlp's Python API (not the CLI binary).  No files are downloaded
or converted; only metadata and streaming URLs are extracted.
"""

from __future__ import annotations

import logging
from typing import Any

import yt_dlp
from yt_dlp.utils import DownloadError, ExtractorError, GeoRestrictedError

logger = logging.getLogger(__name__)

# ── Default extractor options ──────────────────────────────────────────
# These are tuned to get a playable audio URL with minimal friction.
#
#   format          – best audio-only stream (prefer m4a/AAC, fallback any)
#   extractor_args  – force the "android" client.  YouTube gives the android
#                     client the raw progressive URL without requiring a
#                     PoToken or JS challenge.  This is the key trick that
#                     keeps extraction working without extra dependencies.
#   skip_download   – we only want metadata + URL, never the actual bytes.

DEFAULT_OPTIONS: dict[str, Any] = {
    "format": "bestaudio[ext=m4a]/bestaudio/best",
    "extractor_args": {"youtube": {"client": ["android"]}},
    "skip_download": True,
    "quiet": True,
    "no_warnings": True,
    "noplaylist": True,
    "no_color": True,
}


# ── Public API ─────────────────────────────────────────────────────────


def resolve_video(
    video_id: str,
    options: dict[str, Any] | None = None,
    logger: logging.Logger | None = None,
) -> dict[str, Any]:
    """
    Resolve a YouTube video ID into a playable audio URL.

    Parameters
    ----------
    video_id :
        The 11-character YouTube video ID (e.g. ``"dQw4w9WgXcQ"``).
    options :
        Override or extend ``DEFAULT_OPTIONS``.  Passed directly to
        ``yt_dlp.YoutubeDL``.
    logger :
        If omitted a module-level logger is used.

    Returns
    -------
    dict with keys:
        url         – direct GoogleVideo CDN URL (progressive, streamable)
        title       – video title
        duration    – duration in seconds (int or None)
        bitrate     – audio bitrate in kbps (int or None)
        mime_type   – MIME type of the selected stream
        extractor   – extractor that resolved the URL (e.g. ``"youtube"``)
        client      – client used for extraction (``"android"`` by default)
    """

    log = logger or logging.getLogger(__name__)

    # Merge caller options on top of defaults.
    opts: dict[str, Any] = {**DEFAULT_OPTIONS, **(options or {})}

    log.info("Resolving video_id=%s with options=%s", video_id, opts)

    try:
        with yt_dlp.YoutubeDL(opts) as ydl:
            info: dict[str, Any] = ydl.extract_info(video_id, download=False)

    except GeoRestrictedError as exc:
        log.error("Geo-restricted: %s", exc)
        return {"error": f"Video is geo-restricted: {exc}", "status": 451}

    except ExtractorError as exc:
        log.error("Extractor error: %s", exc)
        return {"error": f"Extraction failed: {exc}", "status": 500}

    except DownloadError as exc:
        log.error("Download / extraction error: %s", exc)
        return {"error": f"yt-dlp could not resolve video: {exc}", "status": 500}

    except Exception as exc:
        log.exception("Unexpected error")
        return {"error": f"Unexpected error: {exc}", "status": 500}

    # ── Gather metadata ────────────────────────────────────────────────
    title: str = info.get("title", "Unknown")
    duration: int | None = info.get("duration")
    extractor: str = info.get("extractor", "youtube")

    # ── Pick the best audio format that carries a direct URL ────────────
    formats: list[dict[str, Any]] = info.get("formats", [])

    # Keep only audio-only streams (no video track) that have a URL.
    audio_formats: list[dict[str, Any]] = [
        f
        for f in formats
        if f.get("vcodec") == "none"
        and f.get("acodec") != "none"
        and f.get("url")
    ]

    if not audio_formats:
        log.warning("No audio-only formats with URL – trying all formats")
        # Last resort: any format with a URL.
        audio_formats = [f for f in formats if f.get("url")]

    if not audio_formats:
        log.error("No format with a URL found")
        return {"error": "No playable format found", "status": 500}

    # Sort by audio bitrate descending (None → 0).
    audio_formats.sort(key=lambda f: f.get("abr") or 0, reverse=True)
    best: dict[str, Any] = audio_formats[0]

    url: str | None = best.get("url")
    if not url:
        return {"error": "Selected format has no URL", "status": 500}

    bitrate: int | None = best.get("abr")
    ext: str = best.get("ext", "mp4")
    mime_type: str = f"audio/{ext}"

    log.info(
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
