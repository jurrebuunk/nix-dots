{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-mono
    ibm-plex-mono-nerd
    noto-fonts
    noto-fonts-color-emoji
  ];
}
