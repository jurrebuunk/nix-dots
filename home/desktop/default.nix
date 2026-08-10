{ pkgs, ... }: 

{
  # import configurations for user specific desktop environments
  imports = [
    ./sway
    ./scroll.nix
    ./niri.nix
    ./gtk.nix
    ./mako.nix
    ./swaync.nix
    ./waybar.nix
    ./swayosd.nix
    ./rofi
    ./battery-notify.nix
    ./volume-control.nix
    ./brightness-control.nix
  ];
}
