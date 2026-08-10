{ config, pkgs, lib, theme, ... }:

let
  c = theme.colors;
  f = theme.fonts;

  # SwayNC's default CSS uses rgba(var(--noti-bg), alpha), so expose the
  # theme background as RGB components as well as normal GTK colors.
  hexToInt = hex:
    let
      chars = lib.stringToCharacters hex;
      value = {
        "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4;
        "5" = 5; "6" = 6; "7" = 7; "8" = 8; "9" = 9;
        "a" = 10; "b" = 11; "c" = 12; "d" = 13; "e" = 14; "f" = 15;
        "A" = 10; "B" = 11; "C" = 12; "D" = 13; "E" = 14; "F" = 15;
      };
    in (value.${builtins.elemAt chars 0}) * 16 + value.${builtins.elemAt chars 1};

  hexToRgb = color:
    let
      clean = lib.removePrefix "#" color;
      red = hexToInt (builtins.substring 0 2 clean);
      green = hexToInt (builtins.substring 2 2 clean);
      blue = hexToInt (builtins.substring 4 2 clean);
    in "${toString red}, ${toString green}, ${toString blue}";


  systemInfoNotify = pkgs.writeShellScriptBin "swaync-system-info" ''
    export PATH=${lib.makeBinPath [
      pkgs.coreutils
      pkgs.gawk
      pkgs.gnugrep
      pkgs.gnused
      pkgs.libnotify
      pkgs.networkmanager
      pkgs.wireplumber
    ]}:$PATH

    id_file="''${XDG_RUNTIME_DIR:-/tmp}/swaync-system-info-notification-id"

    escape_markup() {
      sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
    }

    cpu_usage() {
      read idle1 total1 < <(awk '/^cpu / { idle=$5; total=0; for (i=2; i<=NF; i++) total+=$i; print idle, total; }' /proc/stat)
      sleep 0.15
      read idle2 total2 < <(awk '/^cpu / { idle=$5; total=0; for (i=2; i<=NF; i++) total+=$i; print idle, total; }' /proc/stat)
      awk -v idle1="$idle1" -v idle2="$idle2" -v total1="$total1" -v total2="$total2" 'BEGIN { total=total2-total1; idle=idle2-idle1; if (total <= 0) print 0; else printf "%.0f", (1 - idle / total) * 100; }'
    }

    mem_used() {
      awk '
        /^MemTotal:/ { total=$2 }
        /^MemAvailable:/ { available=$2 }
        END { printf "%.1fG/%.1fG", (total - available) / 1024 / 1024, total / 1024 / 1024 }
      ' /proc/meminfo
    }

    volume_status() {
      vol_info="$(wpctl get-volume @DEFAULT_SINK@ 2>/dev/null || true)"
      if echo "$vol_info" | grep -q MUTED; then
        echo "muted"
      else
        echo "$vol_info" | grep -oP '\d\.\d+' | awk '{ printf "%.0f%%", $1 * 100 }'
      fi
    }

    network_status() {
      wifi="$(nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi 2>/dev/null | awk -F: '$1 == "yes" { print $2 " " $3 "%"; found=1; exit } END { if (!found) print "" }')"
      if [ -n "$wifi" ]; then
        printf "%s" "$wifi" | escape_markup
      elif nmcli -t -f DEVICE,STATE dev 2>/dev/null | grep -q ':connected$'; then
        echo "wired"
      else
        echo "offline"
      fi
    }

    battery_status() {
      for battery in /sys/class/power_supply/BAT*/capacity; do
        if [ -r "$battery" ]; then
          capacity="$(cat "$battery")"
          status_file="$(dirname "$battery")/status"
          status=""
          [ -r "$status_file" ] && status=" $(cat "$status_file")"
          echo "$capacity%$status"
          return
        fi
      done
      echo "ac"
    }

    while true; do
      cpu="$(cpu_usage)"
      mem="$(mem_used)"
      vol="$(volume_status)"
      net="$(network_status)"
      bat="$(battery_status)"
      time="$(date '+%Y-%m-%d %H:%M')"

      body="<span foreground='${c.green}'> cpu ''${cpu}%</span>  <span foreground='${c.yellow}'> mem ''${mem}</span>
