{ pkgs, ... }:

let
  gruvboxTheme = pkgs.fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Gruvbox-GTK-Theme";
    rev = "578cd22"; # latest commit
    sha256 = "0v6ncj5lffn8cld5c6qvmc9p5c5pz3kjyqv9xxpcc5l57b3j9d7f"; # prefetch required
  };
in
{
  home.packages = with pkgs; [
    sassc
    gtk-engine-murrine
    gnome-themes-extra
    gruvboxTheme
  ];

  # GTK3
  home.file.".config/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name = Gruvbox
    gtk-icon-theme-name = Suru
    gtk-font-name = Cantarell 11
  '';

  # GTK4
  home.file.".config/gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name = Gruvbox
  '';

  # Optional: Flatpak override for GTK apps
  home.sessionVariables.FLATPAK_OVERRIDE_THEMES = "--user --filesystem=$HOME/.themes";
}
