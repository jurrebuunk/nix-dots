# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  managementKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICrhRtkvmEA9FlnHmWYzsDIOg0nA+zIL4iuLPtGJiIoC jurre@nixos-desktop-management"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDfML1tz4bMJ7uAoIS5Hhd3cTE95X5QdaEJ8hR/1gWnE jurre@b302.nl"
  ];
in
{
  imports = [
    ./hw-config.nix
    ./surface-kernel.nix
  ];

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;
  swapDevices = [ { device = "/swapfile"; size = 8192; } ];

  networking.hostName = "nixos-desktop";
  networking.useDHCP = false;
  networking.networkmanager = {
    enable = true;
    # Keep the installer's Ethernet DHCP identity and reconnect automatically.
    ensureProfiles.profiles.wired = {
      connection = {
        id = "Wired connection";
        type = "ethernet";
        autoconnect = true;
        autoconnect-priority = 100;
      };
      ethernet.mac-address = "00:E0:4C:36:59:C3";
      ipv4 = {
        method = "auto";
        dhcp-client-id = "mac";
        dhcp-hostname = "nixos-desktop";
      };
      ipv6.method = "auto";
    };
  };
  networking.firewall.enable = true;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb.layout = "us";
  console.keyMap = "us";

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.enable = true;
  hardware.graphics.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Avoid the X11-bell I/O teardown path that crashed the GDM greeter's
    # PipeWire process. Normal desktop and application audio remain enabled.
    extraConfig.pipewire."10-disable-x11-bell" = {
      "context.properties"."module.x11.bell" = false;
    };
  };
  security.rtkit.enable = true;
  services.printing.enable = true;
  services.fwupd.enable = true;
  services.fstrim.enable = true;

  # Avoid losing remote access to idle suspend while connected to AC power.
  # Battery suspend remains enabled; hibernation is not configured.
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
        sleep-inactive-ac-timeout = lib.gvariant.mkInt32 0;
        # SensorProxy currently receives only zero from this unit's 0xdc
        # light-sensor variant. Keep manual brightness until a driver fix is
        # verified; this remains an overridable GNOME default.
        ambient-enabled = false;
      };
    }
  ];

  users.users.jurre = {
    isNormalUser = true;
    description = "Jurre";
    extraGroups = [ "wheel" "networkmanager" "lp" "scanner" ];
    # Bootstrap password only: change using `passwd` after first login.
    initialHashedPassword = "$y$j9T$y7vfsYNRkJlDZvaJSCDNl1$o4FA44c3IJsrkLPwyQMmlLEKkmyZ9e6YGYPWDDWhLbA";
    openssh.authorizedKeys.keys = managementKeys;
  };
  users.users.root = {
    hashedPassword = "!";
    openssh.authorizedKeys.keys = managementKeys;
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
    };
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  programs.firefox.enable = true;
  programs.git.enable = true;
  programs.nano.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    curl
    wget
    htop
    unzip
    zip
    file
    pciutils
    usbutils
    gnome-tweaks
  ];
  environment.variables.EDITOR = "nano";
  fonts.packages = with pkgs; [
    dejavu_fonts
    liberation_ttf
    noto-fonts-color-emoji
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    max-jobs = 2;
    cores = 4;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nixpkgs.config.allowUnfree = true;

  # Keep this at the initial installation release, even after upgrades.
  system.stateVersion = "26.05";
}
