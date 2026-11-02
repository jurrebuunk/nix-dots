{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (_final: prev: {
      swayosd = prev.swayosd.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          substituteInPlace src/server/osd_window.rs \
            --replace-fail 'const ICON_SIZE: i32 = 32;' 'const ICON_SIZE: i32 = 14;'
        '';
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    swayosd
    playerctl
  ];

  # Install swayosd's system integration bits for brightness/input handling
  # and enable the libinput backend for lock-key indicators like CapsLock.
  services.udev.packages = [ pkgs.swayosd ];
  services.dbus.packages = [ pkgs.swayosd ];
  systemd.packages = [ pkgs.swayosd ];
  systemd.services.swayosd-libinput-backend.wantedBy = [ "graphical.target" ];
}