<span foreground='${c.magenta}'> vol ''${vol}</span>  <span foreground='${c.cyan}'>󰖩 net ''${net}</span>
<span foreground='${c.green}'>󱊣 bat ''${bat}</span>  <span foreground='${c.blue}'>󰥔 ''${time}</span>"

      if [ -s "$id_file" ]; then
        notify-send -p -r "$(cat "$id_file")" -a swaync-system-info -c swaync-system-info -u low -t 0 "system" "$body" > "$id_file" || rm -f "$id_file"
      else
        notify-send -p -a swaync-system-info -c swaync-system-info -u low -t 0 "system" "$body" > "$id_file" || rm -f "$id_file"
      fi

      sleep 5
    done
  '';
in
{
  # SwayNotificationCenter provides the notification daemon, so do not also
  # start mako and race for org.freedesktop.Notifications.
  services.mako.enable = lib.mkForce false;

  services.swaync = {
    enable = true;
    package = pkgs.swaynotificationcenter;

    settings = {
      "$schema" = "${pkgs.swaynotificationcenter}/etc/xdg/swaync/configSchema.json";
      "ignore-gtk-theme" = false;
      cssPriority = "user";

      positionX = "right";
      positionY = "top";
      layer = "overlay";
      "control-center-positionX" = "right";
      "control-center-positionY" = "top";
      "control-center-layer" = "overlay";
      "layer-shell" = true;
      "layer-shell-cover-screen" = true;
      "control-center-exclusive-zone" = false;

      # Full-height side panel with a small terminal-style screen-edge gutter.
      "control-center-margin-top" = 4;
      "control-center-margin-right" = 4;
      "control-center-margin-bottom" = 4;
      "control-center-margin-left" = 4;

      "notification-window-width" = 380;
      "control-center-width" = 380;
      "control-center-height" = -1;
      "fit-to-screen" = true;

      timeout = 10;
      "timeout-low" = 5;
      "timeout-critical" = 0;
      "keyboard-shortcuts" = true;
      "notification-grouping" = true;
      "notification-2fa-action" = true;
      "notification-inline-replies" = false;
      "notification-body-image-height" = 100;
      "notification-body-image-width" = 200;
      "image-visibility" = "when-available";
      "relative-timestamps" = true;
      "transition-time" = 220;
      "hide-on-clear" = false;
      "hide-on-action" = true;
      "text-empty" = "No notifications";
      "script-fail-notify" = true;

      "notification-visibility"."swaync-system-info" = {
        state = "muted";
        "app-name" = "swaync-system-info";
      };

      widgets = [
        "title"
        "dnd"
        "buttons-grid#power"
        "mpris"
        "notifications"
        "inhibitors"
      ];

      "widget-config" = {
        notifications.vexpand = true;
        inhibitors = {
          text = "Inhibitors";
          "button-text" = "Clear";
          "clear-all-button" = true;
        };
        title = {
          text = "Notifications";
          "button-text" = "Clear";
          "clear-all-button" = true;
        };
        dnd.text = "dnd";
        "buttons-grid#power" = {
          "buttons-per-row" = 2;
          actions = [
            { label = "reboot"; command = "${pkgs.systemd}/bin/systemctl reboot"; }
            { label = "shutdown"; command = "${pkgs.systemd}/bin/systemctl poweroff"; }
          ];
        };
        mpris = {
          blacklist = [];
          autohide = true;
          "show-album-art" = "when-available";
          "loop-carousel" = false;
        };
      };
    };

    style = ''
      :root {
        --cc-bg: ${c.bg};
        --noti-border-color: ${c.gray};
        --noti-bg: ${hexToRgb c.bg};
        --noti-bg-alpha: 1;
        --noti-bg-darker: ${c.bg};
        --noti-bg-hover: ${c.gray};
        --noti-bg-focus: ${c.gray};
        --noti-close-bg: ${c.gray};
        --noti-close-bg-hover: ${c.red};
        --text-color: ${c.fg};
        --text-color-disabled: ${c.gray};
        --bg-selected: ${c.blue};
        --notification-icon-size: 48px;
        --notification-app-icon-size: 18px;
        --notification-group-icon-size: 28px;
        --border: 2px solid ${c.gray};
        --border-radius: 0;
        --notification-shadow: none;
        --font-size-body: ${f.size}pt;
        --font-size-summary: ${f.size}pt;
        --hover-transition: background 0.12s ease-in-out;
        --hover-tranistion: background 0.12s ease-in-out;
      }

      @define-color bg ${c.bg};
      @define-color fg ${c.fg};
      @define-color gray ${c.gray};
      @define-color red ${c.red};
      @define-color green ${c.green};
      @define-color yellow ${c.yellow};
      @define-color blue ${c.blue};
      @define-color magenta ${c.magenta};
      @define-color cyan ${c.cyan};
      @define-color orange ${c.orange};
      @define-color cc-bg ${c.bg};
      @define-color noti-border-color ${c.gray};
      @define-color noti-bg ${c.bg};
      @define-color noti-bg-opaque ${c.bg};
      @define-color noti-bg-darker ${c.bg};
      @define-color noti-bg-hover ${c.gray};
      @define-color noti-bg-hover-opaque ${c.gray};
      @define-color noti-bg-focus ${c.gray};
      @define-color noti-close-bg ${c.gray};
      @define-color noti-close-bg-hover ${c.red};
      @define-color text-color ${c.fg};
      @define-color text-color-disabled ${c.gray};
      @define-color bg-selected ${c.blue};

      * {
        font-family: ${f.main}, "CaskaydiaMono Nerd Font", "Symbols Nerd Font Mono";
        font-size: ${f.size}pt;
        border-radius: 0;
        box-shadow: none;
        text-shadow: none;
      }

      notificationwindow,
      blankwindow,
      .blank-window,
      .floating-notifications {
        background: transparent;
        padding: 0;
      }

      @keyframes cc-slide-in-right {
        from {
          opacity: 0;
          margin-right: -32px;
        }
        to {
          opacity: 1;
          margin-right: 0;
        }
      }

      .control-center {
        background: @bg;
        color: @fg;
        border: 2px solid @blue;
        border-radius: 0;
        padding: 0;
        box-shadow: none;
        animation: cc-slide-in-right 220ms ease-out;
      }

      .control-center .control-center-list,
      .control-center .control-center-list-placeholder {
        background: transparent;
        color: @fg;
        margin: 0;
        padding: 0;
      }

      .control-center .control-center-list-placeholder {
        opacity: 0.6;
      }

      .notification-row {
        background: transparent;
        outline: none;
      }

      .notification-row:focus,
      .notification-row:hover,
      .notification-group:focus,
      .notification-group:hover {
        background: transparent;
      }

      .notification-row .notification-background {
        padding: 12px;
      }

      .notification-row .notification-background .notification {
        background: @bg;
        color: @fg;
        border: 2px solid @gray;
        border-radius: 0;
        padding: 0;
        box-shadow: none;
      }

      .notification-row .notification-background .notification.critical {
        border-color: @red;
      }

      .notification-row .notification-background .notification .notification-default-action,
      .notification-row .notification-background .notification .notification-action,
      .notification-row .notification-background .notification .notification-action > button {
        background: transparent;
        color: @fg;
        border: none;
        border-radius: 0;
        box-shadow: none;
      }

      .notification-row .notification-background .notification .notification-default-action:hover,
      .notification-row .notification-background .notification .notification-action > button:hover {
        background: @gray;
        color: @fg;
      }

      .notification-content {
        background: transparent;
        color: @fg;
        padding: 4px;
      }

      .notification-content .summary {
        color: @fg;
        font-weight: bold;
      }

      .notification-content .body,
      .notification-content .time {
        color: @fg;
      }

      .notification-content progressbar trough {
        background: @gray;
        border-radius: 0;
      }

      .notification-content progressbar progress {
        background: @blue;
        border-radius: 0;
      }

      .close-button {
        background: @gray;
        color: @fg;
        border: none;
        border-radius: 0;
        min-width: 20px;
        min-height: 20px;
        margin: 6px;
      }

      .close-button:hover {
        background: @red;
        color: @bg;
      }

      .widget {
        background: @bg;
        color: @fg;
        border: 2px solid @gray;
        border-radius: 0;
        margin: 0 0 4px 0;
        padding: 4px;
      }

      .widget:last-child {
        margin-bottom: 0;
      }

      .widget-title,
      .widget-dnd,
      .widget-inhibitors,
      .widget-mpris,
      .widget-buttons-grid {
        background: @bg;
        color: @fg;
      }

      .widget-title {
        padding: 4px 6px;
      }

      .widget-title > label,
      .widget-inhibitors > label,
      .widget-dnd label {
        color: @fg;
        font-weight: bold;
      }

      .widget-title > label {
        font-size: 12pt;
        margin-right: 8px;
      }

      .widget-title > button,
      .widget-inhibitors > button,
      .widget-dnd switch,
      .widget-dnd switch slider,
      .widget-buttons-grid flowboxchild > button {
        background: @bg;
        color: @fg;
        border: 2px solid @gray;
        border-radius: 0;
        box-shadow: none;
      }

      .widget-title > button,
      .widget-inhibitors > button {
        min-height: 24px;
        min-width: 72px;
        padding: 2px 8px;
        margin-left: 8px;
      }

      .widget-title > button:hover,
      .widget-inhibitors > button:hover,
      .widget-buttons-grid flowboxchild > button:hover {
        background: @gray;
      }

      .widget-dnd {
        padding: 4px 6px;
      }

      .widget-dnd label {
        margin-right: 8px;
      }

      .widget-dnd switch {
        min-width: 42px;
        min-height: 22px;
        margin-left: 8px;
        padding: 2px;
      }

      .widget-dnd switch slider {
        min-width: 14px;
        min-height: 14px;
        border: none;
        background: @fg;
      }

      .widget-dnd switch:checked {
        background: @blue;
        border-color: @blue;
      }

      .widget-buttons-grid {
        padding: 4px;
      }

      .widget-buttons-grid flowbox {
        margin: -2px;
      }

      .widget-buttons-grid flowboxchild {
        padding: 2px;
      }

      .widget-buttons-grid flowboxchild > button {
        min-height: 24px;
        padding: 2px 6px;
      }

      .widget-mpris {
        padding: 0;
        overflow: hidden;
      }

      .widget-mpris .widget-mpris-player,
      .widget-mpris .widget-mpris-player .mpris-overlay {
        background: @bg;
        color: @fg;
        border-radius: 0;
        box-shadow: none;
      }

      .widget-mpris .widget-mpris-player {
        margin: 0;
      }

      .widget-mpris .widget-mpris-player .mpris-overlay {
        padding: 4px;
      }

      .widget-mpris .widget-mpris-title {
        color: @fg;
        font-weight: bold;
      }

      .widget-mpris .widget-mpris-subtitle {
        color: @fg;
        opacity: 0.8;
      }

      .widget-inhibitors {
        padding: 4px 6px;
      }
    '';
  };

  systemd.user.services.swaync-system-info = {
    Unit = {
      Description = "SwayNC terminal-style system info notification";
      PartOf = [ config.wayland.systemd.target ];
      After = [ config.wayland.systemd.target "swaync.service" ];
    };

    Service = {
      ExecStart = "${systemInfoNotify}/bin/swaync-system-info";
      Restart = "on-failure";
      RestartSec = 2;
    };

    Install.WantedBy = [ config.wayland.systemd.target ];
  };
}
