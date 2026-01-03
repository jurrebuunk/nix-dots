{ pkgs, lib, ... }:

{
  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${pkgs.gtklock}/bin/gtklock -d"; }
      { event = "lock"; command = "${pkgs.gtklock}/bin/gtklock -d"; }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.gtklock}/bin/gtklock -d";
      }
      {
        timeout = 600;
        command = "${pkgs.sway}/bin/swaymsg \"output * power off\"";
        resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * power on\"";
      }
    ];
  };

  # Ensure gtklock is installed
  home.packages = [ pkgs.gtklock ];
}
