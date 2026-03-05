{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    wget
    yazi
    fastfetch
    spotify
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
    fuzzel
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
    sshfs
    antigravity
    chromium
    yt-dlp
    ffmpeg
    wdisplays
    feishin
    wlr-randr
  ];
  
  programs.fuse.userAllowOther = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services.dbus.packages = [ pkgs.xfconf ];
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.gnome.glib-networking.enable = true;
  
  services.openssh.enable = true;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "cisco-packet-tracer-8.2.2"
  ];

  environment.variables.PATH = [ "/home/jurre/.local/bin" ];
}
