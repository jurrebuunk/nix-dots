{ pkgs, ... }: {
  imports = [
    ./sway.nix
    ./wofi.nix
    ./i3status.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
    mako
    dmenu
    i3status
    swaybg
  ];
}
