{ ... }:

{
  imports = [
    ./greeter.nix
    ./wayland.nix
    ./waylock.nix
    ./swayosd.nix
    ./shake-magnifier.nix
  ];

  # Niri needs xdg-desktop-portal-gnome for Wayland/PipeWire screen capture.
  programs.niri = {
    enable = true;
    useNautilus = false;
  };
}
