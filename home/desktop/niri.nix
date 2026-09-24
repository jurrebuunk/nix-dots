{ config, pkgs, theme, ... }:

let
  c = theme.colors;
  g = theme.geometry;
  spacing = theme.layout.spacing;
  # Keep outer gaps at the theme's 8px while making inner gaps 3px larger.
  innerWindowGap = spacing.md + 3;
  outerGapCompensation = spacing.md - innerWindowGap;
  cursor = theme.cursor;
in
{
  home.packages = with pkgs; [
    niri
    xwayland-satellite
  ];

  programs.waybar.systemd.enable = false;

  xdg.configFile."niri/config.kdl".text = ''
    prefer-no-csd

    environment {
      DISPLAY ":12"
      XCURSOR_SIZE "${toString cursor.size}"
      XCURSOR_THEME "${cursor.name}"
      NIXOS_OZONE_WL ""
      ELECTRON_OZONE_PLATFORM_HINT "x11"
      ELECTRON_ENABLE_WAYLAND "0"
      OZONE_PLATFORM "x11"
    }

    cursor {
      xcursor-theme "${cursor.name}"
      xcursor-size ${toString cursor.size}
    }

    hotkey-overlay {
      skip-at-startup
    }

    input {
      mod-key "Super"
      mod-key-nested "Alt"

      touchpad {
        tap
        dwt
        natural-scroll
        middle-emulation
        tap-button-map "left-middle-right"
        click-method "button-areas"
        scroll-method "two-finger"
      }
    }

    layout {
      gaps ${toString innerWindowGap}
      struts {
        left ${toString outerGapCompensation}
        right ${toString outerGapCompensation}
        top ${toString outerGapCompensation}
        bottom ${toString outerGapCompensation}
      }
      center-focused-column "never"

      default-column-width {}

      background-color "${c.background}"

      focus-ring {
        off
      }

      border {
        width ${toString g.border.width}
        active-color "${c.accent}"
        inactive-color "${c.border}"
        urgent-color "${c.error}"
      }

      // Hard, background-colored 2px outer border around the normal 1px window border.
      shadow {
        on
        softness 0
        spread 3
        offset x=0 y=0
        color "${c.background}"
        inactive-color "${c.background}"
      }
    }

    animations {
      slowdown 0.65
    }

    output "eDP-1" {
      scale ${toString theme.display.scale}
    }

    overview {
      zoom 0.5
      backdrop-color "${c.background}"
    }

    gestures {
      hot-corners {
        off
      }
    }

    window-rule {
      match title="^Hermes$"

      open-floating true
      default-column-width { fixed 600; }
      default-window-height { fixed 600; }
    }

    spawn-at-startup "${pkgs.xwayland-satellite}/bin/xwayland-satellite" ":12"
    spawn-at-startup "${pkgs.swayosd}/bin/swayosd-server"
    spawn-at-startup "${pkgs.swaybg}/bin/swaybg" "-i" "${theme.wallpaper}" "-m" "fill"
    spawn-at-startup "${pkgs.waybar}/bin/waybar"
    spawn-at-startup "${pkgs.dbus}/bin/dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "DISPLAY=:12" "XDG_CURRENT_DESKTOP=niri" "XDG_SESSION_TYPE=wayland" "NIXOS_OZONE_WL=" "ELECTRON_OZONE_PLATFORM_HINT=x11" "ELECTRON_ENABLE_WAYLAND=0" "OZONE_PLATFORM=x11" "XCURSOR_SIZE=${toString cursor.size}" "XCURSOR_THEME=${cursor.name}"
    spawn-at-startup "${pkgs.systemd}/bin/systemctl" "--user" "import-environment" "WAYLAND_DISPLAY" "DISPLAY" "XDG_CURRENT_DESKTOP" "XDG_SESSION_TYPE" "NIXOS_OZONE_WL" "ELECTRON_OZONE_PLATFORM_HINT" "ELECTRON_ENABLE_WAYLAND" "OZONE_PLATFORM" "XCURSOR_SIZE" "XCURSOR_THEME"
    spawn-at-startup "${pkgs.systemd}/bin/systemctl" "--user" "restart" "swayidle.service"
    spawn-at-startup "${pkgs.systemd}/bin/systemctl" "--user" "restart" "kanshi.service"
    spawn-at-startup "${pkgs.systemd}/bin/systemctl" "--user" "restart" "mako.service"
    spawn-at-startup "${pkgs.gtklock}/bin/gtklock" "-d"

    binds {
      Mod+Return { spawn "${pkgs.alacritty}/bin/alacritty"; }
      Mod+Space { spawn "${config.home.homeDirectory}/.local/bin/rofi-bar-launcher" "drun"; }
      Mod+Alt+Space { spawn "${config.home.homeDirectory}/.local/bin/rofi-bar-launcher" "run"; }
      Mod+X { close-window; }
      Mod+Shift+R { spawn-sh "niri msg action load-config-file"; }
      Mod+Ctrl+Q { quit skip-confirmation=true; }

      Mod+H { focus-column-left; }
      Mod+J { focus-window-down; }
      Mod+K { focus-window-up; }
      Mod+L { focus-column-right; }

      Mod+Ctrl+H { move-column-left; }
      Mod+Ctrl+J { move-window-down; }
      Mod+Ctrl+K { move-window-up; }
      Mod+Ctrl+L { move-column-right; }

      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }
      Mod+0 { focus-workspace 10; }

      Mod+Ctrl+1 { move-column-to-workspace 1; }
      Mod+Ctrl+2 { move-column-to-workspace 2; }
      Mod+Ctrl+3 { move-column-to-workspace 3; }
      Mod+Ctrl+4 { move-column-to-workspace 4; }
      Mod+Ctrl+5 { move-column-to-workspace 5; }
      Mod+Ctrl+6 { move-column-to-workspace 6; }
      Mod+Ctrl+7 { move-column-to-workspace 7; }
      Mod+Ctrl+8 { move-column-to-workspace 8; }
      Mod+Ctrl+9 { move-column-to-workspace 9; }
      Mod+Ctrl+0 { move-column-to-workspace 10; }

      // Best-effort mappings for sway-only layout actions.
      Mod+A { center-column; }
      Mod+E { toggle-column-tabbed-display; }
      Mod+G { consume-window-into-column; }
      Mod+S { set-column-display "tabbed"; }
      Mod+W { toggle-column-tabbed-display; }

      Mod+M { maximize-column; }
      Mod+F { fullscreen-window; }
      Mod+D { toggle-window-floating; }
      Mod+Shift+F { toggle-window-floating; }
      Mod+Ctrl+F { maximize-column; }
      Mod+Minus { set-column-width "-10%"; }
      Mod+Equal { set-column-width "+10%"; }
      Mod+Shift+L { spawn "${pkgs.gtklock}/bin/gtklock" "-d"; }
      Mod+Ctrl+Shift+L { spawn "${pkgs.swaylock}/bin/swaylock"; }

      Mod+Escape { toggle-keyboard-shortcuts-inhibit; }

      XF86Launch8 { spawn "${pkgs.alacritty}/bin/alacritty" "--class" "Hermes" "--title" "Hermes" "-e" "bash" "-lc" "clear; exec env HERMES_TUI=0 hermes chat"; }

      Print { screenshot; }
      Ctrl+Print { screenshot-screen; }
      Alt+Print { screenshot-window; }
      Mod+Shift+S { spawn-sh "grim -g \"$(slurp)\" - | wl-copy"; }

      Mod+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }
      Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
      Mod+WheelScrollLeft { focus-column-left; }
      Mod+WheelScrollRight { focus-column-right; }

      // Leave Mod+MouseLeft/Right unbound so niri's built-in
      // Super+left-drag moves windows and Super+right-drag resizes them.
      Mod+MouseMiddle { close-window; }

      XF86AudioRaiseVolume { spawn "${pkgs.swayosd}/bin/swayosd-client" "--output-volume" "raise"; }
      XF86AudioLowerVolume { spawn "${pkgs.swayosd}/bin/swayosd-client" "--output-volume" "lower"; }
      XF86AudioMute { spawn "${pkgs.swayosd}/bin/swayosd-client" "--output-volume" "mute-toggle"; }
      XF86AudioMicMute { spawn "${pkgs.swayosd}/bin/swayosd-client" "--input-volume" "mute-toggle"; }
      XF86AudioPlay { spawn "${pkgs.swayosd}/bin/swayosd-client" "--playerctl" "play-pause"; }
      XF86AudioPause { spawn "${pkgs.swayosd}/bin/swayosd-client" "--playerctl" "pause"; }
      XF86AudioStop { spawn "${pkgs.swayosd}/bin/swayosd-client" "--playerctl" "stop"; }
      XF86AudioNext { spawn "${pkgs.swayosd}/bin/swayosd-client" "--playerctl" "next"; }
      XF86AudioPrev { spawn "${pkgs.swayosd}/bin/swayosd-client" "--playerctl" "prev"; }
      XF86MonBrightnessUp { spawn "${pkgs.swayosd}/bin/swayosd-client" "--brightness" "raise"; }
      XF86MonBrightnessDown { spawn "${pkgs.swayosd}/bin/swayosd-client" "--brightness" "lower"; }
    }
  '';
}
