{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    wget
    fastfetch
    cava
    freerdp
    dialog
    libnotify
    curl
    iproute2
    netcat
    firefox
    pavucontrol
    moonlight-qt
    kanshi
    vlc
    screen
    alacritty
    gemini-cli
    rclone
    fuse3
    vscode
    python3
    wireshark
    opencode
    chromium
    ffmpeg
    wdisplays
    feishin
    wlr-randr
    codex
    fractal
    obsidian
    comma
    evolution
    teams-for-linux
    mpv
  ];
  
  programs.fuse.userAllowOther = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  # gnome calendar services
  programs.dconf.enable = true;
  services.gnome.evolution-data-server.enable = true;

  services.dbus.implementation = "dbus";
  services.dbus.packages = [ pkgs.xfconf ];
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.gnome.glib-networking.enable = true;
  
  services.openssh.enable = false;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  environment.variables.PATH = [ "/home/jurre/.local/bin" ];
}
