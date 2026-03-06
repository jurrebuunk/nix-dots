{ config, pkgs, ... }:

{
  services.netbird = {
    enable = true;
    settings = {
      # Add any specific NetBird configuration here
    };
  };
}