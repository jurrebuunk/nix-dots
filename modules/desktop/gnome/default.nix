{ pkgs, ... }:

{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.enable = true;
  hardware.graphics.enable = true;

  environment.systemPackages = [ pkgs.gnome-tweaks ];
}
