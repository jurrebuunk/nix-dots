{ config, pkgs, ... }:

{
  xfconf.enable = true;

  xfconf.settings.thunar = {
    "last-view" = "ThunarDetailsView";
    "last-icon-view-zoom-level" = "THUNAR_ZOOM_LEVEL_100_PERCENT";
    "last-window-width" = 1276;
    "last-window-height" = 1053;
    "last-window-maximized" = false;
    "last-separator-position" = 170;
    "last-details-view-zoom-level" = "THUNAR_ZOOM_LEVEL_38_PERCENT";
    "last-details-view-column-widths" = "50,50,138,50,50,50,50,50,835,50,50,66,50,66";
    "last-compact-view-zoom-level" = "THUNAR_ZOOM_LEVEL_25_PERCENT";
    "last-splitview-separator-position" = -1;
    "last-side-pane" = "THUNAR_SIDEPANE_TYPE_TREE";
    "last-image-preview-visible" = true;
    "last-sort-column" = "THUNAR_COLUMN_NAME";
    "last-sort-order" = "GTK_SORT_DESCENDING";
    "misc-terminal-command" = "${pkgs.wezterm}/bin/wezterm";
  };

  xfconf.settings.exo-1 = {
    "TerminalEmulator" = "${pkgs.wezterm}/bin/wezterm";
  };

  xdg.configFile."Thunar/uca.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <actions>
    <action>
            <icon>utilities-terminal</icon>
            <name>Open Terminal Here</name>
            <submenu></submenu>
            <unique-id>1765145165427669-1</unique-id>
            <command>${pkgs.wezterm}/bin/wezterm start --working-directory %f</command>
            <description>Open terminal in the current directory</description>
            <range></range>
            <patterns>*</patterns>
            <startup-notify/>
            <directories/>
    </action>
    </actions>
  '';
}
