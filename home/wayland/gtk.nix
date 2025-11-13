{ pkgs, ... }:

let
  gruvboxTheme = pkgs.fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Gruvbox-GTK-Theme";
    rev = "578cd22";
    sha256 = "1fmpma44hp9a7b2nklvm900l62ni8smmjc9g4a9y1x53ys7hyyj5";
  };
in
{
  home.packages = with pkgs; [
    sassc
    gtk-engine-murrine
    gnome-themes-extra
    nerd-fonts.fira-code
  ];

  home.file.".themes/Gruvbox".source = "${gruvboxTheme}";

  xdg.configFile."gtk-3.0/settings.ini" = {
    text = ''
      [Settings]
      gtk-theme-name = Gruvbox
      gtk-icon-theme-name = Suru
      gtk-font-name = FiraCode Nerd 10
      gtk-application-prefer-dark-theme=1
    '';
    force = true;
  };

  xdg.configFile."gtk-4.0/settings.ini" = {
    text = ''
      [Settings]
      gtk-theme-name = Gruvbox
      gtk-application-prefer-dark-theme=1
    '';
    force = true;
  };
  
  home.sessionVariables = {
    GTK_THEME = "Gruvbox:dark";  # force GTK apps to use Gruvbox dark
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
}
