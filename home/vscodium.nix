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
      "editor.fontFamily" = theme.fonts.main;
      "terminal.integrated.fontFamily" = theme.fonts.main;
      "markdown.preview.fontFamily" = theme.fonts.main;
      "workbench.colorTheme" = "Gruvbox Dark Hard";
    };
  };
}
