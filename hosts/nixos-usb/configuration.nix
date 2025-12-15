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
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Time and Locale
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # Hardware / Drivers
  services.xserver.videoDrivers = [ "intel" ];
  hardware.enableAllFirmware = true;
  boot.extraModulePackages = [ pkgs.v4l-utils ];

  # Environment Variables
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  # Power Management
  services.logind.lidSwitchDocked = "ignore";

  system.stateVersion = "25.05"; 
}
