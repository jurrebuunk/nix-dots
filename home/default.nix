{ config, pkgs, ... }:

{
  imports =
    [
      ./vscodium.nix
      ./wezterm.nix
      ./wayland
      ./rofi
      ./element-desktop.nix
      ./winapps.nix
      ./firefox.nix
      ./libreoffice.nix
    ];

  home = {
    username = "jurre";
    homeDirectory = "/home/jurre";
    stateVersion = "24.05";
  };
}
