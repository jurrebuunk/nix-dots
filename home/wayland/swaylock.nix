{ config, pkgs, ... }:

let
  lockScript = ''
    #!/bin/sh
    swaylock \
      --color 000000ff \   # black background
      --indicator-radius 0 \
      --indicator-thickness 0 \
      --text "LOCKED" \
      --text-color ffffffff \
      --ignore-empty-password \
      --show-failed-attempts
  '';
in
{
  home.packages = with pkgs; [
    swaylock
  ];

  # Create a small script to run swaylock with our style
  home.file.".local/bin/swaylock-tty" = {
    source = null;
    text = lockScript;
    executable = true;
  };

  # Sway keybinding
  programs.sway.extraConfig = ''
    bindsym $mod+Shift+l exec ${config.home.homeDirectory}/.local/bin/swaylock-tty
  '';
}
