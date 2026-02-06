{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-mono
    nerd-fonts.martian-mono
    ibm-plex-mono-nerd
    noto-fonts
    noto-fonts-color-emoji
  ];
}
