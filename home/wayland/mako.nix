{ config, pkgs, ... }:

let
  theme = import ../../themes/theme.nix;
in {
  services.mako = {
    enable = true;

    settings = {
      default-timeout = 10000;
      background-color = theme.colors.bg;
      text-color       = theme.colors.fg;
      border-color     = theme.colors.gray;
      progress-color   = theme.colors.green;

      border-size = 2;
      padding = 10;
      margin = 20;
      font = "${theme.fonts.main} ${theme.fonts.size}";
      anchor = "top-right";
    };
  };
}
