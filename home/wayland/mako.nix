{ config, lib, pkgs, ... }:

{
  programs.mako = {
    enable = true;

    settings = {
      default-timeout = 5000;

      background-color = "#282828";
      text-color       = "#ebdbb2";
      border-color     = "#928374";
      progress-color   = "#b8bb26";

      border-size = 2;
      padding     = 10;
      margin      = 20;

      font = "Inter 12";
      anchor = "top-right";
    };
  };
}
