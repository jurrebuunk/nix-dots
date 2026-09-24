{ ... }:

{
  imports = [
    ./kernel.nix
    ./networking.nix
    ./power.nix
    ./sound.nix
    ./bluetooth.nix
    ./user.nix
    ./packages.nix
    ./overlays.nix
    ./dev/python.nix
  ];
}
