{ config, pkgs, lib, ... }:

let
  theme = import ../../themes/theme.nix;

  rofiLauncher = ''
    configuration {
      show-icons: true;
      icon-theme: "Vimix-dark";
      display-drun: "app";
      display-run: "command";
      font: "CaskaydiaCove Nerd Font 10";
    }

    window {
      width: 40%;
      height: 30%;
      border: 2px;
      border-color: ${theme.colors.gray};
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

      selected-normal-background: #504945;
      selected-normal-foreground: #fbf1c7;

      active-background: #d79921;
      active-foreground: #1d2021;
      alternate-active-background: #d79921;
      alternate-active-foreground: #1d2021;
      selected-active-background: #fabd2f;
      selected-active-foreground: #1d2021;

      urgent-background: #cc241d;
      urgent-foreground: #1d2021;
      alternate-urgent-background: #cc241d;
      alternate-urgent-foreground: #1d2021;
      selected-urgent-background: #fb4934;
      selected-urgent-foreground: #1d2021;
    }
  '';
in
{
  xdg.configFile."rofi/config.rasi" = {
    text = rofiLauncher;
    force = true;
  };
}
