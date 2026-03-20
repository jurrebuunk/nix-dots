{pkgs, ...}: rec {
  programs.dconf.enable = true;

  security.polkit.enable = true;
  security.pam.services.swaylock = {};

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    grim
    mako
    slurp
    sway
    wl-clipboard
    swaybg
    dmenu
    i3status
  ];

  # Enable the gnome-keyring secrets vault.
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;
  
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
}
