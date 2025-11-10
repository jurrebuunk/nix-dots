{ config, pkgs, ... }:

let
  theme = import ../themes/theme.nix;
  c = theme.colors;
in
{
  programs.firefox = {
    enable = true;

    profiles.default = {
      name = "default";

      userChrome = ''
        :root {
          --toolbar-bgcolor: ${c.bg} !important;
          --toolbar-text-color: ${c.fg} !important;
          --tab-selected-bgcolor: ${c.blue} !important;
          --tab-hover-bgcolor: ${c.gray} !important;
          --tab-line-color: ${c.orange} !important;
        }

        #navigator-toolbox {
          background-color: var(--toolbar-bgcolor) !important;
          color: var(--toolbar-text-color) !important;
        }

        .tab-background[selected="true"] {
          background-color: var(--tab-selected-bgcolor) !important;
        }

        .tab-background:hover {
          background-color: var(--tab-hover-bgcolor) !important;
        }

        .tab-line[selected="true"] {
          background-color: var(--tab-line-color) !important;
        }
      '';

      extraConfig = ''
        user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
        user_pref("layout.css.prefers-color-scheme.content-override", 1); // Force dark mode for websites
      '';
    };
  };
}
