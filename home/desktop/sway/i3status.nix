{ config, pkgs, theme, ... }:

let
  c = theme.colors;
in
{
  xdg.configFile."i3status/config".text = ''
    general {
      output_format = "i3bar"
      colors = true
      interval = 1

      color_good    = "${c.blue}"
      color_degraded = "${c.gray}"
      color_bad     = "${c.red}"
    }

    order += "read_file pi_answer"
    order += "read_file pi_status"
    order += "wireless _first_"
    order += "ethernet _first_"
    order += "battery 0"
    order += "cpu_usage"
    order += "memory"
    order += "volume master"
    order += "tztime local"

    read_file pi_answer {
      path = "${config.home.homeDirectory}/.cache/pi-answer.txt"
      format = "%content"
      format_bad = "%content"
      color_good = "${c.fg}"
      color_degraded = "${c.fg}"
      color_bad = "${c.fg}"
    }

    read_file pi_status {
      path = "${config.home.homeDirectory}/.cache/pi-status.txt"
      format = "%content"
      format_bad = "%content"
      color_good = "${c.gray}"
      color_degraded = "${c.gray}"
      color_bad = "${c.gray}"
    }

    volume master {
      format = " %volume"
      format_muted = " %volume"
    }

    wireless _first_ {
      format_up = "󰖩%quality %essid"
      format_down = "󰖪 down"
    }

    ethernet _first_ {
      format_up = "󰈁 %ip"
      format_down = "󰈂 down"
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
