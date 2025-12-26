{ pkgs, ... }:

{
  xdg.configFile."rclone/rclone.conf".text = ''
    [cpp-rw]
    type = webdav
    vendor = owncloud
    url = http://fs1.lan.buunk.org:3210/
    user = jurre
    pass = LhdPEEVee7XrfP4iG9nKVMdPjM9hONRo3z6Fi-GX
    pacer_min_sleep = 0.01ms

    [cpp-ro]
    type = http
    url = http://fs1.lan.buunk.org:3210/
    headers = Cookie,cppwd=jurre:REDACTED
  '';

  systemd.user.services.mount-fs1 = {
    Unit = {
      Description = "Mount Copyparty via rclone";
      After = [ "network-online.target" ];
    };
    Service = {
      Environment = "PATH=/run/wrappers/bin:${pkgs.rclone}/bin:${pkgs.coreutils}/bin:/run/current-system/sw/bin";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/mnt/fs1";
      ExecStart = "${pkgs.rclone}/bin/rclone mount cpp-rw: %h/mnt/fs1 --vfs-cache-mode writes --vfs-cache-max-age 5s --attr-timeout 5s --dir-cache-time 5s";
      ExecStop = "/run/wrappers/bin/fusermount3 -u %h/mnt/fs1";
      Restart = "always";
      RestartSec = "10";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
