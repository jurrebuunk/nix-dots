{ pkgs, lib, ... }:

{
  services.swayidle = {
    enable = true;
    events = {
      before-sleep = "${pkgs.gtklock}/bin/gtklock -d";
      lock = "${pkgs.gtklock}/bin/gtklock -d";
    };
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
