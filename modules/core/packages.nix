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
    nautilus
    pavucontrol
    moonlight-qt
    kanshi
    fuzzel
    pkgs.antigravity
    rofi-bluetooth
    rofi-network-manager
    vlc
    screen
    alacritty
    gemini-cli
    rclone
    fuse3
    vscode
  ];
  
  programs.fuse.userAllowOther = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.gnome.glib-networking.enable = true;
  
  services.openssh.enable = true;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  
  environment.variables.PATH = [ "/home/jurre/.local/bin" ];
}
