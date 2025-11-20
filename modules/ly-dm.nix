{ config, pkgs, ... }:

{
  services.xserver.enable = false; # geen traditionele X11 display manager

  # Just enable Ly
  services.displayManager.ly.enable = true;

  environment.systemPackages = with pkgs; [
    zig
    brightnessctl
  ];
}
