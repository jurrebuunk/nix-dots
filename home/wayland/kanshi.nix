{ config, pkgs, ... }:

{
  services.kanshi = {
    enable = true;

    profiles = {
      ultrawide_only = {
        outputs = [
          {
            criteria = "DP-4";
            mode = "2560x1080@60Hz";
            position = "0,0";
            status = "enable";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      };
    };
  };
}

