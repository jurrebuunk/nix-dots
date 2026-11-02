{ lib, ... }:

{
  # Avoid losing remote access to idle suspend while connected to AC power.
  # Battery suspend remains enabled; hibernation is not configured.
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
        sleep-inactive-ac-timeout = lib.gvariant.mkInt32 0;
        # SensorProxy currently receives only zero from this unit's 0xdc
        # light-sensor variant. Keep manual brightness until a driver fix is
        # verified; this remains an overridable GNOME default.
        ambient-enabled = false;
      };
    }
  ];
}
