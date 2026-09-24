{ pkgs, lib, config, ... }:

let
  autoLockCfg = config.custom.desktop.autoLock;
in
{
  options.custom.desktop.autoLock = {
    enable = lib.mkEnableOption "auto lock screen" // {
      default = true;
    };

    timeout = lib.mkOption {
      type = lib.types.int;
      default = 300;
      description = "Time in seconds before locking the session";
    };
  };

  config = lib.mkIf autoLockCfg.enable {
    services.swayidle = {
      enable = true;
      events = {
        before-sleep = "${pkgs.systemd}/bin/loginctl lock-session && ${pkgs.gtklock}/bin/gtklock -d && ${pkgs.coreutils}/bin/sleep 2";
        after-resume = "${pkgs.gtklock}/bin/gtklock -d";
        lock = "${pkgs.gtklock}/bin/gtklock -d";
      };
      timeouts = [
        {
          timeout = autoLockCfg.timeout;
          command = "${pkgs.gtklock}/bin/gtklock -d";
        }
      ];
    };

    home.packages = [ pkgs.gtklock ];
  };
}
