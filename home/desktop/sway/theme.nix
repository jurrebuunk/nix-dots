{ config, pkgs, lib, theme, ... }:

let
  c = theme.colors;
  f = theme.fonts;
in {
  wayland.windowManager.sway.extraConfig = ''
    # Border settings
    default_border pixel 2
    default_floating_border pixel 2

    # Force borders for Libadwaita/CSD apps and dialogs
    for_window [app_id=".*"] border pixel 2
    for_window [window_role=".*"] border pixel 2
    for_window [window_type="dialog"] border pixel 2
    for_window [window_type="utility"] border pixel 2
    for_window [window_type="toolbar"] border pixel 2
    for_window [window_type="splash"] border pixel 2
    for_window [window_type="menu"] border pixel 2
    for_window [window_type="dropdown_menu"] border pixel 2
    for_window [window_type="popup_menu"] border pixel 2
    for_window [window_type="tooltip"] border pixel 2

    exec_always swaybg -i ${theme.wallpaper} -m fill

    # Font from theme
    font pango:${f.main} ${f.size}

    # Gruvbox colors from theme
    client.focused          ${c.blue} ${c.blue} ${c.fg} ${c.blue} ${c.blue}
    client.focused_inactive ${c.gray} ${c.gray} ${c.fg} ${c.gray} ${c.gray}
    client.unfocused        ${c.gray} ${c.gray} ${c.gray} ${c.gray} ${c.gray}
    client.urgent           ${c.red} ${c.red} ${c.fg} ${c.red} ${c.red}
    client.placeholder      ${c.bg} ${c.bg} ${c.fg} ${c.bg} ${c.bg}

    bar {
      position top
      status_command i3status
      colors {
        background ${c.bg}
        statusline ${c.fg}
        separator  ${c.gray}

        focused_workspace  ${c.blue} ${c.blue} ${c.fg}
        active_workspace   ${c.gray} ${c.gray} ${c.fg}
        inactive_workspace ${c.bg} ${c.bg} ${c.gray}
        urgent_workspace   ${c.red} ${c.red} ${c.fg}
      }
    }

    # Gestures
    bindgesture swipe:left workspace next
    bindgesture swipe:right workspace prev

    bindgesture pinch:inward+up move up
    bindgesture pinch:inward+down move down
    bindgesture pinch:inward+left move left
    bindgesture pinch:inward+right move right

  '';
}
