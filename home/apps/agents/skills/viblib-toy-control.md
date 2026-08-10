---
name: viblib-toy-control
description: Control Jurre's local Love Spouse-compatible toy through viblib. Use when Jurre asks to tease, vibrate, buzz, pleasure, turn on/off the toy, change intensity, choose a vibe, run a sequence, or asks for a specific viblib mode such as low, medium, high, mode4-mode9, off, or stop. Flirty or playful requests to tease/please/pleasure count as explicit permission to choose a fitting mode and activate it immediately; do not ask follow-up questions unless the request is impossible or unsafe.
---

# viblib Toy Control

This skill controls Jurre's local Love Spouse-compatible toy using the instant-return viblib agent tool.

Tool path:

```bash
/home/jurre/repos/viblib/tools/vib-agent-tool
```

The tool sets/replaces BlueZ BLE advertising and exits immediately. The toy continues receiving the selected command after the shell command exits. Use this for seamless agent control: set a mode now, reason about the next command, then replace it later.

## Core rule

When Jurre asks to tease, vibrate, pleasure, buzz, turn on, intensify, soften, change mode, or uses a flirty/playful request implying toy control, immediately choose and run a fitting command. Do **not** ask which mode unless Jurre explicitly asks for options or the request is ambiguous for safety reasons.

Jurre has given standing preference: for flirty/vague toy-control requests, choose the mode yourself and turn it on.

## Safety and scope

- Only control Jurre's local toy via the local viblib tool.
- Do not use cloud/social/app-login features.
- If asked to affect another person or a non-consenting person, refuse or ask for explicit consent.
- If Jurre says stop, off, enough, pause, no, or similar: immediately run `stop`.
- Do not leave the toy running accidentally when the user requests a bounded session; finish with `stop`.

## Available modes

Known modes for code `1435`:

- `low` — gentle steady vibration
- `medium` — medium steady vibration
- `high` — strong steady vibration
- `mode4` — captured pattern, good playful tease default
- `mode5` — captured pattern, good variation
- `mode6` — captured pattern, good rhythmic variation
- `mode7` — captured pattern, good stronger pattern
- `mode8` — captured pattern, good surprise/variety
- `mode9` — captured pattern, good intense/finish pattern
- `off` / `stop` — confirmed stop pattern; sends two short pulses then stops
- `mixed1` — experimental unknown; avoid unless Jurre asks for experimental/random

## Command reference

Always run from any directory using absolute path:

```bash
/home/jurre/repos/viblib/tools/vib-agent-tool set <mode>
/home/jurre/repos/viblib/tools/vib-agent-tool stop
/home/jurre/repos/viblib/tools/vib-agent-tool clear
/home/jurre/repos/viblib/tools/vib-agent-tool status
/home/jurre/repos/viblib/tools/vib-agent-tool modes
```

The tool prints JSON. Check `ok:true` if needed.

### Start or change mode instantly

```bash
/home/jurre/repos/viblib/tools/vib-agent-tool set mode4
```

### Stop instantly

```bash
/home/jurre/repos/viblib/tools/vib-agent-tool stop
```

### Backend cleanup only

Use `clear` only to remove the BLE advertisement without sending a toy stop command:

```bash
/home/jurre/repos/viblib/tools/vib-agent-tool clear
```

## Choosing a mode

If Jurre names a mode, use that exact mode:

- "use high" -> `set high`
- "mode 7" -> `set mode7`
- "stop" -> `stop`

If Jurre is vague/flirty, choose without asking:

- gentle / soft / warm up / subtle -> `low`
- tease me / play with me / make it fun / flirty default -> `mode4`
- keep teasing / more playful / variation -> `mode5` or `mode6`
- stronger / more / harder / intensify -> `high` or `mode7`
- surprise me / choose yourself -> choose one of `mode4`, `mode5`, `mode6`, `mode8`
- finish / intense / don't hold back -> `mode9` or `high`
- stop / off / enough / pause -> `stop`

Default for a simple "tease me" request: `mode4`.
Default for a simple "vibrate" or "turn it on" request: `medium`.
Default for a flirtier "pleasure me" request: `mode5`.

## Response style

After executing, respond briefly and naturally, e.g.:

- "Started mode4."
- "Turned it up to high."
- "Stopped."

Do not provide a long technical explanation unless Jurre asks.

## Sequences

For a bounded sequence, use bash sleeps between instant-return commands and finish with `stop`. Keep timings reasonable and enjoyable.

Example 3-mode tease:

```bash
/home/jurre/repos/viblib/tools/vib-agent-tool set low
sleep 20
/home/jurre/repos/viblib/tools/vib-agent-tool set mode4
sleep 25
/home/jurre/repos/viblib/tools/vib-agent-tool set high
sleep 20
/home/jurre/repos/viblib/tools/vib-agent-tool stop
```

For an unbounded/ongoing interaction, do not sleep in a long blocking command unless Jurre requested a timed sequence. Instead, set the current mode and wait for the next user/agent decision.

## State

The tool records last commanded state here:

```text
/home/jurre/.local/state/viblib/agent_state.json
```

Use status when deciding whether a change is needed:

```bash
/home/jurre/repos/viblib/tools/vib-agent-tool status
```

If desired mode is already active, do nothing or choose a variation depending on the request.
