# /etc/nixos/configuration.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    waylock
    swayidle
  ];

  services.logind.extraConfig = ''
    HandleLidSwitch=lock
  '';
}
