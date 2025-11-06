{ pkgs, ... }:

let
  theme = import ../themes/theme.nix;
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default.extensions = with pkgs.vscode-extensions; [
      jdinhlife.gruvbox
      yzhang.markdown-all-in-one
      bradlc.vscode-tailwindcss
    ];

    userSettings = {
      "editor.fontFamily" = "CaskaydiaMono Nerd Font";
      "terminal.integrated.fontFamily" = "CaskaydiaMono Nerd Font";
      "markdown.preview.fontFamily" = "CaskaydiaMono Nerd Font";
      "workbench.colorTheme" = "Gruvbox Dark Hard";
      "git.suggestSmartCommit" = false;
      "git.confirmSync" = false;
    };
  };
}

