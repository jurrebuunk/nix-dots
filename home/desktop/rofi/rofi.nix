{ config, pkgs, theme, ... }:

let
  rofiLauncher = ''
    configuration {
      show-icons: false;
      icon-theme: "Vimix-dark";
      display-drun: "app";
      display-run: "command";
      font: "CaskaydiaCove Nerd Font 10";
    }

    window {
      location: north;
      anchor: north;
      x-offset: 0px;
      y-offset: 0px;
      width: 100%;
      height: 20px;
      padding: 0px;
      border: 0px 0px 2px 0px;
      border-color: ${theme.colors.gray};
      children: [ horibox ];
    }

    horibox {
      orientation: horizontal;
      children: [ inputbar, listview ];
      spacing: 8px;
      padding: 0px 6px;
      background-color: ${theme.colors.bg};
    }

    inputbar {
      orientation: horizontal;
      children: [ entry ];
      expand: false;
      width: 28%;
      padding: 0px;
      background-color: ${theme.colors.bg};
    }

    entry {
      expand: true;
      placeholder: "launch…";
      placeholder-color: ${theme.colors.gray};
      text-color: ${theme.colors.fg};
      cursor-color: ${theme.colors.fg};
      background-color: ${theme.colors.bg};
    }

    listview {
      layout: horizontal;
      flow: horizontal;
      lines: 1;
      columns: 5;
      fixed-height: true;
      dynamic: true;
      scrollbar: false;
      spacing: 4px;
      padding: 0px;
      background-color: ${theme.colors.bg};
    }

    element {
      orientation: horizontal;
      children: [ element-text ];
      padding: 0px 6px;
      background-color: ${theme.colors.bg};
      text-color: ${theme.colors.fg};
    }

    element selected.normal {
      background-color: ${theme.colors.gray};
      text-color: ${theme.colors.bg};
    }

    element-text {
      vertical-align: 0.5;
      background-color: transparent;
      text-color: inherit;
    }

    * {
      background: ${theme.colors.bg};
      background-color: ${theme.colors.bg};
      foreground: ${theme.colors.fg};
      border-color: ${theme.colors.gray};
      separatorcolor: ${theme.colors.gray};
      scrollbar-handle: ${theme.colors.gray};

      normal-background: ${theme.colors.bg};
      normal-foreground: ${theme.colors.fg};

      alternate-normal-background: ${theme.colors.bg};
      alternate-normal-foreground: ${theme.colors.fg};

      selected-normal-background: ${theme.colors.gray};
      selected-normal-foreground: ${theme.colors.bg};

      active-background: ${theme.colors.blue};
      active-foreground: ${theme.colors.bg};
      alternate-active-background: ${theme.colors.blue};
      alternate-active-foreground: ${theme.colors.bg};
      selected-active-background: ${theme.colors.blue};
      selected-active-foreground: ${theme.colors.bg};

      urgent-background: ${theme.colors.red};
      urgent-foreground: ${theme.colors.bg};
      alternate-urgent-background: ${theme.colors.red};
      alternate-urgent-foreground: ${theme.colors.bg};
      selected-urgent-background: ${theme.colors.red};
      selected-urgent-foreground: ${theme.colors.bg};
    }
  '';
  piLauncher = ''
    configuration {
      show-icons: false;
      font: "${theme.fonts.main} ${theme.fonts.size}";
    }

    window {
      width: 30%;
      border: 2px;
      border-color: ${theme.colors.gray};
      background-color: ${theme.colors.bg};
    }

    mainbox {
      children: [ inputbar, listview ];
      spacing: 0px;
      padding: 0px;
      background-color: ${theme.colors.bg};
    }

    inputbar {
      children: [ prompt, entry ];
      spacing: 8px;
      padding: 8px 10px;
      border: 1px;
      border-color: ${theme.colors.gray};
      background-color: ${theme.colors.bg};
    }

    prompt {
      background-color: ${theme.colors.bg};
      text-color: ${theme.colors.gray};
    }

    entry {
      background-color: ${theme.colors.bg};
      placeholder: "Ask pi…";
      placeholder-color: ${theme.colors.gray};
      text-color: ${theme.colors.fg};
      cursor-color: ${theme.colors.fg};
    }

    listview {
      lines: 6;
      fixed-height: false;
      padding: 4px 0px 0px 0px;
      spacing: 2px;
      background-color: ${theme.colors.bg};
    }

    element {
      padding: 4px 6px;
      background-color: ${theme.colors.bg};
      text-color: ${theme.colors.fg};
    }

    element selected.normal {
      background-color: ${theme.colors.gray};
      text-color: ${theme.colors.bg};
    }
  '';

in
{
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

  xdg.configFile."rofi/config.rasi" = {
    text = rofiLauncher;
    force = true;
  };

  xdg.configFile."rofi/pi.rasi" = {
    text = piLauncher;
    force = true;
  };
}
