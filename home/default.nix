{ config, pkgs, ... }:

{
  imports =
    [
      ./apps
      ./desktop
      ./moonlight.nix
    ];

  home = {
    username = "jurre";
    homeDirectory = "/home/jurre";
    stateVersion = "24.05";
  };
}
