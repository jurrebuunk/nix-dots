{ config, pkgs, theme, ... }:

let
  c = theme.colors;
  f = theme.fonts;
  g = theme.geometry;
  s = theme.layout.spacing;

  # Pi prompt theme stays local because it is tied to Jurre's local Pi scripts.
  piLauncher = ''
    configuration {
      show-icons: false;
      font: "${f.mono} ${toString f.sizes.ui}";
    }

    window {
      width: 30%;
      border: ${g.border.widthPx};
      border-color: ${c.border};
      background-color: ${c.background};
    }

    mainbox {
      children: [ inputbar, listview ];
      spacing: 0px;
      padding: 0px;
      background-color: ${c.background};
    }

    inputbar {
      children: [ prompt, entry ];
      spacing: ${toString s.md}px;
      padding: ${toString s.md}px ${toString s.lg}px;
      border: ${g.border.widthPx};
      border-color: ${c.border};
      background-color: ${c.background};
    }

    prompt {
      background-color: ${c.background};
      text-color: ${c.textMuted};
    }

    entry {
      background-color: ${c.background};
      placeholder: "Ask pi…";
      placeholder-color: ${c.textMuted};
      text-color: ${c.text};
      cursor-color: ${c.terminal.cursor};
    }

    listview {
      lines: 6;
      fixed-height: false;
      padding: ${toString s.xs}px 0px 0px 0px;
      spacing: ${toString s.xxs}px;
      background-color: ${c.background};
    }

    element {
      padding: ${toString s.xs}px ${toString s.sm}px;
      background-color: ${c.background};
      text-color: ${c.text};
    }

    element selected.normal {
      background-color: ${c.states.active};
      text-color: ${c.background};
    }
  '';
in
{
  # Keep Jurre's launcher behavior while rofi's main visual theme comes from
  # inputs.jurre-theme.homeManagerModules.rofi.
  home.file.".local/bin/rofi-bar-launcher" = {
    executable = true;
    text = ''
      #!/bin/sh
      mode="''${1:-drun}"
      had_waybar=0
      restored_waybar=0

      restore_waybar() {
        if [ "$had_waybar" -eq 1 ] && [ "$restored_waybar" -eq 0 ]; then
          restored_waybar=1
          nohup ${pkgs.waybar}/bin/waybar >"${config.xdg.cacheHome}/waybar.log" 2>&1 &
        fi
      }
      trap restore_waybar EXIT
      trap 'restore_waybar; exit 130' INT
      trap 'restore_waybar; exit 143' TERM

      if ${pkgs.procps}/bin/pgrep -x waybar >/dev/null 2>&1; then
        had_waybar=1
        ${pkgs.procps}/bin/pkill -x waybar >/dev/null 2>&1 || true
        sleep 0.05
      fi

      ${pkgs.rofi}/bin/rofi -show "$mode"
      status=$?
      exit "$status"
    '';
  };

  xdg.configFile."rofi/pi.rasi" = {
    text = piLauncher;
    force = true;
  };
}
