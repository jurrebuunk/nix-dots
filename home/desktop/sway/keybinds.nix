{ config, pkgs, lib, theme, ... }:

let
  mod = "Mod4";
in {
  wayland.windowManager.sway.config = {
    keybindings = lib.attrsets.mergeAttrsList [
      # je bestaande keybindings
      (lib.attrsets.mergeAttrsList (map (num: let
        ws = toString num;
      in {
        "${mod}+${ws}" = "workspace ${ws}";
        "${mod}+Ctrl+${ws}" = "move container to workspace ${ws}";
      }) [1 2 3 4 5 6 7 8 9 0]))

      (lib.attrsets.concatMapAttrs (key: direction: {
          "${mod}+${key}" = "focus ${direction}";
          "${mod}+Ctrl+${key}" = "move ${direction}";
        }) {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
        })

      {
        "${mod}+Return" = "exec --no-startup-id ${pkgs.alacritty}/bin/alacritty";
        "${mod}+space" = "exec rofi -show drun";
        "${mod}+Alt+space" = "exec rofi -show run";
        "${mod}+x" = "kill";
        "${mod}+a" = "focus parent";
        "${mod}+h" = "floating toggle";
        "${mod}+d" = "floating toggle, move position center";
        "${mod}+e" = "layout toggle split";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+g" = "split h";
        "${mod}+s" = "layout stacking";
        "${mod}+v" = "split v";
        "${mod}+w" = "layout tabbed";
        "${mod}+Shift+l" = "exec gtklock";
        "${mod}+Ctrl+Shift+l" = "exec swaylock";
        "${mod}+Shift+r" = "exec swaymsg reload";
        "${mod}+Shift+p" = "exec --no-startup-id ${config.home.homeDirectory}/.local/bin/pi-prompt";
        "--release Print" = "exec --no-startup-id ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
        "${mod}+Ctrl+q" = "exit";
        "${mod}+Shift+s" = "exec grim -g \"$(slurp)\" - | wl-copy";
        "XF86AudioRaiseVolume" = "exec ${pkgs.swayosd}/bin/swayosd-client --output-volume raise";
        "XF86AudioLowerVolume" = "exec ${pkgs.swayosd}/bin/swayosd-client --output-volume lower";
        "XF86AudioMute" = "exec ${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle";
        "XF86AudioMicMute" = "exec ${pkgs.swayosd}/bin/swayosd-client --input-volume mute-toggle";
        "XF86AudioPlay" = "exec ${pkgs.swayosd}/bin/swayosd-client --playerctl play-pause";
        "XF86AudioPause" = "exec ${pkgs.swayosd}/bin/swayosd-client --playerctl pause";
        "XF86AudioStop" = "exec ${pkgs.swayosd}/bin/swayosd-client --playerctl stop";
        "XF86AudioNext" = "exec ${pkgs.swayosd}/bin/swayosd-client --playerctl next";
        "XF86AudioPrev" = "exec ${pkgs.swayosd}/bin/swayosd-client --playerctl prev";
        "XF86MonBrightnessUp" = "exec ${pkgs.swayosd}/bin/swayosd-client --brightness raise";
        "XF86MonBrightnessDown" = "exec ${pkgs.swayosd}/bin/swayosd-client --brightness lower";
      }
    ];
  };
}
