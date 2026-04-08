{ config, pkgs, ... }:

{
  networking = {
    hostName = "nixos-usb";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 445 139 3000];
    firewall.allowedUDPPorts = [ 137 138 ];
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    extraUpFlags = [
      "--accept-routes"
      "--exit-node-allow-lan-access"
    ];
  };

  # Prioritize local physical network over Tailscale for home/local subnets
  systemd.services.tailscale-priority = {
    description = "Prioritize local network routes over Tailscale";
    after = [ "network-online.target" "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "tailscale-priority" ''
        ${pkgs.iproute2}/bin/ip rule add to 192.168.0.0/16 lookup main priority 5260 suppress_prefixlength 0 2>/dev/null || true
        ${pkgs.iproute2}/bin/ip rule add to 10.0.0.0/8 lookup main priority 5261 suppress_prefixlength 0 2>/dev/null || true
        ${pkgs.iproute2}/bin/ip rule add to 172.16.0.0/12 lookup main priority 5262 suppress_prefixlength 0 2>/dev/null || true
      '';
      ExecStop = pkgs.writeShellScript "tailscale-priority-stop" ''
        ${pkgs.iproute2}/bin/ip rule del priority 5260 2>/dev/null || true
        ${pkgs.iproute2}/bin/ip rule del priority 5261 2>/dev/null || true
        ${pkgs.iproute2}/bin/ip rule del priority 5262 2>/dev/null || true
      '';
    };
  };

  programs.wireshark.enable = true;

}
