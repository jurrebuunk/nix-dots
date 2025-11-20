# /etc/nixos/configuration.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gtklock
    swayidle
    swaylock
  ];
}
