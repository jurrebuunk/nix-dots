{ config, pkgs, theme, ... }:

let
  gtkCss = ''
    @define-color bg        ${theme.colors.bg};
    @define-color fg        ${theme.colors.fg};
    @define-color red       ${theme.colors.red};
    @define-color green     ${theme.colors.green};
    @define-color yellow    ${theme.colors.yellow};
    @define-color blue      ${theme.colors.blue};
    @define-color purple    ${theme.colors.magenta};
    @define-color cyan      ${theme.colors.cyan};
    @define-color orange    ${theme.colors.orange};
    @define-color gray      ${theme.colors.gray};

    /* 
     * OVERRIDE STANDARD GTK/LIBADWAITA VARIABLES
     * This changes the "standard dark mode color" system-wide by redefining the variables
     * that apps use, rather than forcing a background on all elements.
     */

    /* GTK3/4 Base Colors */
    @define-color theme_bg_color @bg;
    @define-color theme_fg_color @fg;
    @define-color theme_base_color @bg;
    @define-color theme_text_color @fg;
    @define-color theme_selected_bg_color @blue;
    @define-color theme_selected_fg_color @bg;
    @define-color theme_view_bg_color @bg;
    @define-color theme_view_fg_color @fg;

    /* Libadwaita / GTK4 Modern Variables */
    @define-color window_bg_color @bg;
    @define-color window_fg_color @fg;
    @define-color view_bg_color @bg;
    @define-color view_fg_color @fg;
    @define-color headerbar_bg_color @bg;
    @define-color headerbar_fg_color @fg;
    @define-color card_bg_color @bg;
    @define-color popover_bg_color @bg;
    @define-color dialog_bg_color @bg;

    /* Internal Palette Overrides */
    @define-color dark_1 @bg;
    @define-color dark_2 @bg;
    @define-color dark_3 @bg;
    @define-color dark_4 @bg;
    @define-color dark_5 @bg;

    /* Accents */
    @define-color accent_color @blue;
    @define-color accent_bg_color @blue;
    @define-color accent_fg_color @bg;

    /* 
     * EXPLICIT STYLING
     * Ensures all containers use the theme background and all elements have 2px borders.
     */

    window, 
    .background, 
    .view, 
    viewport, 
    iconview, 
    treeview, 
    list, 
    tray, 
    .main-window,
    toolbar,
    .toolbar,
    headerbar,
    .titlebar,
    menubar,
    .menubar,
    .dialog,
    .popover,
    .menu,
    .context-menu,
    messagedialog,
    popover,
    decoration {
      background-color: @bg;
      background-image: none;
      color: @fg;
      border-radius: 0;
      box-shadow: none;
    }

    /* Additional override for decoration nodes (shadows/rounding) */
    decoration, decoration:backdrop {
      border-radius: 0;
      box-shadow: none;
      margin: 0;
    }

    /* Hide window buttons (close, min, max) */
    headerbar windowcontrols,
    .titlebar windowcontrols {
      display: none;
    }

    /* 2px borders for specific interactive elements and dialogs */
    button,
    entry,
    spinbutton,
    combobox,
    textview,
    textview text,
    searchbar,
    .linked > entry,
    .linked > button,
    .dialog,
    messagedialog,
    popover > contents {
      border: 2px solid @gray;
      border-radius: 0;
    }

    /* Remove borders from views and containers that shouldn't have them */
    window, 
    .background, 
    .view, 
    viewport, 
    iconview, 
    treeview, 
    list, 
    tray, 
    headerbar,
    .titlebar,
    .card,
    scrollbar,
    scrollbar slider,
    progressbar,
    levelbar {
      border: none;
      border-radius: 0;
    }

    button {
      background-image: none;
      box-shadow: none;
      border-radius: 0;
    }

    button:hover {
      background-color: mix(@bg, @fg, 0.05);
    }

    entry, spinbutton, combobox {
      border-radius: 0;
      box-shadow: none;
    }

    /* Selection fixes */
    .view:selected, .view:selected:focus, treeview.view:selected, treeview.view:selected:focus {
      background-color: @theme_selected_bg_color;
      color: @theme_selected_fg_color;
      border: none; /* Ensure no border on selection */
    }

    /* Scrollbars */
    scrollbar slider {
      background-color: @gray;
      border-radius: 0;
    }

    tooltip {
      background-color: @bg;
      color: @fg;
      border: 2px solid @gray;
      border-radius: 0;
    }
  '';

in {
  xdg.configFile."gtk-3.0/gtk.css" = {
    text = gtkCss;
    force = true;
  };

  xdg.configFile."gtk-4.0/gtk.css" = {
    text = gtkCss;
    force = true;
  };

  home.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    GDK_BACKEND = "wayland";
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Vimix-dark";
      package = pkgs.vimix-icon-theme;
    };
    font = {
      name = theme.fonts.main;
      package = pkgs.nerd-fonts.caskaydia-cove;
      size = 10;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
