{ pkgs, lib, config, ... }:

let
  cfg = config.custom.desktop.autoLock;
in
{
  options.custom.desktop.autoLock = {
    enable = lib.mkEnableOption "auto lock screen" // {
      default = true;
    };
    
    lockTimeout = lib.mkOption {
      type = lib.types.int;
      default = 300;
      description = "Time in seconds before locking the screen";
    };
    
    screenOffTimeout = lib.mkOption {
      type = lib.types.int;
      default = 600;
      description = "Time in seconds before turning off the screen";
    };
  };

  config = lib.mkIf cfg.enable {
    services.swayidle = {
      enable = true;
      events = {
        before-sleep = "${pkgs.gtklock}/bin/gtklock -d";
        lock = "${pkgs.gtklock}/bin/gtklock -d";
      };
      timeouts = [
        {
          timeout = cfg.lockTimeout;
          command = "${pkgs.gtklock}/bin/gtklock -d";
        }
        {
          timeout = cfg.screenOffTimeout;
          command = "${pkgs.sway}/bin/swaymsg \"output * power off\"";
          resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * power on\"";
        }
      ];
    };

    # Ensure gtklock is installed
    home.packages = [ pkgs.gtklock ];
  };
}
