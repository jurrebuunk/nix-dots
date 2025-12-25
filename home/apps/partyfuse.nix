{ pkgs, ... }:

{
  systemd.user.services.mount-fs1 = {
    Unit = {
      Description = "Mount Copyparty via partyfuse";
      After = [ "network-online.target" ];
    };
    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/mnt/fs1";
      ExecStart = "${pkgs.copyparty}/bin/partyfuse http://fs1.lan.buunk.org:3210/ %h/mnt/fs1 -a 'jurre:REDACTED'";
      ExecStop = "/run/current-system/sw/bin/fusermount -u %h/mnt/fs1";
      Restart = "always";
      RestartSec = "10";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
