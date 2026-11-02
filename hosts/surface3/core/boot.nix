{ ... }:

{
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;
  swapDevices = [ { device = "/swapfile"; size = 8192; } ];
}
