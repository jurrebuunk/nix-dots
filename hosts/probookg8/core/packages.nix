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
    blueman
    moonlight-qt
    kanshi
    vlc
    screen
    alacritty
    antigravity-cli
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
    librepods
    v4l-utils
    obs-studio
  ];

  # Keep Blueman's applet and system integration with this host's package choice.
  services.blueman.enable = true;
}
