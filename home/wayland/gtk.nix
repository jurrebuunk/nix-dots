{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gruvbox-gtk-theme
    papirus-icon-theme
    nerd-fonts.fira-code
  ];

  home.sessionVariables = {
    GTK_THEME = "Gruvbox:dark";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "Gruvbox:dark";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    GTK_FONT_NAME = "FiraCode Nerd 10";
    GDK_BACKEND = "wayland";
    GTK_APPLICATION_PREFER_DARK_THEME = "1";
  };

  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name = Gruvbox
    gtk-icon-theme-name = Papirus
    gtk-font-name = FiraCode Nerd 10
    gtk-application-prefer-dark-theme = 1
  '';

  xdg.configFile."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name = Gruvbox
    gtk-icon-theme-name = Papirus
    gtk-application-prefer-dark-theme = 1
  '';
}
