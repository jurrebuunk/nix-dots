{ pkgs, ... }:

{
  xdg.configFile."rclone/rclone.conf".text = ''
    [cpp-rw]
    type = webdav
    vendor = owncloud
    url = http://fs1.lan.buunk.org:3210/
    headers = Cookie,cppwd=REDACTED
    pacer_min_sleep = 0.01ms
  '';

  systemd.user.services.mount-fs1-rw = {
    Unit = {
      Description = "Mount Copyparty via rclone (Read-Write)";
      After = [ "network-online.target" ];
    };
    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/mnt/fs1-rw";
      ExecStart = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode writes --vfs-cache-max-age 5s --attr-timeout 5s --dir-cache-time 5s cpp-rw: %h/mnt/fs1-rw";
      ExecStop = "/run/current-system/sw/bin/fusermount -u %h/mnt/fs1-rw";
      Restart = "always";
      RestartSec = "10";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
