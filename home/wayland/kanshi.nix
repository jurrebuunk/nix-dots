# home/kanshi.nix
{ config, pkgs, ... }:

let
  kanshiConfig = ''
    # Alleen externe LG ultrawide gebruiken
    profile lg-ultrawide-only {
      output eDP-1 disable
      output DP-4 enable mode 2560x1080 position 0,0
    }
  '';
in
{
  home.packages = [ pkgs.kanshi ];

  xdg.configFile."kanshi/config".text = kanshiConfig;

  systemd.user.services.kanshi = {
    enable = true;
    description = "Kanshi display manager";
    serviceConfig.ExecStart = "${pkgs.kanshi}/bin/kanshi";
    serviceConfig.Restart = "on-failure";
  };
}
