{ ... }:

{
  networking = {
    hostName = "probookg8";
    networkmanager.enable = true;
    nftables.enable = true;
    firewall = {
      allowedTCPPorts = [ 445 139 3000 ];
      allowedUDPPorts = [ 137 138 ];
    };
  };

  programs.wireshark.enable = true;
}
