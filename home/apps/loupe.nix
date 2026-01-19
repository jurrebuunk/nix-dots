{ pkgs, ... }:

{
  home.packages = with pkgs; [
    loupe
  ];

  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":";
    };
  };

  xdg.mimeApps.defaultApplications = {
    "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
    "image/png" = [ "org.gnome.Loupe.desktop" ];
    "image/gif" = [ "org.gnome.Loupe.desktop" ];
    "image/webp" = [ "org.gnome.Loupe.desktop" ];
    "image/tiff" = [ "org.gnome.Loupe.desktop" ];
    "image/bmp" = [ "org.gnome.Loupe.desktop" ];
    "image/vnd.adobe.photoshop" = [ "org.gnome.Loupe.desktop" ];
    "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
  };
}
