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
    enableMoonlightRofiEntry = ''
      mkdir -p ~/.local/share/applications ~/.config/rofi

      # Define applications as a list of name, description, and icon
      APPS=(
        "Virtual Display|Launch Virtual Display|display-icon"
        "Another App|Launch Another App|app-icon"
      )

      # Create the launch script
      cat > ~/.config/rofi/launch-moonlight.sh <<'EOF'
      #!/usr/bin/env bash
      
      # Fetch current Wayland screen resolution
      RESOLUTION=$(wlr-randr | grep '*' | awk '{print $1}')
      
      # Check if an application name is provided
      APP_NAME="${1:-Virtual Display}"
      
      # Launch Moonlight with the specified application and resolution
      moonlight stream -resolution "${RESOLUTION}" Gaming "${APP_NAME}"
      EOF

      chmod +x ~/.config/rofi/launch-moonlight.sh

      # Create desktop entries dynamically
      for APP in "${APPS[@]}"; do
        IFS='|' read -r NAME DESCRIPTION ICON <<< "$APP"
        cat > ~/.local/share/applications/moonlight-${NAME// /-}.desktop <<EOF
        [Desktop Entry]
        Name=${DESCRIPTION}
        Exec=/home/jurre/.config/rofi/launch-moonlight.sh "${NAME}"
        Icon=${ICON}
        Type=Application
        EOF
      done
    '';
  };
}