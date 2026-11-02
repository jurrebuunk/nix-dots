{ ... }:

{
  imports = [
    ./hw-config.nix
    ./core
    ../../modules/desktop/gnome
  ];

  # Keep this at the initial installation release, even after upgrades.
  system.stateVersion = "26.05";
}
