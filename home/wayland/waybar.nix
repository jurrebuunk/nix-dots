{ config, pkgs, lib, ... }:

let
  theme = import ../../themes/theme.nix;
  c = theme.colors;
  f = theme.fonts;
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = false; # We start it from niri config
    package = pkgs.waybar;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 22;
        spacing = 0;
        
        modules-left = [ "clock" ];
        modules-center = [ ];
        modules-right = [ "cpu" "memory" "temperature" "pulseaudio" "network" "battery" ];
        
        clock = {
          format = "  {:%Y-%m-%d %H:%M}";
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
        };
        
        cpu = {
          interval = 2;
          format = "  {usage}%";
          tooltip-format = "CPU: {usage}%";
        };
        
        memory = {
          interval = 2;
          format = "  {used:0.1f}G/{total:0.1f}G";
          tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G ({percentage}%)";
        };
        
        temperature = {
          interval = 2;
          thermal-zone = 0;
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = [ "" "" "" "" "" ];
          tooltip = false;
        };
        
        battery = {
          interval = 10;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "󱊣 {capacity}%";
          format-charging = "󱊣 {capacity}%";
          format-plugged = "󱊣 {capacity}%";
          tooltip-format = "{capacity}% {timeTo}";
        };
        
        network = {
          interval = 2;
          format-wifi = "󰖩 {essid} {signalStrength}%";
          format-ethernet = "󰈁 {ipaddr}";
          format-disconnected = "󰖪";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "{ifname}: {ipaddr}";
          tooltip-format-disconnected = "Disconnected";
        };
        
        pulseaudio = {
          format = " {volume}%";
          format-bluetooth = " {volume}%";
          format-bluetooth-muted = " {volume}%";
          format-muted = " {volume}%";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "pavucontrol";
          tooltip-format = "{desc}: {volume}%";
        };
      };
    };
    
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: ${f.main}, "Font Awesome 6 Free";
        font-size: ${f.size}pt;
        min-height: 0;
        margin: 0;
        padding: 0;
      }
      
      window#waybar {
        background-color: ${c.bg};
        color: ${c.fg};
      }
      
      #clock {
        color: ${c.blue};
        font-weight: bold;
      }
      
      #cpu {
        padding: 0 8px;
        color: ${c.green};
      }
      
      #memory {
        padding: 0 8px;
        color: ${c.yellow};
      }
      
      #temperature {
        padding: 0 8px;
        color: ${c.orange};
      }
      
      #temperature.critical {
        color: ${c.red};
        font-weight: bold;
      }
      
      #network {
        padding: 0 8px;
        color: ${c.cyan};
      }
      
      #network.disconnected {
        color: ${c.red};
      }
      
      #pulseaudio {
        padding: 0 8px;
        color: ${c.magenta};
      }
      
      #pulseaudio.muted {
        color: ${c.gray};
      }
      
      #battery {
        padding: 0 10px;
        color: ${c.green};
      }
      
      #battery.charging {
        color: ${c.blue};
      }
      
      #battery.warning:not(.charging) {
        color: ${c.yellow};
      }
      
      #battery.critical:not(.charging) {
        color: ${c.red};
        animation: blink 1s linear infinite;
      }
      
      @keyframes blink {
        0% {
          opacity: 1;
        }
        49% {
          opacity: 1;
        }
        50% {
          opacity: 0.5;
        }
        100% {
          opacity: 0.5;
        }
      }
    '';
  };
}
