{ config, pkgs, theme, ... }:

let
  c = theme.colors;
in
{
  programs.thunderbird = {
    enable = true;

    profiles.default = {
      isDefault = true;

      userChrome = ''
        /* Minimal Thunderbird CSS */
        
        :root {
          --toolbar-bgcolor: ${c.bg} !important;
          --toolbar-text-color: ${c.fg} !important;
          --tab-selected-bgcolor: ${c.blue} !important;
          --tab-hover-bgcolor: ${c.gray} !important;
          --tab-line-color: ${c.orange} !important;
        }

        /* Hide Status Bar */
        #status-bar, #statusbar-display {
          display: none !important;
        }

        /* Match Firefox Toolbar Styling */
        #mail-toolbox, #navigation-toolbox, #tabmail-container {
          background-color: var(--toolbar-bgcolor) !important;
          color: var(--toolbar-text-color) !important;
        }

        /* Hide Window Controls (Close/Min/Max) if CSD is enabled */
        .titlebar-buttonbox-container {
          display: none !important;
        }
        
        /* Hide Menu Bar (use Alt to show if needed, or rely on hamburger menu) */
        #toolbar-menubar {
          display: none !important;
        }

        /* Tab Styling */
        .tab-background[selected="true"] {
          background-color: var(--tab-selected-bgcolor) !important;
        }
        
        .tab-line[selected="true"] {
          background-color: var(--tab-line-color) !important;
        }
      '';

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        
        # General Settings
        "mail.tabs.drawInTitlebar" = true;
        "mail.pane_config.dynamic" = 2; # Vertical Layout
        
        # Privacy / Telemetry (Similar to Firefox)
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
      };
    };
  };
}
