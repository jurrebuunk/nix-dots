{ pkgs, ... }:

{
  xdg.desktopEntries = {
    bluetooth = {
      name = "Bluetooth";
      genericName = "Bluetooth Manager";
      exec = "rofi-bluetooth";
      terminal = false;
      categories = [ "System" "Settings" ];
      icon = "bluetooth";
    };
    
    wifi = {
      name = "WiFi";
      genericName = "Network Manager";
      exec = "rofi-network-manager";
      terminal = false;
      categories = [ "System" "Settings" ];
      icon = "network-wireless";
    };
  };
}
