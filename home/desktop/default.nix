{ pkgs, inputs, ... }:

{
  # Theme/styling modules are provided by the public flatwork-ui flake.
  # Local modules below keep machine/session behavior.
  imports = [
    inputs.flatwork-ui.homeManagerModules.desktop

    ./sway
    ./scroll.nix
    ./niri.nix
    ./rofi-experience.nix
    ./battery-notify.nix
    ./volume-control.nix
    ./brightness-control.nix
  ];
}
