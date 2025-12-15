{ config, pkgs, ... }:

let
  envs = import ./envs.nix { inherit pkgs; };
in
{
  environment.systemPackages = envs.python.packages;

  # Fix for python cert files
  environment.etc.certfile = {
    source = "/etc/ssl/certs/ca-bundle.crt";
    target = "ssl/cert.pem";
  };
}
