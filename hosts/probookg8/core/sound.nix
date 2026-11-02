{ config, pkgs, ... }:

{
  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    wireplumber.extraConfig."10-bluez-airpods-volume" = {
      "monitor.bluez.properties" = {
        # Helps some Bluetooth earbuds/headphones with broken AVRCP volume handling.
        "bluez5.dummy-avrcp-player" = true;
      };

      "monitor.bluez.rules" = [
        {
          matches = [
            {
              # Match all Bluetooth audio cards, including AirPods.
              "device.name" = "~bluez_card.*";
            }
          ];
          actions = {
            update-props = {
              # Keep volume in PipeWire/software instead of syncing hardware/absolute
              # volume to the AirPods. This avoids AirPods getting stuck painfully loud
              # while LibrePods is running.
              "bluez5.hw-volume" = [];
            };
          };
        }
      ];
    };
  };
  
  # Enable sound.
  # services.pulseaudio.enable = true;
}
