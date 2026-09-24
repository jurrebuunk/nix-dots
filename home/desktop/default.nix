{ pkgs, inputs, ... }:

{
  # Theme/styling modules are provided by the public jurre-theme flake.
  # Local modules below keep machine/session behavior.
  imports = [
    inputs.jurre-theme.homeManagerModules.desktop

    ./sway
    ./scroll.nix
    ./niri.nix
    ./rofi-experience.nix
    ./battery-notify.nix
    ./volume-control.nix
    ./brightness-control.nix
  ];
}
