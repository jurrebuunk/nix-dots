#!/usr/bin/env python3
"""Simple rofi prompt for pi."""

from __future__ import annotations

import argparse
import os
import subprocess
from pathlib import Path


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--title", default="pi")
    args = ap.parse_args()

    rofi_theme = os.path.expanduser("~/.config/rofi/pi.rasi")
    rofi = ["rofi", "-dmenu", "-i", "-p", args.title, "-theme", rofi_theme]

    proc = subprocess.run(rofi, input="", text=True, capture_output=True)
    if proc.returncode != 0:
        return 0

    prompt = proc.stdout.strip()
    if not prompt:
        return 0

    cache = Path(os.path.expanduser("~/.cache/pi-last.json"))
    status = Path(os.path.expanduser("~/.cache/pi-status.txt"))
    answer_file = Path(os.path.expanduser("~/.cache/pi-answer.txt"))
    session_dir = Path(os.path.expanduser("~/.cache/pi-sessions"))

    env = os.environ.copy()
    cmd = [
        env.get("PI_BAR", os.path.expanduser("~/.local/bin/pi-bar")),
        "--run",
        prompt,
        "--cache",
        str(cache),
        "--status",
        str(status),
        "--answer-file",
        str(answer_file),
        "--session-dir",
        str(session_dir),
    ]
    return subprocess.call(cmd, env=env)


if __name__ == "__main__":
    raise SystemExit(main())
