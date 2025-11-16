{ config, pkgs, ... }:

let
  theme = import ../../themes/theme.nix;

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

    * {
      background-color: @bg;
      color: @fg;
      border-width: 0;
      border-radius: 0;
      box-shadow: none;
    }

    button, button:focus, button:active, button:hover {
      background: @bg;
      border: none;
      box-shadow: none;
    }

    entry, spinbutton, combobox, menuitem {
      background-color: @bg;
      color: @fg;
      border-width: 0;
      border-radius: 0;
    }

    scrollbar, scrollbar slider {
      background-color: @bg;
      border-width: 0;
      border-radius: 0;
    }

    tooltip {
      background-color: @gray;
      color: @bg;
      border-width: 0;
    }

    menu, menuitem {
      background-color: @bg;
      color: @fg;
      border-width: 0;
      border-radius: 0;
    }

    headerbar {
      background-color: @bg;
      color: @fg;
      border-width: 0;
    }

    headerbar entry, headerbar button {
      border-width: 0;
      box-shadow: none;
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
    #papirus-icon-theme       # clean & modern
    #flat-remix-icon-theme    # flat / Material Design stijl
    moka-icon-theme          # minimalistische look
    #numix-icon-theme         # strak en modern
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

  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-icon-theme-name = Moka
    gtk-font-name = ${theme.fonts.main} ${theme.fonts.size}
    gtk-application-prefer-dark-theme = 1
  '';

  xdg.configFile."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-icon-theme-name = Moka
    gtk-font-name = ${theme.fonts.main} ${theme.fonts.size}
    gtk-application-prefer-dark-theme = 1
  '';
}
