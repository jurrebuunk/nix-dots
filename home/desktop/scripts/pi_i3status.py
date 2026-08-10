#!/usr/bin/env python3
"""Wrap i3status output and prepend the cached pi answer as a status block.

This keeps the normal i3status bar intact while adding a leftmost custom block.

Usage:
  pi_i3status.py --cache ~/.cache/pi-last.json --i3status-config ~/.config/i3status/config
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path
from typing import Any


def _read_cache(path: Path) -> str | None:
    if not path.exists():
        return None
    try:
        raw = path.read_text(encoding="utf-8").strip()
    except OSError:
        return None
    if not raw:
        return None
    try:
        obj = json.loads(raw)
    except json.JSONDecodeError:
        return raw
    if isinstance(obj, dict):
        ans = obj.get("answer")
        if isinstance(ans, str) and ans.strip():
            return " ".join(ans.split())
    return None


def _read_status(path: Path) -> dict[str, Any] | None:
    if not path.exists():
        return None
    try:
        raw = path.read_text(encoding="utf-8").strip()
    except OSError:
        return None
    if not raw:
        return None
    try:
        obj = json.loads(raw)
    except json.JSONDecodeError:
        return {"state": "running", "text": raw}
    return obj if isinstance(obj, dict) else None


def _pi_block(text: str, color: str | None = None) -> dict[str, Any]:
    block: dict[str, Any] = {
        "name": "pi",
        "instance": "status",
        "markup": "none",
        "full_text": text,
    }
    if color:
        block["color"] = color
    return block


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--cache", required=True)
    ap.add_argument("--status", default=os.path.expanduser("~/.cache/pi-status.json"))
    ap.add_argument("--i3status-bin", default="i3status")
    ap.add_argument("--i3status-config", default=None)
    args = ap.parse_args()

    cmd = [args.i3status_bin]
    if args.i3status_config:
        cmd += ["-c", args.i3status_config]

    proc = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        bufsize=1,
    )

    def pump_stderr() -> None:
        assert proc.stderr is not None
        for line in proc.stderr:
            sys.stderr.write(line)
            sys.stderr.flush()

    import threading

    t = threading.Thread(target=pump_stderr, daemon=True)
    t.start()

    def current_block() -> dict[str, Any]:
        status_obj = _read_status(Path(args.status))
        answer = _read_cache(Path(args.cache))
        pi_text = "pi: idle"
        color = None
        if isinstance(status_obj, dict):
            state = status_obj.get("state")
            text = status_obj.get("text")
            if state not in {None, "idle", "done"}:
                if not isinstance(text, str) or not text.strip():
                    text = str(state or "working")
                pi_text = f"pi: {text}"
                if state == "error":
                    color = "#ff5555"
                elif state == "running":
                    color = "#f1fa8c"
            elif answer:
                pi_text = f"pi: {answer}"
        elif answer:
            pi_text = f"pi: {answer}"
        return _pi_block(pi_text, color)

    assert proc.stdout is not None
    first = True
    for raw in proc.stdout:
        line = raw.rstrip("\n")
        if not line:
            continue

        # i3status/i3bar protocol: header, then "[", then arrays with optional trailing commas.
        if first:
            print(line)
            first = False
            sys.stdout.flush()
            continue

        if line == "[" or line == "]":
            print(line)
            sys.stdout.flush()
            continue

        has_comma = line.endswith(",")
        payload = line[:-1] if has_comma else line
        try:
            arr = json.loads(payload)
        except json.JSONDecodeError:
            print(line)
            sys.stdout.flush()
            continue

        if isinstance(arr, list):
            arr = [current_block(), *arr]
            out = json.dumps(arr, ensure_ascii=False)
            if has_comma:
                out += ","
            print(out)
            sys.stdout.flush()
        else:
            print(line)
            sys.stdout.flush()

    rc = proc.wait()
    t.join(timeout=1)
    return rc


if __name__ == "__main__":
    raise SystemExit(main())
