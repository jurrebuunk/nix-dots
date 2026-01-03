{ config, pkgs, lib, ... }:

let
  brightness-control = pkgs.writeShellScriptBin "brightness-control" ''
    export PATH=$PATH:${pkgs.coreutils}/bin:${pkgs.brightnessctl}/bin:${pkgs.libnotify}/bin:${pkgs.gnugrep}/bin:${pkgs.gnused}/bin:${pkgs.mako}/bin

    case "$1" in
        up)
            brightnessctl set +5%
            ;;
        down)
            brightnessctl set 5%-
            ;;
    esac

    # Get brightness percentage
    BRIGHTNESS=$(brightnessctl info | grep -oP '\(\d+%\)' | tr -d '()%')

    # Dismiss any existing status-update notifications
    makoctl dismiss -a -c status-update

    ICON="󰃠"
    notify-send -c status-update -h string:x-mako-tag:status-update -h int:value:"$BRIGHTNESS" "$ICON Brightness: ''${BRIGHTNESS}%"
  '';
in
{
  home.packages = [ brightness-control ];
}
