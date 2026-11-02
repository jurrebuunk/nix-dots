{ ... }:

{
  networking.hostName = "surface3";
  networking.useDHCP = false;
  networking.networkmanager = {
    enable = true;
    # Keep the installer's Ethernet DHCP identity and reconnect automatically.
    ensureProfiles.profiles.wired = {
      connection = {
        id = "Wired connection";
        type = "ethernet";
        autoconnect = true;
        autoconnect-priority = 100;
      };
      ethernet.mac-address = "00:E0:4C:36:59:C3";
      ipv4 = {
        method = "auto";
        dhcp-client-id = "mac";
        dhcp-hostname = "surface3";
      };
      ipv6.method = "auto";
    };
  };
  networking.firewall.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };
}
