{ config, pkgs, ... }:

{
  imports =
    [
      ./vscodium.nix
      ./wezterm.nix
      ./wayland
      ./element-desktop.nix
      ./winapps.nix
      ./firefox.nix
    ];

  home = {
    username = "jurre";
    homeDirectory = "/home/jurre";
    stateVersion = "24.05";
  };
}
