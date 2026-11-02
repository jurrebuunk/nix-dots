{ pkgs, ... }:

{
  virtualisation.waydroid.enable = true;

  # Printing / scanning disabled to reduce idle services.
  services.printing.enable = false;
  services.avahi.enable = false;
  hardware.sane.enable = false;
  services.openssh.enable = false;

  programs.fuse.userAllowOther = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  programs.dconf.enable = true;
  services.gnome.evolution-data-server.enable = true;
  services.dbus.implementation = "dbus";
  services.dbus.packages = [ pkgs.xfconf ];
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.gnome.glib-networking.enable = true;

  age.identityPaths = [ "/home/jurre/.ssh/id_ed25519" ];
}
