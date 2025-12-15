{ config, pkgs, ... }:

{
  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  
  # Enable sound.
  # services.pulseaudio.enable = true;
}
