{ pkgs, ... }:

{
  # Create a systemd user service that mounts an SSHFS of /home/jurre/.openclaw
  # from localhost into ~/openclaw. This uses sshfs so the local SSH key/user
  # configuration is respected.

  programs.ssh.enable = true;

  systemd.user.services.openclaw-mount = {
    Unit = {
      Description = "SSHFS mount of local openclaw directory";
      After = [ "network-online.target" ];
    };

    Service = {
      Environment = "PATH=/run/wrappers/bin:${pkgs.sshfs}/bin:${pkgs.coreutils}/bin";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/openclaw";
      # Mount /home/jurre/.openclaw from this machine via ssh to preserve any
      # SSH-specific behaviour. Uses IdentityFile from the user's SSH config.
      ExecStart = "${pkgs.sshfs}/bin/sshfs -o allow_other,follow_symlinks,StrictHostKeyChecking=no jurre@openclaw.lan.buunk.org:/home/jurre/.openclaw /home/jurre/openclaw";
      ExecStop = "/run/wrappers/bin/fusermount3 -u %h/openclaw";
      Restart = "on-failure";
      RestartSec = "10";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
