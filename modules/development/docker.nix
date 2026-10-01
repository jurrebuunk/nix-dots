{ pkgs, ... }:

{
  virtualisation.docker.enable = true;
  
  # Useful for running docker commands without sudo (if user is in docker group)
  # and general docker management
  environment.systemPackages = with pkgs; [
    docker-compose
    lazydocker
  ];
}
