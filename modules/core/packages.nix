{ config, pkgs, ... }:

{
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
    pavucontrol
    moonlight-qt
    kanshi
    fuzzel
    (pkgs.antigravity.override {
      commandLineArgs = "--enable-features=WaylandWindowDecorations --ozone-platform=wayland";
    })
    rofi-bluetooth
    rofi-network-manager
    vlc
  ];
  
  programs.thunar.enable = true;
  services.openssh.enable = true;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  
  environment.variables.PATH = [ "/home/jurre/.local/bin" ];
}
