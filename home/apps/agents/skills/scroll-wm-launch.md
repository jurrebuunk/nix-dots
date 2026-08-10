---
name: scroll-wm-launch
description: Launch terminals, Firefox, or other GUI apps on the current focused Scroll WM screen/workspace. Use when the user asks to open an application, terminal, browser, or Firefox in their current Scroll WM session.
compatibility: Linux Wayland session with Scroll WM and scrollmsg available.
---

# Scroll WM App Launch

Use this skill when the user wants an app opened on their current screen/workspace in Scroll WM.

## Detect the session

Check that Scroll WM is active:

```bash
echo "DISPLAY=$DISPLAY WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_SESSION_TYPE=$XDG_SESSION_TYPE DESKTOP=$XDG_CURRENT_DESKTOP"
command -v scrollmsg
scrollmsg -t get_outputs
scrollmsg -t get_workspaces
```

Expected desktop/session values on this machine include:

- `XDG_SESSION_TYPE=wayland`
- `XDG_CURRENT_DESKTOP=scroll`
- `WAYLAND_DISPLAY=wayland-1`

## Launch on the current focused screen/workspace

Prefer `scrollmsg exec` instead of starting GUI apps directly from the agent shell. This asks Scroll WM to launch the app in the active compositor context/current workspace.

### Terminal

Use Alacritty for a terminal:

```bash
term=$(command -v alacritty || true)
[ -n "$term" ] && scrollmsg exec "$term"
```

If you need a recognizable test window:

```bash
term=$(command -v alacritty || true)
[ -n "$term" ] && scrollmsg exec "$term --title scroll-current-screen-test-terminal"
```

### Firefox

Open a new Firefox window on the current workspace:

```bash
firefox=$(command -v firefox || true)
[ -n "$firefox" ] && scrollmsg exec "$firefox --new-window"
```

Open a specific page:

```bash
firefox=$(command -v firefox || true)
[ -n "$firefox" ] && scrollmsg exec "$firefox --new-window about:blank"
```

## Verify the app appeared

After launching, wait briefly and inspect the Scroll tree:

```bash
sleep 1
scrollmsg -t get_tree | jq '.. | objects | select(.focused? == true) | {name,type,app_id,pid,visible,rect}'
```

For Firefox windows:

```bash
scrollmsg -t get_tree | jq '[.. | objects | select(.app_id? == "firefox") | {id,name,visible,rect}]'
```

For Alacritty windows:

```bash
scrollmsg -t get_tree | jq '[.. | objects | select(.app_id? == "Alacritty") | {id,name,pid,visible,rect}]'
```

## Notes

- Do not use `DISPLAY=:0 app &` as the first choice; Scroll WM's IPC launch is more reliable for the current workspace.
- If `scrollmsg exec` returns `{ "success": true }`, the compositor accepted the launch request.
- The user currently has `$mod+Return` bound to launch Alacritty, but from the agent use `scrollmsg exec`.
