{ config, pkgs, ... }:

{
  xdg.configFile."kanshi/kanshi.conf".text = ''
    profile "lg-only" {
      output eDP-1 disabled
      output DP-4 enabled resolution 2560x1080 position 0,0
    }
  '';
}
