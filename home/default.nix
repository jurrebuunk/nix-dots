{ config, pkgs, ... }:

{
  imports =
    [
      ./vscodium.nix
      ./wezterm.nix
      ./wayland
      ./element-desktop.nix
      ./winapps.nix
      ./firefox.nix
    ];
  home = {
    username = "jurre";
    homeDirectory = "/home/jurre";
    stateVersion = "24.05";

    # Session variables (for GTK, Qt, Wayland)
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";

      # Qt / Electron / SDL apps
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";

      # Icon and GTK themes
      XDG_ICON_THEME = "Adwaita";
      GTK_THEME = "Adwaita:dark";
      GTK_FONT_NAME = "FiraCode Nerd 10";
      GDK_BACKEND = "wayland";
      GTK_APPLICATION_PREFER_DARK_THEME = "1"; # ensures GTK4 apps pick dark theme
    };

    # Packages to install
    packages = with pkgs; [
      nerd-fonts.fira-code
      adwaita-icon-theme
    ];

    # GTK 3 settings
    file.".config/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name = Adwaita-dark
      gtk-font-name = FiraCode Nerd 10
      gtk-icon-theme-name = Adwaita
    '';

    # GTK 4 settings
    file.".config/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name = Adwaita-dark
      gtk-font-name = FiraCode Nerd 10
      gtk-icon-theme-name = Adwaita
      gtk-application-prefer-dark-theme = true
    '';
  };
}
