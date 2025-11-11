{ pkgs, ... }:

let
  gruvboxTheme = pkgs.fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Gruvbox-GTK-Theme";
    rev = "578cd22"; # latest commit
    sha256 = "1fmpma44hp9a7b2nklvm900l62ni8smmjc9g4a9y1x53ys7hyyj5";
  };
in
{
  home.packages = with pkgs; [
    sassc
    gtk-engine-murrine
    gnome-themes-extra
    gruvboxTheme
  ];

  # Environment variables for GTK/Qt apps and Sway
  home.sessionVariables = {
    GTK_THEME = "Gruvbox";
    QT_STYLE_OVERRIDE = "Adwaita-dark";
    XDG_CURRENT_DESKTOP = "sway";
  };

  # GTK3 settings
  xdg.configFile."gtk-3.0/settings.ini" = {
    text = ''
      [Settings]
      gtk-theme-name = Gruvbox
      gtk-icon-theme-name = Suru
      gtk-font-name = Cantarell 11
      gtk-application-prefer-dark-theme=1
    '';
    force = true;
  };

  # GTK4 settings
  xdg.configFile."gtk-4.0/settings.ini" = {
    text = ''
      [Settings]
      gtk-theme-name = Gruvbox
    '';
    force = true;
  };
}
