{ config, pkgs, lib, ... }:

let
  themeDir = "${config.home.homeDirectory}/.config/wofi/themes";
in
{
  home.packages = with pkgs; [
    wofi
  ];

  xdg.configFile."wofi/style.css".text = ''
    /* Example Wofi style */
    window {
      background-color: #1e1e2e;
      border-radius: 10px;
      padding: 10px;
    }

    entry {
      font: 12pt "FiraCode Nerd Font";
      color: #cdd6f4;
      padding: 5px 10px;
    }

    entry:selected {
      background-color: #89b4fa;
      color: #1e1e2e;
    }
  '';
}
