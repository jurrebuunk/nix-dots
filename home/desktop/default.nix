{ pkgs, ... }: 

{
  #import configurations for user specific sway desktop environment
  imports = [
    ./sway
    ./scroll.nix
    ./gtk.nix
    ./mako.nix
    ./waybar.nix
    ./rofi
    ./battery-notify.nix
    ./volume-control.nix
    ./brightness-control.nix
  ];
}
