{ config, pkgs, ... }:

{
  networking = {
    hostName = "nixos-usb";
    networkmanager.enable = true;
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # firewall.enable = false;
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
  environment.etc."bin/wifi".text = ''
    #!/bin/bash
    wezterm start -- bash -c 'echo -ne \"\\033]0;nmtui\\007\"; nmtui' & sleep 0.2 && swaymsg '[title=\"nmtui\"] floating enable' && swaymsg '[title=\"nmtui\"] resize grow height 2'
  '';

}
