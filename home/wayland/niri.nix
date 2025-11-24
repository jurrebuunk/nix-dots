{ config, pkgs, lib, ... }: 

let
  mod = "Super";

  theme = import ../../themes/theme.nix;
  c = theme.colors;
  f = theme.fonts;
in
{
  programs.niri.enable = true;

  xdg.configFile."niri/config.kdl".text = ''
    # ===============================
    # Niri configuration (HM managed)
    # ===============================

    font {
      family "${f.main}";
      size ${toString f.size};
    }

    # Theme colors
    background-color "${c.bg}";
    border-color "${c.gray}";
    focused-border-color "${c.blue}";

    # ===============================
    # Keybindings
    # ===============================
    bindings {

      # Launch terminal
      bind ${mod}+Return {
        exec "wezterm";
      }

      # App launcher (replace if needed)
      bind ${mod}+Space {
        exec "dmenu_run";
      }

      # Exit session
      bind ${mod}+Ctrl+Q {
        exit;
      }

      # Kill window
      bind ${mod}+X {
        close-window;
      }

      # Focus movement
      bind ${mod}+H { focus-left;  }
      bind ${mod}+J { focus-down;  }
      bind ${mod}+K { focus-up;    }
      bind ${mod}+L { focus-right; }

      # Move windows
      bind ${mod}+Ctrl+H { move-left;  }
      bind ${mod}+Ctrl+J { move-down;  }
      bind ${mod}+Ctrl+K { move-up;    }
      bind ${mod}+Ctrl+L { move-right; }

      # Workspaces 1–10
      ${lib.concatStringsSep "\n" (map (num:
        ''
        bind ${mod}+${toString num} { workspace ${toString num}; }
        bind ${mod}+Ctrl+${toString num} { move-to-workspace ${toString num}; }
        ''
      ) (lib.range 1 10))}
    }

    # ===============================
    # Workspace / Tiling behavior
    # ===============================
    layout {
      focus-follows-mouse false;
    }

    # ===============================
    # Status bar (remove if unused)
    # ===============================
    bar {
      height 24;
      position "top";
      background-color "${c.bg}";
      text-color "${c.fg}";
    }
  '';
}
