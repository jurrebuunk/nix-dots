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
  
  # Proxmox Management
  custom.proxmox = {
    enable = true;
    host = "192.168.1.13";
    user = "root@pam";
    tokenId = "root@pam!nixos-laptop";
    tokenSecret = "29cbc214-8dd7-417e-99d8-24a012e9e563";
  };

  # Environment Variables
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  system.stateVersion = "25.05"; 
}
