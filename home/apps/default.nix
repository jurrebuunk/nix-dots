{ pkgs, theme, ... }:

let
  c = theme.colors;

  obsidianThemeCss = ''
    .theme-dark {
      --background-primary: ${c.bg};
      --background-primary-alt: ${c.bg};
      --background-secondary: ${c.bg};
      --background-secondary-alt: ${c.bg};
      --background-modifier-border: ${c.gray};
      --background-modifier-border-hover: ${c.blue};
      --background-modifier-form-field: ${c.bg};
      --background-modifier-form-field-highlighted: ${c.bg};
      --background-modifier-hover: ${c.gray};
      --background-modifier-message: ${c.bg};

      --text-normal: ${c.fg};
      --text-muted: ${c.gray};
      --text-faint: ${c.gray};
      --text-accent: ${c.blue};
      --text-accent-hover: ${c.yellow};
      --text-on-accent: ${c.bg};

      --interactive-normal: ${c.bg};
      --interactive-hover: ${c.gray};
      --interactive-accent: ${c.blue};
      --interactive-accent-hover: ${c.yellow};

      --link-color: ${c.blue};
      --link-color-hover: ${c.yellow};
      --link-external-color: ${c.blue};

      --titlebar-background: ${c.bg};
      --titlebar-background-focused: ${c.bg};
      --modal-background: ${c.bg};
      --divider-color: ${c.gray};
      --scrollbar-bg: ${c.bg};
      --scrollbar-thumb-bg: ${c.gray};
      --scrollbar-active-thumb-bg: ${c.blue};

      --tab-background-active: ${c.bg};
      --tab-background-inactive: ${c.bg};
      --tab-text-color-active: ${c.fg};
      --tab-text-color-inactive: ${c.gray};
      --tab-text-color-focused: ${c.fg};

      --nav-item-color: ${c.fg};
      --nav-item-color-hover: ${c.fg};
      --nav-item-color-active: ${c.fg};
      --nav-item-color-selected: ${c.fg};
      --nav-collapse-icon-color: ${c.fg};
      --icon-color: ${c.fg};
      --icon-color-hover: ${c.fg};
      --icon-color-focused: ${c.fg};
      --icon-color-active: ${c.fg};
      --nav-indentation-guide-color: ${c.gray};
      --divider-color: ${c.gray};
      --frame-divider-color: ${c.gray};
      --tab-outline-color: ${c.gray};
      --background-modifier-border: ${c.gray};
      --background-modifier-border-hover: ${c.gray};

      --radius-s: 0px;
      --radius-m: 0px;
      --radius-l: 0px;
      --radius-xl: 0px;
      --radius-xxl: 0px;
      --input-radius: 0px;
      --button-radius: 0px;
      --checkbox-radius: 0px;
      --toggle-radius: 0px;
      --tab-radius: 0px;
      --modal-border-radius: 0px;
      --window-radius: 0px;
    }

    .theme-dark,
    .theme-dark *,
    .workspace,
    .workspace-split,
    .workspace-leaf,
    .workspace-leaf-content,
    .workspace-tab-container,
    .workspace-tabs,
    .workspace-ribbon,
    .mod-root,
    .modal,
    .modal *,
    .popover,
    .menu,
    .tooltip,
    .suggestion-container,
    .prompt,
    .setting-item,
    .search-result-container,
    .nav-files-container,
    .nav-folder-title,
    .nav-file-title,
    .view-content,
    .markdown-preview-view,
    .markdown-source-view,
    .cm-editor,
    .cm-scroller,
    .frontmatter-container,
    .metadata-container,
    .workspace-tab-header,
    .workspace-tab-header-inner,
    button,
    .clickable-icon,
    input,
    textarea {
      border-radius: 0 !important;
      box-shadow: none !important;
    }

    .workspace-tab-header {
      border-top-left-radius: 0 !important;
      border-top-right-radius: 0 !important;
    }

    .workspace-tab-header.is-active {
      border-radius: 0 !important;
    }

    .nav-file-title,
    .nav-folder-title,
    .tree-item-self,
    .workspace-ribbon .clickable-icon,
    .workspace-ribbon .sidebar-toggle-button,
    .workspace-split .clickable-icon,
    .workspace-split .sidebar-toggle-button {
      color: var(--text-normal) !important;
    }

    .nav-file-title .tree-item-icon,
    .nav-folder-title .tree-item-icon,
    .nav-file-title .tree-item-children,
    .nav-folder-title .tree-item-children,
    .workspace-ribbon .clickable-icon svg,
    .workspace-split .clickable-icon svg,
    .workspace-ribbon .sidebar-toggle-button svg,
    .workspace-split .sidebar-toggle-button svg {
      color: var(--text-normal) !important;
    }

    .markdown-preview-view h1,
    .markdown-source-view.mod-cm6 .cm-header-1 {
      color: ${c.blue} !important;
    }

    .markdown-preview-view h2,
    .markdown-source-view.mod-cm6 .cm-header-2 {
      color: ${c.green} !important;
    }

    .markdown-preview-view h3,
    .markdown-source-view.mod-cm6 .cm-header-3 {
      color: ${c.yellow} !important;
    }

    .markdown-preview-view h4,
    .markdown-source-view.mod-cm6 .cm-header-4 {
      color: ${c.orange} !important;
    }

    .markdown-preview-view h5,
    .markdown-source-view.mod-cm6 .cm-header-5 {
      color: ${c.magenta} !important;
    }

    .markdown-preview-view h6,
    .markdown-source-view.mod-cm6 .cm-header-6 {
      color: ${c.cyan} !important;
    }
  '';
in

{
  imports = [
    ./firefox.nix
    ./libreoffice.nix
    ./alacritty.nix
    ./supersonic.nix
    ./agents
    ./thunar.nix
    ./loupe.nix
  ];

  home.file."Documents/vault/.obsidian/themes/System Flat/theme.css" = {
    text = obsidianThemeCss;
    force = true;
  };

  home.file."Documents/vault/.obsidian/themes/System Flat/manifest.json" = {
    text = builtins.toJSON {
      name = "System Flat";
      version = "1.0.0";
      minAppVersion = "1.0.0";
      author = "nix-dots";
      description = "Obsidian theme that follows the system palette and uses square corners.";
      isDesktopOnly = true;
    };
    force = true;
  };
}
