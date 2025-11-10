{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    profiles.default = {
      name = "default";

      userChrome = ''
        :root {
          --toolbar-bgcolor: #1e1e2e !important;
          --toolbar-text-color: #cdd6f4 !important;
          --tab-selected-bgcolor: #313244 !important;
          --tab-hover-bgcolor: #45475a !important;
          --tab-line-color: #89b4fa !important;
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
      '';
    };
  };
}
