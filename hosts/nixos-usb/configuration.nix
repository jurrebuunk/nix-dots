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
      inputs.flatwork-ui.nixosModules.fonts

      # Desktop Environment Modules
      ../../modules/desktop/greeter.nix
      ../../modules/desktop/wayland.nix
      ../../modules/desktop/waylock.nix
      ../../modules/desktop/swayosd.nix
      ../../modules/desktop/niri-shorin-fork.nix
      
      
      # Other Modules
      ../../modules/development
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

  # Android container support.
  virtualisation.waydroid.enable = true;

  # Niri needs xdg-desktop-portal-gnome for Wayland/PipeWire screen capture.
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  # Printing / Scanning disabled to reduce idle services.
  services.printing.enable = false;
  services.avahi.enable = false;
  hardware.sane.enable = false;

  age.identityPaths = [ "/home/jurre/.ssh/id_ed25519" ];

  # Environment Variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = lib.mkForce "";
    XCURSOR_SIZE = "12";
  };
  
  system.stateVersion = "25.05"; 
}
