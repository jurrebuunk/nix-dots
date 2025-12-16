{ config, pkgs, secrets, ... }:

{
  home.file.".config/winapps/winapps.conf" = {
    text = ''
      ##################################
      #   WINAPPS CONFIGURATION FILE   #
      ##################################

      RDP_USER="${secrets.winapps.rdpUser}"
      RDP_PASS="${secrets.winapps.rdpPass}"
      RDP_DOMAIN="."
      RDP_IP="${secrets.winapps.rdpIp}"
      VM_NAME=""
      WAFLAVOR="manual"
      RDP_SCALE="100"
      REMOVABLE_MEDIA="/run/media"
      RDP_FLAGS="/cert:tofu /sound /microphone +home-drive /scale-desktop:100 /dynamic-resolution" 
      DEBUG="true"
      AUTOPAUSE="off"
      AUTOPAUSE_TIME="300"
      FREERDP_COMMAND=""
      PORT_TIMEOUT="5"
      RDP_TIMEOUT="3000"
      APP_SCAN_TIMEOUT="6000"
      BOOT_TIMEOUT="120"
      HIDEF="on"
    '';
    target = ".config/winapps/winapps.conf";
    executable = false;
  };
}
