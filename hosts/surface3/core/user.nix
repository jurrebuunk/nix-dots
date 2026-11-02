{ ... }:

let
  managementKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICrhRtkvmEA9FlnHmWYzsDIOg0nA+zIL4iuLPtGJiIoC jurre@surface3-management"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDfML1tz4bMJ7uAoIS5Hhd3cTE95X5QdaEJ8hR/1gWnE jurre@b302.nl"
  ];
in
{
  users.users.jurre = {
    isNormalUser = true;
    description = "Jurre";
    extraGroups = [ "wheel" "networkmanager" "lp" "scanner" ];
    openssh.authorizedKeys.keys = managementKeys;
  };
  users.users.root = {
    hashedPassword = "!";
    openssh.authorizedKeys.keys = managementKeys;
  };
}
