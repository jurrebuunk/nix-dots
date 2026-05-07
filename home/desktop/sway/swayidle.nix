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
      default = 30000;
      description = "Time in seconds before locking the screen";
    };
    
    screenOffTimeout = lib.mkOption {
      type = lib.types.int;
      default = 60000;
      description = "Time in seconds before turning off the screen";
    };
  };

  config = lib.mkIf cfg.enable {
    services.swayidle = {
      enable = true;
      events = {
        before-sleep = "${pkgs.systemd}/bin/loginctl lock-session && ${pkgs.gtklock}/bin/gtklock -d && ${pkgs.coreutils}/bin/sleep 2";
        after-resume = "${pkgs.gtklock}/bin/gtklock -d";
        lock = "${pkgs.gtklock}/bin/gtklock -d";
      };
      timeouts = [
        {
          timeout = cfg.lockTimeout;
          command = "${pkgs.gtklock}/bin/gtklock -d";
        }
        {
          timeout = cfg.screenOffTimeout;
          command = "/run/current-system/sw/bin/scrollmsg \"output * power off\" || ${pkgs.sway}/bin/swaymsg \"output * power off\"";
          resumeCommand = "/run/current-system/sw/bin/scrollmsg \"output * power on\" || ${pkgs.sway}/bin/swaymsg \"output * power on\"";
        }
      ];
    };

    # Ensure lock tool is installed
    home.packages = [ pkgs.gtklock ];
  };
}
