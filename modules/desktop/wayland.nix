{ pkgs, ... }:

{
  programs.dconf.enable = true;
  security.polkit.enable = true;

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    grim
    slurp
    wl-clipboard
    swaybg
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
}
