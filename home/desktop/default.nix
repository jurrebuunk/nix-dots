{ pkgs, inputs, ... }:

{
  # Theme/styling modules are provided by the public flatwork-ui flake.
  # Local modules below keep machine/session behavior.
  imports = [
    inputs.flatwork-ui.homeManagerModules.desktop

    ./niri.nix
    ./kanshi.nix
    ./swayidle.nix
    ./rofi-experience.nix
    ./battery-notify.nix
  ];
}
