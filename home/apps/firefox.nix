{ config, pkgs, lib, theme, ... }:

let
  c = theme.colors;
in
{
  programs.firefox = {
    enable = true;
    policies = {
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };


    profiles.default = {
      name = "default";

    userChrome = ''
      :root {
        --toolbar-bgcolor: ${c.bg} !important;
        --toolbar-text-color: ${c.fg} !important;

        --tab-border-color: ${c.gray} !important; /* use gray for all borders */

        --tab-border-radius: 0px !important;
        --toolbarbutton-border-radius: 0px !important;
        --urlbar-border-radius: 0px !important;
        --toolbarbutton-border-color: ${c.gray};  /* Cha ffnge the border color here */
        --toolbarbutton-hover-bg: ${c.gray};      /* Background on hover */
        --toolbarbutton-padding: 0px 0px;       /* Adjust padding inside buttons */
        --toolbarbutton-radius: 0px;            /* Border radius for buttons */
        --toolbarbutton-spacing: 2px;           /* Space between buttons */
        --toolbarbutton-first-left: 6px;       /* Left margin for first button (Back) */
      }

      /* Toolbar */
      #navigator-toolbox {
        background-color: var(--toolbar-bgcolor) !important;
        color: var(--toolbar-text-color) !important;
      }

      /* === SIDEBAR === */
      #sidebar-box,
      #sidebar-main,
      #sidebar-main[expanded],
      .sidebar-panel,
      #vertical-tabs {
        min-width: 10px !important;
        /* Force a specific thin width since dragging is fought by internal JS.
           Adjust 42px to your preference. */
        width: 42px !important; 
        max-width: none !important;
      }

      /* === TABS === */
      #tabbrowser-tabs {
        --tab-border-radius: 0px !important;
      }

      .tab-background {
        border-radius: 0 !important;
        background-color: ${c.bg} !important;

        /* Kill Proton visuals */
        outline: none !important;
        box-shadow: none !important;
        clip-path: none !important;

        /* Real square border */
        border: 2px solid var(--tab-border-color) !important;
        margin: 0 5 0 5px !important;
      }
      
      /* Target native vertical tabs specifically */
      #tabbrowser-tabs[orient="vertical"] .tab-background,
      #vertical-tabs .tab-background {
         margin-left: 6px !important;
         padding-left: 0px !important;
      }
      
      #tabbrowser-tabs[orient="vertical"] .tab-content,
      #vertical-tabs .tab-content {
         padding-left: 0 !important;
         margin-left: 0 !important;
      }

      #tabbrowser-tabs[orient="vertical"] .tab-icon-image,
      #vertical-tabs .tab-icon-image {
         margin-left: 14px !important;
      }
      
      #tabbrowser-tabs[orient="vertical"],
      #vertical-tabs {
         padding-inline: 0px !important;
         margin-inline: 0 !important;
      }
      
      /* New Tab Button in Vertical Sidebar */
      #tabs-newtab-button,
      #new-tab-button,
      .tabs-newtab-button {
        padding-left: 0 !important;
        margin-left: 5px !important;
        width: calc(100% - 5px) !important;
        justify-content: flex-start !important;
      }

      #tabs-newtab-button .toolbarbutton-icon,
      #new-tab-button .toolbarbutton-icon,
      .tabs-newtab-button .toolbarbutton-icon {
        margin-left: 8px !important;
      }
      
      /* Sidebar Tools/Settings Button at bottom */
      #sidebar-main-tools,
      #sidebar-main-tools > toolbarbutton,
      #sidebar-main-tools > .toolbarbutton-1,
      #sidebar-switcher-target,
      .sidebar-footer-button {
         padding-left: 0 !important;
         margin-left: 5px !important;
         justify-content: flex-start !important;
         width: calc(100% - 5px) !important;
         display: flex !important;
      }

      /* Hide sidebar customize/settings controls across Firefox UI variants */
      #sidebar-customize-button,
      #sidebar-customize,
      #sidebar-settings-button,
      #sidebar-settings-expand-button,
      #sidebar-main-tools [id*="customize"],
      #sidebar-main-tools [data-l10n-id*="customize"],
      #sidebar-main-tools [data-l10n-id*="settings"],
      #sidebar-main-tools [aria-label*="customize" i],
      #sidebar-main-tools [aria-label*="settings" i],
      #sidebar-main-tools [tooltiptext*="customize" i],
      #sidebar-main-tools [tooltiptext*="settings" i],
      #sidebar-main-tools [label*="customize" i],
      #sidebar-main-tools [label*="settings" i],
      #sidebar-box [oncommand*="customizeSidebar"],
      #sidebar-box [command*="customize"] {
        display: none !important;
        visibility: collapse !important;
      }

      .tab-background[selected="true"] {
        background-color: ${c.gray} !important;
      }

      .tab-background:hover {
        background-color: ${c.gray} !important;
      }

      /* Remove Proton separators */
      .tab-background::before,
      .tab-background::after {
        display: none !important;
      }

      /* === TOOLBAR BUTTONS (Back, Forward, Reload, etc.) === */
      /* Base style for all toolbar buttons */
      #nav-bar .toolbarbutton-1 {
          border-radius: var(--toolbarbutton-radius) !important;
          box-shadow: none !important;
          outline: none !important;

          border: 2px solid ${c.gray} !important; /* Gray border */
          box-sizing: border-box;   /* Border included in size */

          /* Enforce explicit square size (16px icon + 2*6px padding + 2*2px border = 32px) */
          width: 32px !important;
          height: 32px !important;
          
          /* Center vertically in the toolbar */
          margin-top: auto !important;
          margin-bottom: auto !important;

          /* Remove default padding */
          padding: 0 !important;
      }

      /* Explicitly link button size to inner padding to prevent icon resizing issues */
      #nav-bar .toolbarbutton-1 > .toolbarbutton-icon {
          padding: 6px !important;
          width: 16px !important;
          height: 16px !important;
          box-sizing: content-box !important;
      }

      /* Left margin only for the first button (Back) */
      #nav-bar .toolbarbutton-1:first-child {
          margin-left: var(--toolbarbutton-first-left) !important;
      }

      /* Spacing between other buttons */
      #nav-bar .toolbarbutton-1 + .toolbarbutton-1 {
          margin-left: var(--toolbarbutton-spacing) !important;
      }

      /* Right margin for the last button */
      #nav-bar .toolbarbutton-1:last-child {
          margin-right: 6px !important;
      }

      /* Hover and active states */
      #nav-bar .toolbarbutton-1:hover,
      #nav-bar .toolbarbutton-1:active {
          border: 2px solid ${c.gray} !important;
      }




      /* === URL BAR === */
      #urlbar,
      #urlbar-background {
        border-radius: 0 !important;
        box-shadow: none !important;
        outline: none !important;
        border: 2px solid var(--tab-border-color) !important;
      }

      /* REMOVE border only from the inner input */
      #urlbar input,
      #urlbar .textbox-input-box {
        border: 0 !important;
        box-shadow: none !important;
        outline: none !important;
        background: transparent !important;
      }
    '';

    userContent = ''
      @-moz-document url-prefix("about:"), url-prefix("chrome:") {
        :root {
          --border-radius-medium: 0px !important;
        }

        .top-site-outer .tile {
          border-radius: 0px !important;
          box-shadow: none !important;
        }
      }

      @-moz-document url("about:home"), url("about:newtab") {
        :root,
        body,
        html,
        .activity-stream,
        .activity-stream .outer-wrapper,
        .activity-stream .outer-wrapper::before {
          background: ${c.bg} !important;
          background-image: none !important;
        }

        /* Hide new tab "Customize" button (selector varies by version) */
        .personalize-button,
        button.personalize-button,
        #personalizeButton,
        [data-l10n-id="newtab-personalize-button"] {
          display: none !important;
        }
      }
    '';


      search = {
        force = true;
        default = "ddg";
        privateDefault = "ddg";
        order = ["ddg" "google"];
        engines = {
          ddg = {
            name = "DuckDuckGo";
            urls = [{ template = "https://duckduckgo.com/?q={searchTerms}"; }];
            icon = "https://duckduckgo.com/favicon.ico";
          };
        };
      };

      settings = {
        # Enable userChrome.css support
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.startup.homepage" = "about:home";
        "browser.disableResetPrompt" = true;
        "browser.download.panel.shown" = true;
        "browser.feeds.showFirstRunUI" = false;
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        "browser.rights.3.shown" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.uitour.enabled" = false;
        "startup.homepage_override_url" = "";
        "trailhead.firstrun.didSeeAboutWelcome" = true;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.addedImportButton" = true;
        "browser.download.useDownloadDir" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
        "browser.newtabpage.blocked" = lib.genAttrs [
          "26UbzFJ7qT9/4DhodHKA1Q=="
          "4gPpjkxgZzXPVtuEoAL9Ig=="
          "eV8/WsSLxHadrTL1gAxhug=="
          "gLv0ja2RYVgxKdp0I5qwvA=="
          "K00ILysCaEq8+bEqV/3nuw=="
          "T9nJot5PurhJSy8n038xGA=="
        ] (_: 1);
        "app.shield.optoutstudies.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.sessions.current.clean" = true;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.prompted" = 2;
        "toolkit.telemetry.rejected" = true;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.unifiedIsOptIn" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "identity.fxaccounts.enabled" = false;
        "signon.rememberSignons" = false;
        "privacy.trackingprotection.enabled" = true;
        "dom.security.https_only_mode" = true;
        "browser.tabs.inTitlebar" = 0;
        "sidebar.verticalTabs" = true;
        "sidebar.revamp" = true;
        "sidebar.main.tools" = ["history" "bookmarks"];
        "browser.uiCustomization.state" = builtins.toJSON {
          placements = {
            unified-extensions-area = [];
            widget-overflow-fixed-list = [];
            nav-bar = ["back-button" "forward-button" "vertical-spacer" "stop-reload-button" "urlbar-container" "downloads-button" "ublock0_raymondhill_net-browser-action" "_testpilot-containers-browser-action" "reset-pbm-toolbar-button" "unified-extensions-button"];
            toolbar-menubar = ["menubar-items"];
            TabsToolbar = [];
            vertical-tabs = ["tabbrowser-tabs"];
            PersonalToolbar = ["personal-bookmarks"];
          };
          seen = ["save-to-pocket-button" "developer-button" "ublock0_raymondhill_net-browser-action" "_testpilot-containers-browser-action" "screenshot-button"];
          dirtyAreaCache = ["nav-bar" "PersonalToolbar" "toolbar-menubar" "TabsToolbar" "widget-overflow-fixed-list" "vertical-tabs"];
          currentVersion = 23;
          newElementCount = 10;
        };
      };
    };
  };
}
