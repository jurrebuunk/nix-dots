{ config, pkgs, lib, ... }:

let
  battery-notify = pkgs.writeShellScriptBin "battery-notify" ''
    export PATH=$PATH:${pkgs.coreutils}/bin:${pkgs.mako}/bin

    # Thresholds
    LOW=10
    CRITICAL=5
    URGENT=1

    # State files to avoid repeated notifications
    STATE_FILE="/tmp/battery_notify_state"
    CHARGE_STATE_FILE="/tmp/battery_charge_state"

    # Ensure state files are removed on start
    rm -f "$STATE_FILE" "$CHARGE_STATE_FILE"

    while true; do
        if [ -d /sys/class/power_supply/BAT0 ]; then
            CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
            STATUS=$(cat /sys/class/power_supply/BAT0/status)

            # Handle charging/discharging notifications
            if [ -f "$CHARGE_STATE_FILE" ]; then
                LAST_STATUS=$(cat "$CHARGE_STATE_FILE")
                if [ "$STATUS" != "$LAST_STATUS" ]; then
                    makoctl dismiss -a -c status-update
                    if [ "$STATUS" = "Charging" ]; then
                        ${pkgs.libnotify}/bin/notify-send -c status-update -h string:x-mako-tag:status-update -h int:value:"$CAPACITY" "󱐋 Charging (''${CAPACITY}%)"
                    elif [ "$STATUS" = "Discharging" ]; then
                        ${pkgs.libnotify}/bin/notify-send -c status-update -h string:x-mako-tag:status-update -h int:value:"$CAPACITY" "󱐌 Discharging (''${CAPACITY}%)"
                    fi
                    echo "$STATUS" > "$CHARGE_STATE_FILE"
                fi
            else
                echo "$STATUS" > "$CHARGE_STATE_FILE"
            fi

            if [ "$STATUS" = "Discharging" ]; then
                if [ "$CAPACITY" -le "$URGENT" ]; then
                    if [ ! -f "$STATE_FILE" ] || [ "$(cat $STATE_FILE)" != "urgent" ]; then
                        ${pkgs.libnotify}/bin/notify-send -u critical "󰂃 Battery Urgent (''${CAPACITY}%)"
                        echo "urgent" > "$STATE_FILE"
                    fi
                elif [ "$CAPACITY" -le "$CRITICAL" ]; then
                    if [ ! -f "$STATE_FILE" ] || [ "$(cat $STATE_FILE)" != "critical" ]; then
                        ${pkgs.libnotify}/bin/notify-send -u critical "󰂃 Battery Critical (''${CAPACITY}%)"
                        echo "critical" > "$STATE_FILE"
                    fi
                elif [ "$CAPACITY" -le "$LOW" ]; then
                    if [ ! -f "$STATE_FILE" ] || [ "$(cat $STATE_FILE)" != "low" ]; then
                        ${pkgs.libnotify}/bin/notify-send -u normal "󰂃 Battery Low (''${CAPACITY}%)"
                        echo "low" > "$STATE_FILE"
                    fi
                else
                    # Reset state if capacity is above LOW
                    rm -f "$STATE_FILE"
                fi
            else
                # Reset state if not discharging (e.g. charging or full)
                rm -f "$STATE_FILE"
            fi
        fi
        sleep 5
    done
  '';
in
{
  home.packages = [ battery-notify ];

  systemd.user.services.battery-notify = {
    Unit = {
      Description = "Battery notification service";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${battery-notify}/bin/battery-notify";
      Restart = "always";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
