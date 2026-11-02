{ ... }:

{
  imports = [
    ./boot.nix
    ./kernel.nix
    ./hardware.nix
    ./locale.nix
    ./networking.nix
    ./power.nix
    ./sound.nix
    ./bluetooth.nix
    ./user.nix
    ./packages.nix
    ./services.nix
    ./environment.nix
    ./nix.nix
    ./overlays.nix
    ./dev/python.nix
  ];
}
