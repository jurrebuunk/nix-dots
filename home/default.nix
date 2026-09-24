{ config, pkgs, inputs, ... }:

{
  imports =
    [
      inputs.nix-index-database.homeModules.default
      ./apps
      ./desktop
      #./moonlight.nix
    ];

  home = {
    username = "jurre";
    homeDirectory = "/home/jurre";
    stateVersion = "24.05";
  };

  programs.bash.enable = true;
}
