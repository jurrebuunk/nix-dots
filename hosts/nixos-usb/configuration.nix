# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:


{
  imports =
    [
      ./hw-config.nix                 # Hardware specific configurations
      ../../modules/ly-dm.nix         # Login 
      ../../modules/sway.nix
      ../../modules/waylock.nix
      ../../modules/development.nix
      ../../modules/niri.nix
      ../../modules/rofi.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking = {
    hostName = "nixos-usb";
    networkmanager = {
      enable = true;
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";



  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true; # Optional, for GUI management

  fonts.fonts = with pkgs; [
    nerd-fonts.caskaydia-mono
  ];

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

   
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };


  # Camera (uaccess en v4l2)
  hardware.enableAllFirmware = true;
  boot.extraModulePackages = [ pkgs.v4l-utils ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jurre = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "audio"]; # Enable ‘sudo’ for the user.
    initialPassword = "Welkom01";
  };

  security.sudo.enable = true;

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    yazi
    fastfetch
    spotify
    cava
    wezterm
    freerdp
    dialog
    libnotify
    curl
    iproute2
    netcat
    firefox
    nautilus
    pavucontrol   # geluidsinstellingen
    moonlight-qt
    kanshi
    cava
    fuzzel
  ];

  services.logind.lidSwitchDocked = "ignore";

  environment.etc."bin/wifi".text = ''
    #!/bin/bash
    wezterm start -- bash -c 'echo -ne \"\\033]0;nmtui\\007\"; nmtui' & sleep 0.2 && swaymsg '[title=\"nmtui\"] floating enable' && swaymsg '[title=\"nmtui\"] resize grow height 2'
  '';

  virtualisation.docker.enable = true;

  environment.variables.PATH = [ "/home/jurre/.local/bin" ];

  programs.thunar.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.xserver.videoDrivers = [ "intel" ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

