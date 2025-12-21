{ ... }:

{
  imports = [
    ./networking.nix
    ./sound.nix
    ./bluetooth.nix
    ./user.nix
    ./fonts.nix
    ./packages.nix
    ./overlays.nix
  ];
}
