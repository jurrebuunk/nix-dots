{ inputs, ... }:

{
  imports = [
    ./hw-config.nix
    ./core
    inputs.flatwork-ui.nixosModules.fonts
    ../../modules/desktop/niri
    ../../modules/development
  ];

  # Keep this at the initial installation release, even after upgrades.
  system.stateVersion = "25.05";
}
