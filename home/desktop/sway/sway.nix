{ config, pkgs, lib, theme, ... }:

let
  mod = "Mod4";

  #bash script to let dbus know about important env variables and to propagate them to restarted services
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
in {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = mod;
      focus.followMouse = false;
      workspaceAutoBackAndForth = true;
      bars = [ ]; # Managed in theme.nix via extraConfig
    };

    systemd.enable = true;
    wrapperFeatures = { gtk = true; };
  };

  home.file.".hm-graphical-session".text = pkgs.lib.concatStringsSep "\n" [
    "export MOZ_ENABLE_WAYLAND=1"
    # "export NIXOS_OZONE_WL=1"
  ];

  services.cliphist.enable = true;
  
  fonts.fontconfig.enable = true;
}
