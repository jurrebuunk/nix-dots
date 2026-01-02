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
        "${mod}+Return" = "exec --no-startup-id ${pkgs.wezterm}/bin/wezterm";
        "${mod}+space" = "exec rofi -show drun";
        "${mod}+Alt+space" = "exec rofi -show run";
        "${mod}+x" = "kill";
        "${mod}+a" = "focus parent";
        "${mod}+h" = "floating toggle";
        "${mod}+e" = "layout toggle split";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+g" = "split h";
        "${mod}+s" = "layout stacking";
        "${mod}+v" = "split v";
        "${mod}+w" = "layout tabbed";
        "${mod}+Shift+l" = "exec gtklock";
        "${mod}+Ctrl+Shift+l" = "exec swaylock";
        "${mod}+Shift+r" = "exec swaymsg reload";
        "--release Print" = "exec --no-startup-id ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
        "${mod}+Ctrl+q" = "exit";
        "${mod}+Shift+s" = "exec grim -g \"$(slurp)\" - | wl-copy";
        "XF86AudioRaiseVolume" = "exec volume-control up";
        "XF86AudioLowerVolume" = "exec volume-control down";
        "XF86AudioMute" = "exec volume-control mute";
        "XF86MonBrightnessUp" = "exec brightnessctl set +10%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";
      }
    ];
  };
}
