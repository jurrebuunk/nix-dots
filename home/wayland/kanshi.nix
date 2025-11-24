{ config, pkgs, ... }:

{
  services.kanshi = {
    enable = true;

    profiles = {
      ultrawide_only = {
        outputs = [
          { criteria = "LG Electronics LG ULTRAWIDE 0x000591DF"; mode = "2560x1080@60Hz"; position = "0,0"; status = "enable"; }
          { criteria = "eDP-1"; status = "disable"; }
        ];
      };

      laptop_only = {
        outputs = [
          { criteria = "eDP-1"; status = "enable"; }
        ];
      };
    };
  };
}

