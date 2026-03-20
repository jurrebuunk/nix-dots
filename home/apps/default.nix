{ pkgs, ... }:

{
  imports = [
    ./firefox.nix
    ./libreoffice.nix
    ./alacritty.nix
    ./rclone-mount.nix
    ./supersonic.nix
    ./thunar.nix
    ./loupe.nix
    ./packet-tracer.nix
  ];
}
