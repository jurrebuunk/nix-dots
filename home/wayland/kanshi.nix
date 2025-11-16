{ config, pkgs, ... }:

let
  kanshiConfig = ''
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
    description = "Kanshi display manager";
    after = [ "graphical.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.kanshi}/bin/kanshi";
      Restart = "on-failure";
    };
    wantedBy = [ "default.target" ];
  };
}
