{ config, pkgs, ... }:

# Import your theme
let
  theme = import ../themes/theme.nix;
  weztermConfig = ''
    local wezterm = require 'wezterm';
    return {
      -- Disable tab bar
      enable_tab_bar = false;

      -- Colors from theme
      colors = {
        background = "${theme.colors.bg}";
        foreground = "${theme.colors.fg}";
        cursor_bg = "${theme.colors.fg}";
        cursor_fg = "${theme.colors.bg}";
        cursor_border = "${theme.colors.fg}";
        selection_bg = "${theme.colors.blue}";
        selection_fg = "${theme.colors.fg}";

        ansi = {
          "${theme.colors.black or "#000000"}", -- fallback
          "${theme.colors.red}";
          "${theme.colors.green}";
          "${theme.colors.yellow}";
          "${theme.colors.blue}";
          "${theme.colors.magenta}";
          "${theme.colors.cyan}";
          "${theme.colors.gray}";
        };

        brights = {
          "${theme.colors.gray}";
          "${theme.colors.red}";
          "${theme.colors.green}";
          "${theme.colors.yellow}";
          "${theme.colors.blue}";
          "${theme.colors.magenta}";
          "${theme.colors.cyan}";
          "${theme.colors.fg}";
        };
      };

      -- Font
      font = wezterm.font("${theme.fonts.main}");
      font_size = tonumber("${theme.fonts.size}");
    }
  '';
in {
  programs.wezterm = {
    enable = true;
    extraConfig = weztermConfig;
  };
}
