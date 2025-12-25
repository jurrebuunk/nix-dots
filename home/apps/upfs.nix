{ pkgs, ... }:

{
  systemd.user.services.mount-fs1 = {
    description = "Mount Copyparty via upfs";
    after = [ "network-online.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/mnt/fs1";
      ExecStart = "${pkgs.copyparty}/bin/upfs http://jurre:REDACTED@fs1.lan.buunk.org:3210/ %h/mnt/fs1";
      ExecStop = "/run/current-system/sw/bin/fusermount -u %h/mnt/fs1";
      Restart = "always";
      RestartSec = "10";
    };
  };
}
