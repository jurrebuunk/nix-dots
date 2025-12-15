{ config, pkgs, ... }:

let
  envs = import ./envs.nix { inherit pkgs; };
in
{
  environment.systemPackages = envs.laravel.packages;

  # Laravel installer via Composer
  environment.shellInit = envs.laravel.shellHook;
}
