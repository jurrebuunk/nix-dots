{ config, pkgs, ... }:

let
  envs = import ./envs.nix { inherit pkgs; };
in
{
  virtualisation.docker.enable = true;
  
  # Useful for running docker commands without sudo (if user is in docker group)
  # and general docker management
  environment.systemPackages = envs.docker.packages;
}
