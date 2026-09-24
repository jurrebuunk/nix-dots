{ pkgs, inputs, theme, ... }:

let
  c = theme.colors;
  g = theme.geometry;

  obsidianThemeCss = ''
    .theme-dark {
      --background-primary: ${c.background};
      --background-primary-alt: ${c.background};
      --background-secondary: ${c.background};
      --background-secondary-alt: ${c.background};
      --background-modifier-border: ${c.border};
      --background-modifier-border-hover: ${c.accent};
      --background-modifier-form-field: ${c.background};
      --background-modifier-form-field-highlighted: ${c.background};
      --background-modifier-hover: ${c.border};
      --background-modifier-message: ${c.background};

      --text-normal: ${c.text};
      --text-muted: ${c.textMuted};
      --text-faint: ${c.textFaint};
      --text-accent: ${c.accent};
      --text-accent-hover: ${c.highlight};
      --text-on-accent: ${c.background};

      --interactive-normal: ${c.background};
      --interactive-hover: ${c.surfaceAlt};
      --interactive-accent: ${c.accent};
      --interactive-accent-hover: ${c.highlight};

      --link-color: ${c.accent};
      --link-color-hover: ${c.highlight};
      --link-external-color: ${c.accent};

      --titlebar-background: ${c.background};
      --titlebar-background-focused: ${c.background};
      --modal-background: ${c.background};
      --divider-color: ${c.border};
      --scrollbar-bg: ${c.background};
      --scrollbar-thumb-bg: ${c.border};
      --scrollbar-active-thumb-bg: ${c.accent};

      --tab-background-active: ${c.background};
      --tab-background-inactive: ${c.background};
      --tab-text-color-active: ${c.text};
      --tab-text-color-inactive: ${c.textMuted};
      --tab-text-color-focused: ${c.text};

      --nav-item-color: ${c.text};
      --nav-item-color-hover: ${c.text};
      --nav-item-color-active: ${c.text};
      --nav-item-color-selected: ${c.text};
      --nav-collapse-icon-color: ${c.text};
      --icon-color: ${c.text};
      --icon-color-hover: ${c.text};
      --icon-color-focused: ${c.text};
      --icon-color-active: ${c.text};
      --nav-indentation-guide-color: ${c.border};
      --divider-color: ${c.border};
      --frame-divider-color: ${c.border};
      --tab-outline-color: ${c.border};
      --background-modifier-border: ${c.border};
      --background-modifier-border-hover: ${c.border};

      --radius-s: ${g.radiusPx};
      --radius-m: ${g.radiusPx};
      --radius-l: ${g.radiusPx};
      --radius-xl: ${g.radiusPx};
      --radius-xxl: ${g.radiusPx};
      --input-radius: ${g.radiusPx};
      --button-radius: ${g.radiusPx};
      --checkbox-radius: ${g.radiusPx};
      --toggle-radius: ${g.radiusPx};
      --tab-radius: ${g.radiusPx};
      --modal-border-radius: ${g.radiusPx};
      --window-radius: ${g.radiusPx};
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
      border-radius: ${g.radiusPx} !important;
      box-shadow: ${g.boxShadow} !important;
    }

    .workspace-tab-header {
      border-top-left-radius: ${g.radiusPx} !important;
      border-top-right-radius: ${g.radiusPx} !important;
    }

    .workspace-tab-header.is-active {
      border-radius: ${g.radiusPx} !important;
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
      color: ${c.accent} !important;
    }

    .markdown-preview-view h2,
    .markdown-source-view.mod-cm6 .cm-header-2 {
      color: ${c.success} !important;
    }

    .markdown-preview-view h3,
    .markdown-source-view.mod-cm6 .cm-header-3 {
      color: ${c.warning} !important;
    }

    .markdown-preview-view h4,
    .markdown-source-view.mod-cm6 .cm-header-4 {
      color: ${c.warning} !important;
    }

    .markdown-preview-view h5,
    .markdown-source-view.mod-cm6 .cm-header-5 {
      color: ${c.secondary} !important;
    }

    .markdown-preview-view h6,
    .markdown-source-view.mod-cm6 .cm-header-6 {
      color: ${c.accentSoft} !important;
    }
  '';
in

{
  imports = [
    inputs.flatwork-ui.homeManagerModules.apps

    ./libreoffice.nix
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
