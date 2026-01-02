{ config, pkgs, lib, ... }:

let
  battery-notify = pkgs.writeShellScriptBin "battery-notify" ''
    # Thresholds
    LOW=10
    CRITICAL=5
    URGENT=1

    # State file to avoid repeated notifications
    STATE_FILE="/tmp/battery_notify_state"

    # Ensure state file is removed on start
    rm -f "$STATE_FILE"

    while true; do
        if [ -d /sys/class/power_supply/BAT0 ]; then
            CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
            STATUS=$(cat /sys/class/power_supply/BAT0/status)

            if [ "$STATUS" = "Discharging" ]; then
                if [ "$CAPACITY" -le "$URGENT" ]; then
                    if [ ! -f "$STATE_FILE" ] || [ "$(cat $STATE_FILE)" != "urgent" ]; then
                        ${pkgs.libnotify}/bin/notify-send -u critical "Battery Urgent" "Battery level is at ''${CAPACITY}%!"
                        echo "urgent" > "$STATE_FILE"
                    fi
                elif [ "$CAPACITY" -le "$CRITICAL" ]; then
                    if [ ! -f "$STATE_FILE" ] || [ "$(cat $STATE_FILE)" != "critical" ]; then
                        ${pkgs.libnotify}/bin/notify-send -u critical "Battery Critical" "Battery level is at ''${CAPACITY}%!"
                        echo "critical" > "$STATE_FILE"
                    fi
                elif [ "$CAPACITY" -le "$LOW" ]; then
                    if [ ! -f "$STATE_FILE" ] || [ "$(cat $STATE_FILE)" != "low" ]; then
                        ${pkgs.libnotify}/bin/notify-send -u normal "Battery Low" "Battery level is at ''${CAPACITY}%!"
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
        sleep 60
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
