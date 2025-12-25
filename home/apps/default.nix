{ pkgs, ... }:

{
  imports = [
    ./firefox.nix
    ./libreoffice.nix
    ./element-desktop.nix
    ./winapps.nix
    ./vscodium.nix
    ./wezterm.nix
    ./custom-desktop-entries.nix
    ./thunderbird.nix
    ./alacritty.nix
    ./partyfuse.nix
    ./rclone-mount.nix
  ];
}
