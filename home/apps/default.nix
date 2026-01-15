{ pkgs, ... }:

{
  imports = [
    ./firefox.nix
    ./libreoffice.nix
    ./element-desktop.nix
    ./winapps.nix
    ./vscodium.nix
    ./custom-desktop-entries.nix
    ./thunderbird.nix
    ./alacritty.nix
    ./rclone-mount.nix
    ./thunar.nix
    ./loupe.nix
  ];
}
