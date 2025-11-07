{ pkgs, ... }: 

{
  #import configurations for user specific sway desktop environment
  imports = [
    ./sway.nix
    ./i3status.nix
  ];
}
