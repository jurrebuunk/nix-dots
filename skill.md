# Scroll WM app launch notes

- Session: Wayland, `XDG_CURRENT_DESKTOP=scroll`, `WAYLAND_DISPLAY=wayland-1`.
- Use `scrollmsg exec` to launch apps in the focused workspace.
- Preferred commands:
  - Terminal: `scrollmsg exec "alacritty --title pi"`
  - Firefox: `scrollmsg exec "firefox --new-window"`
  - VS Code: `scrollmsg exec "code"`
  - Pi terminal: `scrollmsg exec "alacritty --title pi -e pi"`
- If needed, switch first with `scrollmsg exec "swaymsg workspace 4"`.
- Verify with `scrollmsg -t get_tree`.
- Current useful workspace found: workspace 4.
