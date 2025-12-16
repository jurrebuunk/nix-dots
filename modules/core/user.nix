{ config, pkgs, secrets, ... }:

{
  users.users.jurre = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "audio"];
    initialPassword = secrets.user.initialPassword;
  };

  security.sudo.enable = true;
}
