#!/usr/bin/env python3
"""
test.py — Interactive test for player.py

Usage:
    python test.py

Paste a YouTube video ID when prompted.  The script will extract the
direct audio URL and print metadata.
"""

from __future__ import annotations

import logging
import sys

from player import resolve_video

logging.basicConfig(
    level=logging.INFO,
    format="%(levelname)s: %(message)s",
    stream=sys.stderr,
)


def main() -> None:
    video_id: str = input("Enter Video ID: ").strip()

    if not video_id:
        print("No ID provided.")
        sys.exit(1)

    result: dict = resolve_video(video_id)

    if "error" in result:
        print(f"\nERROR ({result.get('status', 500)}): {result['error']}")
        sys.exit(1)

    print()
    print(f"Title:     {result['title']}")
    print(f"Duration:  {result['duration']}s")
    print(f"Audio URL: {result['url']}")
    print(f"Extractor: {result['extractor']}")
    print(f"Client:    {result['client']}")
    print()


if __name__ == "__main__":
    main()
