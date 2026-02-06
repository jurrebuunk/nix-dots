{ ... }:

{
  imports = [
    ./networking.nix
    ./power.nix
    ./sound.nix
    ./bluetooth.nix
    ./user.nix
    ./fonts.nix
    ./packages.nix
    ./overlays.nix
    ./dev/python.nix
  ];
}
