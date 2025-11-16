{ config, pkgs, ... }:

let
  theme = import ../../themes/theme.nix;

  c = theme.colors;
in
{
  xdg.configFile."i3status/config".text = ''
    general {
      output_format = "i3bar"
      colors = true
      interval = 5

      color_good    = "${c.blue}"
      color_degraded = "${c.gray}"
      color_bad     = "${c.red}"
    }

    order += "wireless _first_"
    order += "ethernet _first_"
    order += "battery 0"
    order += "cpu_usage"
    order += "disk /"
    order += "load"
    order += "memory"
    order += "volume master"
    order += "tztime local"

    volume master {
      format = " %volume"
      format_muted = "%volume"
    }

    wireless _first_ {
      format_up = "󰖩%quality %essid"
      format_down = "󰖪down"
    }

    ethernet _first_ {
      format_up = "󰈁%ip"
      format_down = ""
    }

    battery 0 {
      format = "󱊣 %percentage %remaining"
      format_down = "No battery"
      threshold_type = percentage
      low_threshold = 15
    }

    cpu_usage {
      format = " %usage"
    }

    disk "/" {
      format = " %avail"
    }

    load {
      format = " %1min"
    }

    memory {
      format = " %used/%total"
      threshold_degraded = "10%"
      format_degraded = "MEMORY: %used"
    }

    tztime local {
      format = " %Y-%m-%d %H:%M"
    }
  '';
}
