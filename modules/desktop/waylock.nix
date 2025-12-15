{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gtklock
    swayidle
  ];

  # Ensure PAM can be found
  environment.variables.PAM_MODULE_PATH = "/run/current-system/sw/lib/security";

  # Add a PAM file for gtklock
  systemd.tmpfiles.rules = [
    "f /etc/pam.d/gtklock 0644 root root -"
  ];

  # Drop the file contents via activation script
  system.activationScripts.gtklock-pam.text = ''
    cat > /etc/pam.d/gtklock <<EOF
auth       required   pam_unix.so
account    required   pam_unix.so
session    required   pam_permit.so
password   required   pam_unix.so
EOF
  '';

}
