# /etc/nixos/configuration.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    waylock
    swayidle
  ];
}
