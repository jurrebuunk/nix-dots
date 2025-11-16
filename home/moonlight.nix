# modules/moonlight.nix
{ config, pkgs, ... }:
{
  programs.moonlight = {
    enable = true;
    package = pkgs.moonlight-qt;
  };
}
