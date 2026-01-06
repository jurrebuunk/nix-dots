{ config, pkgs, ... }:

{
  # Enable hibernation
  boot.resumeDevice = "/dev/disk/by-uuid/a782a126-8520-400e-8228-068879f1274d";

  # Power management configuration
  services.logind = {
    settings = {
      Login = {
        HandleLidSwitch = "suspend-then-hibernate";
        HandleLidSwitchExternalPower = "lock";
        HandleLidSwitchDocked = "ignore";
        HandlePowerKey = "suspend-then-hibernate";
        IdleAction = "suspend-then-hibernate";
        IdleActionSec = "30min";
      };
    };
  };

  # Configure suspend-then-hibernate timeout
  # This sets how long to stay in suspend before hibernating
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30min
  '';

  # Fix networking and DNS on wake
  # This service runs after the system resumes from sleep or hibernation
  systemd.services.network-resume-fix = {
    description = "Restart NetworkManager and Tailscale on resume";
    after = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];
    wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "network-resume-fix" ''
        echo "System resumed, restarting network services..."
        ${pkgs.systemd}/bin/systemctl restart NetworkManager
        ${pkgs.systemd}/bin/systemctl restart tailscaled
        # Re-trigger the tailscale priority rules if they exist
        ${pkgs.systemd}/bin/systemctl restart tailscale-priority || true
      '';
    };
  };
}
