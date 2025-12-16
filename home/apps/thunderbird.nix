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
        /* Global Variables */
        :root {
          --bg: ${c.bg} !important;
          --fg: ${c.fg} !important;
          --gray: ${c.gray} !important;
          --blue: ${c.blue} !important;
          
          /* Thunderbird Variables Override */
          --toolbar-bgcolor: var(--bg) !important;
          --toolbar-text-color: var(--fg) !important;
          --tab-selected-bgcolor: var(--blue) !important;
          --tab-hover-bgcolor: var(--gray) !important;
          --tab-line-color: transparent !important;
          
          --tree-view-bg: var(--bg) !important;
          --tree-view-text: var(--fg) !important;
          --tree-view-row-height: 28px !important;
          
          --message-list-header-background-color: var(--bg) !important;
          --message-list-header-color: var(--fg) !important;
          
          --sidebar-background-color: var(--bg) !important;
          --sidebar-text-color: var(--fg) !important;
        }

        /* Global Reset to match GTK */
        * {
          border-radius: 0 !important;
          box-shadow: none !important;
          border: none !important;
        }

        /* Main UI Elements */
        #mail-toolbox, 
        #navigation-toolbox, 
        #tabmail-container,
        .tabmail-tab,
        .tab-background,
        #folderPane, 
        #threadTree,
        #messagePane,
        #msgHeaderView,
        window,
        dialog,
        box, hbox, vbox {
          background-color: var(--bg) !important;
          color: var(--fg) !important;
        }

        /* Folder Pane & Thread Pane */
        #folderTree, 
        #threadTree {
          background-color: var(--bg) !important;
          color: var(--fg) !important;
        }

        /* List Rows (Newer TB versions use HTML tables/divs) */
        tr, td, .thread-card-container {
           background-color: var(--bg) !important;
           color: var(--fg) !important;
        }

        /* Selected Items */
        .selected,
        tr.selected,
        tr[is="thread-row"].selected,
        .folder-row.selected {
          background-color: var(--blue) !important;
          color: var(--bg) !important;
        }
        
        /* Hover Items */
        tr:hover,
        .folder-row:hover {
           background-color: var(--gray) !important;
        }

        /* Inputs & Search */
        input, 
        textarea, 
        searchbar, 
        #search-box {
          background-color: var(--bg) !important;
          color: var(--fg) !important;
          border: 2px solid var(--gray) !important;
        }

        /* Buttons */
        button, 
        .button, 
        toolbarbutton {
          background-color: var(--bg) !important;
          color: var(--fg) !important;
          border: 2px solid var(--gray) !important;
          margin: 2px !important;
        }
        
        button:hover,
        toolbarbutton:hover {
           background-color: var(--gray) !important;
           color: var(--bg) !important;
        }

        /* Headers (Message List Columns) */
        th, 
        .tree-table-header {
          background-color: var(--bg) !important;
          color: var(--fg) !important;
          border-bottom: 2px solid var(--gray) !important;
        }

        /* Hide Clutter */
        #status-bar, 
        #statusbar-display, 
        .titlebar-buttonbox-container, 
        #toolbar-menubar {
          display: none !important;
        }
        
        /* Message Header View */
        #msgHeaderView {
           border-bottom: 2px solid var(--gray) !important;
        }
      '';

      userContent = ''
        /* Global Variables */
        :root {
          --bg: ${c.bg} !important;
          --fg: ${c.fg} !important;
          --blue: ${c.blue} !important;
          --gray: ${c.gray} !important;
        }

        /* Message Body Styling (The emails themselves) */
        body {
          background-color: var(--bg) !important;
          color: var(--fg) !important;
        }
        
        /* Links */
        a {
          color: var(--blue) !important;
        }

        /* Selection */
        ::selection {
          background-color: var(--blue) !important;
          color: var(--bg) !important;
        }

        /* Scrollbars */
        scrollbar {
           background-color: var(--bg) !important;
        }

        /* User provided snippet for focus visibility */
        :focus-visible {
          outline: var(--gray) 3px dotted !important;
        }
      '';

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        
        # DevTools & Debugging (Requested by user)
        "devtools.chrome.enabled" = true;
        "devtools.debugger.remote-enabled" = true;
        "devtools.debugger.prompt-connection" = false;
        "devtools.inspector.showAllAnonymousContent" = true;
        
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
