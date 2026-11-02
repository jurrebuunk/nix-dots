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

  programs.firefox.configPath = ".mozilla/firefox";

  programs.touchdesigner-linux = {
    enable = true;

    plugins.td-hueControl = pkgs.fetchzip {
      url = "https://github.com/SudoMagicCode/td-hueControl/releases/download/v1.1.10/package.zip";
      hash = "sha256-C/qdze9cpK31HQlw9lZp19t8HYRf6PyeIG3ys520RIY=";
      stripRoot = false;
    };
  };
}
