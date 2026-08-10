{ config, pkgs, lib, theme, ... }:

let
  c = theme.colors;
  f = theme.fonts;
in
{
  programs.waybar = {
    enable = true; # Started explicitly by niri so it behaves like the old top bar.
    systemd.enable = false;
    package = pkgs.waybar;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 20;
        spacing = 0;
        # Match niri's window gap (see home/desktop/niri.nix: `gaps 8`).
        margin-left = 8;
        margin-right = 8;

        modules-left = [ "niri/workspaces" ];
        modules-center = [ ];
        modules-right = [ "cpu" "custom/sep1" "memory" "custom/sep2" "pulseaudio" "custom/sep3" "network" "custom/sep4" "battery" "custom/sep5" "custom/notification" "custom/sep6" "clock" ];

        "niri/workspaces" = {
          format = "{value}";
          all-outputs = false;
          disable-click = false;
          current-only = false;
        };

        clock = {
          format = "{:%Y-%m-%d %H:%M}";
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

        "custom/sep1" = { format = "|"; tooltip = false; };
        "custom/sep2" = { format = "|"; tooltip = false; };
        "custom/sep3" = { format = "|"; tooltip = false; };
        "custom/sep4" = { format = "|"; tooltip = false; };
        "custom/sep5" = { format = "|"; tooltip = false; };
        "custom/sep6" = { format = "|"; tooltip = false; };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          "format-icons" = {
            notification = "󰂞";
            none = "󰂚";
            "dnd-notification" = "󰂛";
            "dnd-none" = "󰪑";
            "inhibited-notification" = "󰂛";
            "inhibited-none" = "󰂚";
            "dnd-inhibited-notification" = "󰂛";
            "dnd-inhibited-none" = "󰪑";
          };
          "return-type" = "json";
          exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
          "exec-if" = "${pkgs.swaynotificationcenter}/bin/swaync-client -sw";
          "on-click" = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
          "on-click-right" = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
          escape = true;
        };

        cpu = {
          interval = 2;
          format = " {usage}%";
          tooltip-format = "CPU: {usage}%";
        };

        memory = {
          interval = 2;
          format = " {used:0.1f}G/{total:0.1f}G";
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
          format = " {volume}%";
          format-bluetooth = " {volume}%";
          format-bluetooth-muted = " muted";
          format-muted = "󰖁 muted";
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
        font-family: ${f.main}, "CaskaydiaMono Nerd Font", "Symbols Nerd Font Mono", "Font Awesome 6 Free", "Font Awesome 6 Brands";
        font-size: ${f.size}pt;
        min-height: 0;
        margin: 0;
        padding: 0;
      }

      window#waybar {
        background-color: ${c.bg};
        color: ${c.fg};
        border-left: 2px solid ${c.blue};
        border-right: 2px solid ${c.blue};
        border-bottom: 2px solid ${c.blue};
        border-top: none;
      }

      #workspaces {
        /* Keep workspace buttons inside the bar border so they don't paint over it. */
        margin: 0 0 2px 2px;
        padding: 0;
      }

      #workspaces button {
        padding: 0;
        margin: 0;
        min-width: 20px;
        min-height: 18px;
        color: ${c.gray};
        background: ${c.bg};
      }

      #workspaces button.active,
      #workspaces button.visible {
        color: ${c.fg};
        background: ${c.gray};
      }

      #workspaces button.focused,
      #workspaces button.current,
      #workspaces button.active.focused,
      #workspaces button.active.current,
      #workspaces button.visible.focused,
      #workspaces button.visible.current {
        color: ${c.fg};
        background: ${c.gray};
      }

      #workspaces button.urgent {
        color: ${c.fg};
        background: ${c.red};
      }

      #workspaces button:hover {
        background: ${c.gray};
      }

      #clock,
      #custom-notification,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #battery {
        padding: 0 4px;
      }

      #custom-sep1,
      #custom-sep2,
      #custom-sep3,
      #custom-sep4,
      #custom-sep5,
      #custom-sep6 {
        padding: 0 2px;
        color: ${c.gray};
      }

      #custom-notification {
        color: ${c.blue};
      }

      #clock {
        color: ${c.blue};
        font-weight: bold;
      }

      #cpu {
        color: ${c.green};
      }

      #memory {
        color: ${c.yellow};
      }

      #temperature {
        color: ${c.orange};
      }

      #temperature.critical {
        color: ${c.red};
        font-weight: bold;
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

      #battery {
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
