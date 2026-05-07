{ pkgs, theme, ... }:

let
  c = theme.colors;
  f = theme.fonts;
in
{
  xdg.configFile."scroll/config".text = ''
    set $mod Mod4
    floating_modifier $mod normal

    font pango:${f.main} ${toString f.size}

    default_border pixel 2
    default_floating_border pixel 2
    focus_follows_mouse no
    mouse_warping none

    output * bg ${theme.wallpaper} fill

    input type:touchpad {
      dwt enabled
      tap enabled
      tap_button_map lrm
      natural_scroll enabled
      middle_emulation enabled
      scroll_method two_finger
      click_method button_areas
    }

    client.focused          ${c.blue} ${c.blue} ${c.fg} ${c.blue} ${c.blue}
    client.focused_inactive ${c.gray} ${c.gray} ${c.fg} ${c.gray} ${c.gray}
    client.unfocused        ${c.gray} ${c.gray} ${c.gray} ${c.gray} ${c.gray}
    client.urgent           ${c.red} ${c.red} ${c.fg} ${c.red} ${c.red}
    client.placeholder      ${c.bg} ${c.bg} ${c.fg} ${c.bg} ${c.bg}

    # Gestures
    bindgesture swipe:3:left focus right
    bindgesture swipe:3:right focus left
    bindgesture swipe:3:up workspace prev
    bindgesture swipe:3:down workspace next
    bindgesture swipe:4:right workspace next
    bindgesture swipe:4:left workspace prev
    bindgesture swipe:4:up scale_workspace overview
    bindgesture swipe:4:down scale_workspace reset

    bindgesture pinch:inward+up move up
    bindgesture pinch:inward+down move down
    bindgesture pinch:inward+left move left
    bindgesture pinch:inward+right move right

    animations {
      enabled yes
      default yes 110 var 3 [ 0.24 0.78 0.25 1 ]
      window_open yes 95 var 3 [ 0 0 1 1 ]
      window_move yes 110 var 3 [ 0.24 0.78 0.25 1 ] off 0.02 6 [0 0.6 0.4 0 1 0 0.4 -0.6 1 -0.6]
      window_size yes 95 var 3 [ -0.35 0 0 0.5 ]
      workspace_switch yes 120 var simple [ 0.24 0.78 0.25 1 ]
      window_fullscreen yes 120 var simple [ 0.3 0.5 0.4 1 ]
    }

    # Startup
    exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=scroll
    exec systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec_always systemctl --user restart kanshi.service
    exec ${pkgs.gtklock}/bin/gtklock -d

    # Workspaces
    bindsym $mod+1 workspace 1
    bindsym $mod+2 workspace 2
    bindsym $mod+3 workspace 3
    bindsym $mod+4 workspace 4
    bindsym $mod+5 workspace 5
    bindsym $mod+6 workspace 6
    bindsym $mod+7 workspace 7
    bindsym $mod+8 workspace 8
    bindsym $mod+9 workspace 9
    bindsym $mod+0 workspace 10

    bindsym $mod+Ctrl+1 move container to workspace 1
    bindsym $mod+Ctrl+2 move container to workspace 2
    bindsym $mod+Ctrl+3 move container to workspace 3
    bindsym $mod+Ctrl+4 move container to workspace 4
    bindsym $mod+Ctrl+5 move container to workspace 5
    bindsym $mod+Ctrl+6 move container to workspace 6
    bindsym $mod+Ctrl+7 move container to workspace 7
    bindsym $mod+Ctrl+8 move container to workspace 8
    bindsym $mod+Ctrl+9 move container to workspace 9
    bindsym $mod+Ctrl+0 move container to workspace 10

    # Navigation
    bindsym $mod+h focus left
    bindsym $mod+j focus down
    bindsym $mod+k focus up
    bindsym $mod+l focus right

    bindsym $mod+Ctrl+h move left
    bindsym $mod+Ctrl+j move down
    bindsym $mod+Ctrl+k move up
    bindsym $mod+Ctrl+l move right

    # Apps and actions
    bindsym $mod+Return exec ${pkgs.alacritty}/bin/alacritty
    bindsym $mod+space exec rofi -show drun
    bindsym $mod+Alt+space exec rofi -show run
    bindsym $mod+x kill
    bindsym $mod+Shift+r reload
    bindsym $mod+Ctrl+q exit

    # Layout and window controls
    bindsym $mod+a focus parent
    bindsym $mod+e layout toggle split
    bindsym $mod+f fullscreen toggle
    bindsym $mod+g split h
    bindsym $mod+v split v
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+d floating toggle
    bindsym $mod+Shift+f floating toggle
    bindsym $mod+minus cycle_size h prev
    bindsym $mod+equal cycle_size h next

    # Lockscreen
    bindsym $mod+Shift+l exec ${pkgs.gtklock}/bin/gtklock -d
    bindsym $mod+Ctrl+Shift+l exec ${pkgs.swaylock}/bin/swaylock

    # Screenshots
    bindsym --release Print exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area
    bindsym $mod+Shift+s exec grim -g "$(slurp)" - | wl-copy

    # Media keys
    bindsym XF86AudioRaiseVolume exec volume-control up
    bindsym XF86AudioLowerVolume exec volume-control down
    bindsym XF86AudioMute exec volume-control mute
    bindsym XF86MonBrightnessUp exec brightness-control up
    bindsym XF86MonBrightnessDown exec brightness-control down

    bar {
      position top
      status_command i3status
      colors {
        background ${c.bg}
        statusline ${c.fg}
        separator  ${c.gray}
        binding_mode ${c.bg} ${c.bg} ${c.gray}
        scroller ${c.bg} ${c.bg} ${c.gray}

        focused_workspace  ${c.blue} ${c.blue} ${c.fg}
        active_workspace   ${c.gray} ${c.gray} ${c.fg}
        inactive_workspace ${c.bg} ${c.bg} ${c.gray}
        urgent_workspace   ${c.red} ${c.red} ${c.fg}
      }
    }
  '';
}
