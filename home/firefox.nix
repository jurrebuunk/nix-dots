{ config, pkgs, lib, ... }:

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
