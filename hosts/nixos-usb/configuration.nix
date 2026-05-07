# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:


{
  imports =
    [
      ./hw-config.nix                 # Hardware specific configurations
      
      # Core System Configuration
      ../../modules/core

      # Desktop Environment Modules
      ../../modules/desktop/greeter.nix
      ../../modules/desktop/sway.nix
      ../../modules/desktop/waylock.nix
      ../../modules/desktop/rofi.nix
      
      
      # Other Modules
      ../../modules/development
      ../../modules/proxmox
    ];

  # Bootloader
  boot.loader.timeout = 0;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # Time and Locale
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # Hardware / Drivers
  services.xserver.videoDrivers = [ "intel" ];
  hardware.enableAllFirmware = true;
  environment.systemPackages = [ pkgs.displaylink ];
  boot.extraModulePackages = [ pkgs.v4l-utils ];

  # Printing / Scanning
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    hplip
    splix
  ];
  services.avahi.enable = true; # for network discovery
  hardware.sane.enable = true; # optional (scanner support, safe to include)
  
  # Proxmox Management
  custom.proxmox = {
    enable = true;
    host = "192.168.1.13";
    user = "root@pam";
    tokenId = "root@pam!nixos-laptop";
    tokenSecret = "";
  };

  age.identityPaths = [ "/home/jurre/.ssh/id_ed25519" ];
  age.secrets.proxmox-token-secret.file = ../../secrets/proxmox-token-secret.age;

  environment.sessionVariables.PROXMOX_TOKEN_SECRET_FILE = config.age.secrets.proxmox-token-secret.path;

  # Environment Variables
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  system.stateVersion = "25.05"; 
}
