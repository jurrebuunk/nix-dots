#!/usr/bin/env python3
"""Helper for showing the latest `pi` answer and live run status in the bar.

Modes:
  pi_bar.py --cache ~/.cache/pi-last.json
    Print the cached answer if present.

  pi_bar.py --run "prompt" --cache ~/.cache/pi-last.json
    Run `pi -p "prompt" --mode json`, update the status file while it runs,
    extract the final assistant answer, save it to the cache file, and print it.
    Slash commands that print mode supports (for example `/skill:name`) are
    passed through unchanged.

Files:
  cache:   {"prompt": ..., "answer": ..., "timestamp": ...}
  status:  {"state": "running|idle|error", "text": ..., "prompt": ...}
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import time
from pathlib import Path
from typing import Any


def _content_to_text(content: Any) -> str | None:
    if isinstance(content, str):
        return content
    if isinstance(content, list):
        parts: list[str] = []
        for item in content:
            if isinstance(item, str):
                parts.append(item)
            elif isinstance(item, dict):
                txt = item.get("text")
                if isinstance(txt, str):
                    parts.append(txt)
        if parts:
            return "".join(parts)
    return None


def _content_item_label(item: Any) -> str | None:
    if not isinstance(item, dict):
        return None
    typ = item.get("type")
    if typ == "thinking":
        for key in ("title", "label", "summary"):
            val = item.get(key)
            if isinstance(val, str) and val.strip():
                return val.strip()
        thought = item.get("thinking")
        if isinstance(thought, str) and thought.strip():
            first = thought.strip().splitlines()[0]
            return first[:48]
        return "thinking"
    if typ in {"toolCall", "toolcall"}:
        for key in ("name", "toolName", "tool"):
            val = item.get(key)
            if isinstance(val, str) and val.strip():
                return f"tool: {val.strip()}"
        return "tool"
    return None


def _message_status_label(msg: dict[str, Any]) -> str | None:
    content = msg.get("content")
    if isinstance(content, list):
        for item in content:
            label = _content_item_label(item)
            if label:
                return label
    return None


def _extract_assistant_text(events: list[dict[str, Any]]) -> str | None:
    answer = None
    for ev in events:
        if ev.get("type") not in {"message_end", "turn_end", "message_update"}:
            continue
        msg = ev.get("message")
        if not isinstance(msg, dict):
            evt = ev.get("assistantMessageEvent")
            if isinstance(evt, dict):
                msg = evt.get("partial") if isinstance(evt.get("partial"), dict) else None
        if not isinstance(msg, dict):
            continue
        if msg.get("role") != "assistant":
            continue
        txt = _content_to_text(msg.get("content") or msg.get("text"))
        if txt:
            answer = txt
    return answer


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
            return ans.strip()
    return None


def _write_cache(path: Path, prompt: str, answer: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "prompt": prompt,
        "answer": answer,
        "timestamp": time.time(),
    }
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")


def _write_answer_text(path: Path, answer: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(answer.strip(), encoding="utf-8")


def _write_status(path: Path, state: str, text: str = "", prompt: str = "") -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if state in {"running", "idle", "done"}:
        content = text.strip()
    else:
        content = text.strip() or state
    path.write_text(content, encoding="utf-8")


def _read_status(path: Path) -> dict[str, Any] | None:
    if not path.exists():
        return None
    try:
        raw = path.read_text(encoding="utf-8").strip()
    except OSError:
        return None
    if not raw:
        return None
    return {"state": "running", "text": raw}


def _truncate(text: str, n: int = 60) -> str:
    text = " ".join(text.split())
    return text if len(text) <= n else text[: n - 1] + "…"


def _event_status(event: dict[str, Any]) -> str | None:
    etype = event.get("type")
    if etype in {"session", "agent_start", "turn_start"}:
        return "starting"
    if etype == "message_start" and isinstance(event.get("message"), dict):
        msg = event["message"]
        role = msg.get("role")
        if role == "user":
            txt = _content_to_text(msg.get("content") or msg.get("text"))
            if txt:
                return f"user: {_truncate(txt, 40)}"
            return "user input"
        if role == "assistant":
            label = _message_status_label(msg)
            return label or "thinking"
    if etype in {"tool_execution_start", "tool_execution_update", "tool_execution_end"}:
        tool = event.get("toolName") or event.get("tool") or event.get("name")
        if isinstance(tool, str) and tool.strip():
            return f"tool: {tool.strip()}"
        return "tool"
    if etype == "message_update":
        evt = event.get("assistantMessageEvent")
        msg = event.get("message") if isinstance(event.get("message"), dict) else None
        if isinstance(evt, dict):
            subtype = evt.get("type", "")
            if subtype in {"thinking_start", "thinking_delta", "thinking_end"}:
                if isinstance(msg, dict):
                    label = _message_status_label(msg)
                    if label and label != "thinking":
                        return label
                partial = evt.get("partial")
                if isinstance(partial, dict):
                    label = _message_status_label(partial)
                    if label and label != "thinking":
                        return label
                return "thinking"
            if "tool" in subtype:
                hint = evt.get("name") or evt.get("toolName") or evt.get("tool")
                if isinstance(hint, str) and hint.strip():
                    return f"tool: {hint.strip()}"
                partial = evt.get("partial")
                if isinstance(partial, dict):
                    label = _message_status_label(partial)
                    if label:
                        return label
                return "tool"
            if subtype in {"text_start", "text_delta"}:
                if isinstance(msg, dict):
                    label = _message_status_label(msg)
                    if label and label != "thinking":
                        return label
                return "thinking"
    if etype == "message_end" and isinstance(event.get("message"), dict):
        msg = event["message"]
        if msg.get("role") == "assistant":
            if msg.get("stopReason") == "error":
                return "error"
            label = _message_status_label(msg)
            if label and label != "thinking":
                return label
            return "done"
    if etype in {"turn_end", "agent_end"}:
        return "done"
    if isinstance(etype, str) and "tool" in etype:
        return "tool"
    return None


def run_pi(prompt: str, pi_bin: str, cache: Path, answer_file: Path, status: Path, session_dir: Path) -> str:
    session_dir.mkdir(parents=True, exist_ok=True)
    answer_file.parent.mkdir(parents=True, exist_ok=True)
    _write_status(status, "running", "thinking", prompt)
    # Keep the user prompt untouched so print-mode slash commands such as
    # /skill:name, prompt templates, and extension commands can be parsed by pi.
    topbar_system_prompt = (
        "This request came from a small rofi/topbar Pi prompt. "
        "Reply with exactly one sentence, max 16 words. No bullets, no extra text. "
        "If the user asks for a longer text or detailed explanation, use gnome-text-editor and present it as text or markdown based on complexity."
    )
    cmd = [
        pi_bin,
        "--continue",
        "--session-dir",
        str(session_dir),
        "--append-system-prompt",
        topbar_system_prompt,
        "-p",
        prompt,
        "--mode",
        "json",
    ]
    model = os.environ.get("PI_MODEL")
    if model:
        cmd[1:1] = ["--model", model]
    proc = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        bufsize=1,
    )

    assert proc.stdout is not None
    assert proc.stderr is not None

    # Keep stderr visible.
    def pump_stderr() -> None:
        for line in proc.stderr:
            sys.stderr.write(line)
            sys.stderr.flush()

    import threading

    t = threading.Thread(target=pump_stderr, daemon=True)
    t.start()

    events: list[dict[str, Any]] = []
    answer = None
    try:
        for line in proc.stdout:
            line = line.strip()
            if not line:
                continue
            try:
                obj = json.loads(line)
            except json.JSONDecodeError:
                continue
            if not isinstance(obj, dict):
                continue
            events.append(obj)
            status_text = _event_status(obj)
            if status_text:
                _write_status(status, "running", status_text, prompt)
            maybe = _extract_assistant_text(events)
            if maybe:
                answer = maybe
    finally:
        rc = proc.wait()
        t.join(timeout=1)
        if answer:
            _write_cache(cache, prompt, answer)
            _write_answer_text(answer_file, answer)
        else:
            _write_status(status, "error" if rc else "idle", "error" if not answer and rc else "idle", prompt)

    if not answer:
        raise SystemExit("could not extract assistant answer")
    return answer


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--cache", default=os.path.expanduser("~/.cache/pi-last.json"))
    ap.add_argument("--status", default=os.path.expanduser("~/.cache/pi-status.txt"), help="Run status file")
    ap.add_argument("--answer-file", default=os.path.expanduser("~/.cache/pi-answer.txt"), help="Plain-text answer file for the bar")
    ap.add_argument("--session-dir", default=os.path.expanduser("~/.cache/pi-sessions"), help="Directory for the persistent pi session")
    ap.add_argument("--new-session", action="store_true", help="Use a fresh session directory for this run")
    ap.add_argument("--run", help="Prompt to run through pi and cache")
    ap.add_argument("--pi-bin", default=os.environ.get("PI_BIN", "pi"))
    ap.add_argument("--prefix", default="pi: ")
    ap.add_argument("--max", type=int, default=80)
    args = ap.parse_args()

    cache = Path(args.cache)
    status = Path(args.status)
    answer_file = Path(args.answer_file)
    session_dir = Path(args.session_dir)
    if args.new_session:
        session_dir = session_dir / time.strftime("%Y%m%d-%H%M%S")

    if args.run:
        answer = run_pi(args.run, args.pi_bin, cache, answer_file, status, session_dir)
    else:
        answer = _read_cache(cache)
        if not answer:
            print("pi: idle")
            return 0
        _write_answer_text(answer_file, answer)

    print(f"{args.prefix}{_truncate(answer, args.max)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
