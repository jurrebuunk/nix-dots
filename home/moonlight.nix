{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    moonlight-qt
  ];

  home.file = {
    "~/.config/rofi/launch-moonlight.sh".text = ''
      #!/usr/bin/env bash
      moonlight stream -app "Virtual Display" Gaming
    '';
  };

  home.activation = {
    enableMoonlightRofiEntry = {
      text = ''
        mkdir -p ~/.local/share/applications
        cat > ~/.local/share/applications/moonlight-virtual-display.desktop <<EOF
        [Desktop Entry]
        Name=Launch Virtual Display
        Exec=~/.config/rofi/launch-moonlight.sh
        Type=Application
        EOF

        chmod +x ~/.config/rofi/launch-moonlight.sh
      '';
    };
  };
}