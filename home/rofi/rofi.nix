{ config, pkgs, lib, ... }:

let
  theme = import ../../themes/theme.nix;

  rofiTheme = ''
    * {
      color-fg: #E2E8F0;
      color-bg: #242B38;
      color-black: #282C34;
      color-blue: #61AFEF;
      color-yellow: #E5C07B;
      color-red: #E06C75;
      color-white: #AAB2BF;
      color-green: #98C379;
      color-gray: #3E4452;
      color-lightgray: #5C6370;
      rounded-sm: 2px;
      rounded-md: 6px;
      rounded-lg: 8px;
      rounded-xl: 12px;
      rounded-full: 9999px;
    }

    // vi: ft=css
  '';

  rofiLauncher = ''
    configuration {
      modi: "drun";
      show-icons: true;
      icon-theme: "Vimix-dark";
      display-drun: "app";
      font: "CaskaydiaCove Nerd Font 14";
    }

    @import "theme.rasi"

    * {
      transparency: "real";
      text-color: @color-fg;
      background-color: @color-bg;
    }

    window {
      width: 30%;
      height: 42%;
      border: 2px;
      border-color: @color-gray;
      padding: 8px 12px;
      border-radius: @rounded-md;
    }

    inputbar {
      margin: 8px 0;
    }

    prompt {
      text-color: @color-black;
      padding: 4px 8px;
      border-radius: @rounded-sm;
      background-color: @color-green;
    }

    entry {
      padding: 4px;
    }

    listview {
      columns: 2;
    }

    element {
      padding: 8px 10px;
      border-radius: @rounded-sm;
    }

    element selected {
      background-color: @color-gray;
    }

    element-icon {
      margin: 0 8px 0 0;
    }

    element-text {
      font: "Roboto 14";
    }

    element-icon selected {
      background-color: @color-gray;
    }

    element-text selected {
      background-color: @color-gray;
    }

    // vi: ft=css

  '';
in
{
  xdg.configFile."rofi/theme.rasi" = {
    text = rofiTheme;
    force = true;
  };

  xdg.configFile."rofi/config.rasi" = {
    text = rofiLauncher;
    force = true;
  };
}
