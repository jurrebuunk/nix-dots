{ config, pkgs, lib, ... }:

let
  theme = import ../../themes/theme.nix;
  c = theme.colors;
  f = theme.fonts;
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        
        modules-left = [ "niri/workspaces" "niri/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" "tray" ];
        
        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            default = "";
          };
        };
        
        "niri/window" = {
          format = "{}";
          max-length = 50;
          separate-outputs = true;
        };
        
        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='${c.blue}'><b>{}</b></span>";
              days = "<span color='${c.fg}'><b>{}</b></span>";
              weeks = "<span color='${c.cyan}'><b>W{}</b></span>";
              weekdays = "<span color='${c.yellow}'><b>{}</b></span>";
              today = "<span color='${c.red}'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        
        cpu = {
          format = " {usage}%";
          tooltip = false;
        };
        
        memory = {
          format = " {}%";
        };
        
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = [ "" "" "" "" "" ];
        };
        
        network = {
          format-wifi = " {essid}";
          format-ethernet = " {ipaddr}";
          format-linked = " {ifname} (No IP)";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname} via {gwaddr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)  ";
          tooltip-format-ethernet = "{ifname}  ";
          tooltip-format-disconnected = "Disconnected";
        };
        
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-bluetooth-muted = " {icon}";
          format-muted = " {volume}%";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        
        tray = {
          spacing = 10;
        };
      };
    };
    
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: ${f.main};
        font-size: ${f.size}pt;
        min-height: 0;
      }
      
      window#waybar {
        background-color: ${c.bg};
        color: ${c.fg};
        transition-property: background-color;
        transition-duration: .5s;
      }
      
      window#waybar.hidden {
        opacity: 0.2;
      }
      
      #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        color: ${c.gray};
        border-bottom: 3px solid transparent;
      }
      
      #workspaces button:hover {
        background: rgba(0, 0, 0, 0.2);
        box-shadow: inherit;
        border-bottom: 3px solid ${c.gray};
      }
      
      #workspaces button.active {
        background-color: rgba(131, 165, 152, 0.2);
        color: ${c.blue};
        border-bottom: 3px solid ${c.blue};
      }
      
      #workspaces button.urgent {
        background-color: ${c.red};
        color: ${c.fg};
      }
      
      #clock,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #tray,
      #window {
        padding: 0 10px;
        color: ${c.fg};
      }
      
      #window {
        color: ${c.blue};
        font-weight: bold;
      }
      
      #battery.charging, #battery.plugged {
        color: ${c.green};
      }
      
      #battery.critical:not(.charging) {
        background-color: ${c.red};
        color: ${c.fg};
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }
      
      @keyframes blink {
        to {
          background-color: ${c.bg};
          color: ${c.red};
        }
      }
      
      #cpu {
        color: ${c.green};
      }
      
      #memory {
        color: ${c.yellow};
      }
      
      #network {
        color: ${c.cyan};
      }
      
      #network.disconnected {
        color: ${c.red};
      }
      
      #pulseaudio {
        color: ${c.magenta};
      }
      
      #pulseaudio.muted {
        color: ${c.gray};
      }
      
      #tray {
        background-color: transparent;
      }
      
      #tray > .passive {
        -gtk-icon-effect: dim;
      }
      
      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: ${c.red};
      }
    '';
  };
}
