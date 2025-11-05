{ config, pkgs, ... }:

{
  home.file.".config/winapps/winapps.conf" = {
    text = ''
      ##################################
      #   WINAPPS CONFIGURATION FILE   #
      ##################################

      RDP_USER="User"
      RDP_PASS="#Buunkstra1448"
      RDP_DOMAIN="."
      RDP_IP="192.168.1.99"
      VM_NAME=""
      WAFLAVOR="manual"
      RDP_SCALE="100"
      REMOVABLE_MEDIA="/run/media"
      RDP_FLAGS="/cert:tofu /sound /microphone +home-drive"
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
