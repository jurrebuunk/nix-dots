{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;

    layout = "in";
    xkbVariant = "eng";

    displayManager.defaultSession = "none+i3";

    desktopManager.xterm.enable = false;

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
  };

  programs.dconf.enable = true;
}

