{ config, pkgs, ... }:

{
  users.users.jurre = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "audio"];
    initialPassword = "Welkom01";
  };

  security.sudo.enable = true;
}
