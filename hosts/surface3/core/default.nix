{ ... }:

{
  imports = [
    ./boot.nix
    ./surface-kernel.nix
    ./hardware.nix
    ./locale.nix
    ./networking.nix
    ./power.nix
    ./sound.nix
    ./bluetooth.nix
    ./user.nix
    ./ssh.nix
    ./packages.nix
    ./services.nix
    ./nix.nix
  ];
}
