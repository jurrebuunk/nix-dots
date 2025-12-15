{ pkgs, ... }: 

{
  #import configurations for user specific sway desktop environment
  imports = [
    ./sway
    ./gtk.nix
    ./mako.nix
    ./niri.nix
    ./waybar.nix
    ./rofi
  ];
}
