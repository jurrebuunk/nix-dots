{ config, pkgs, ... }:

{
  services.xserver.enable = false; # geen traditionele X11 display manager
  services.displayManager.ly.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  environment.systemPackages = with pkgs; [
    zig
    brightnessctl
    xorg.xauth
    xorg.xorgserver
  ];

}
