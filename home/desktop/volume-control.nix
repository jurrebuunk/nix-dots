{ config, pkgs, lib, ... }:

let
  volume-control = pkgs.writeShellScriptBin "volume-control" ''
    export PATH=$PATH:${pkgs.coreutils}/bin:${pkgs.wireplumber}/bin:${pkgs.libnotify}/bin:${pkgs.gnugrep}/bin:${pkgs.sed}/bin

    case "$1" in
        up)
            wpctl set-volume @DEFAULT_SINK@ 0.05+
            ;;
        down)
            wpctl set-volume @DEFAULT_SINK@ 0.05-
            ;;
        mute)
            wpctl set-mute @DEFAULT_SINK@ toggle
            ;;
    esac

    # Get volume and muted state
    VOL_INFO=$(wpctl get-volume @DEFAULT_SINK@)
    VOLUME=$(echo "$VOL_INFO" | grep -oP '\d\.\d+' | awk '{print $1 * 100}')
    MUTED=$(echo "$VOL_INFO" | grep -o "MUTED")

    if [ -n "$MUTED" ]; then
        notify-send -c status-update -h string:x-mako-tag:volume "󰝟 Muted"
    else
        if [ "$VOLUME" -eq 0 ]; then
            ICON="󰝟"
        elif [ "$VOLUME" -lt 50 ]; then
            ICON="󰖀"
        else
            ICON="󰕾"
        fi
        notify-send -c status-update -h string:x-mako-tag:volume "$ICON Volume: ''${VOLUME}%"
    fi
  '';
in
{
  home.packages = [ volume-control ];
}
