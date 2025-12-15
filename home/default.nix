{ config, pkgs, ... }:

{
  imports =
    [
      ./apps
      ./desktop
    ];

  home = {
    username = "jurre";
    homeDirectory = "/home/jurre";
    stateVersion = "24.05";
  };
}
