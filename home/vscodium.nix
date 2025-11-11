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
      databricks.databricks
    ];

    userSettings = {
      "editor.fontFamily" = "CaskaydiaMono Nerd Font";
      "terminal.integrated.fontFamily" = "CaskaydiaMono Nerd Font";
      "markdown.preview.fontFamily" = "CaskaydiaMono Nerd Font";
      "workbench.colorTheme" = "Gruvbox Dark Hard";
      "git.suggestSmartCommit" = false;
      "git.confirmSync" = false;

      # dbcode extension settings
      "dbcode.connections" = [
        {
          connectionId = "0h_zttEmBLle2vjmY4TZN";
          name = "SYBAU";
          driver = "mariadb";
          connectionType = "host";
          host = "145.74.104.79";
          port = 3306;
          ssl = true;
          sslTrustCertificate = true;
          username = "2170755";
          password = "";
          savePassword = "secretStorage";
          readOnly = false;
          postConnectionSqlType = "inline";
          driverOptions = {
            retrievePublickey = true;
          };
        }
      ];
    };
  };
}
