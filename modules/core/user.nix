{ config, pkgs, ... }:

{
  users.users.jurre = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "audio" "wireshark"];
    initialPassword = "Welkom01";
  };

  security.sudo.extraRules = [
    {
      users = [ "jurre" ];
      commands = [
        {
          command = "${pkgs.python3Packages.impacket}/bin/smbserver.py";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.procps}/bin/pkill";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.procps}/bin/kill";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  security.sudo.enable = true;
}
