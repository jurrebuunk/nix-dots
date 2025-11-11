{ config, pkgs, lib, ... }: 

let
  mod = "Mod4";

  # Import the theme
  theme = import ../../themes/theme.nix;

  # Short aliases for readability
  c = theme.colors;
  f = theme.fonts;
in {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = mod;
      keybindings = lib.attrsets.mergeAttrsList [
        (lib.attrsets.mergeAttrsList (map (num: let
          ws = toString num;
        in {
          "${mod}+${ws}" = "workspace ${ws}";
          "${mod}+Ctrl+${ws}" = "move container to workspace ${ws}";
        }) [1 2 3 4 5 6 7 8 9 0]))

        (lib.attrsets.concatMapAttrs (key: direction: {
            "${mod}+${key}" = "focus ${direction}";
            "${mod}+Ctrl+${key}" = "move ${direction}";
          }) {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
          })

        {
          "${mod}+Return" = "exec --no-startup-id ${pkgs.wezterm}/bin/wezterm";
          #"${mod}+space" = "exec --no-startup-id wofi --show drun,run";
          "${mod}+space" = "exec dmenu_run";

          "${mod}+x" = "kill";

          "${mod}+a" = "focus parent";
          "${mod}+h" = "floating toggle";
          "${mod}+e" = "layout toggle split";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+g" = "split h";
          "${mod}+s" = "layout stacking";
          "${mod}+v" = "split v";
          "${mod}+w" = "layout tabbed";

          "${mod}+Shift+r" = "exec swaymsg reload";
          "--release Print" = "exec --no-startup-id ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
          "${mod}+Ctrl+q" = "exit";
        }
      ];
      focus.followMouse = false;
      workspaceAutoBackAndForth = true;
      bars = [ ];
    };
    extraConfig = ''
      # Border settings
      default_border pixel 2

      exec_always swaybg -i ${theme.wallpaper} -m fill

      # Font from theme
      font pango:${f.main} ${f.size}

      # Gruvbox colors from theme
      client.focused          ${c.blue} ${c.blue} ${c.fg} ${c.blue} ${c.blue}
      client.focused_inactive ${c.gray} ${c.gray} ${c.fg} ${c.gray} ${c.gray}
      client.unfocused        ${c.gray} ${c.gray} ${c.gray} ${c.gray} ${c.gray}
      client.urgent           ${c.red} ${c.red} ${c.fg} ${c.red} ${c.red}
      client.placeholder      ${c.bg} ${c.bg} ${c.fg} ${c.bg} ${c.bg}

      bar {
        position top
        status_command i3status
        colors {
          background ${c.bg}
          statusline ${c.fg}
          separator  ${c.gray}

          focused_workspace  ${c.blue} ${c.blue} ${c.fg}
          active_workspace   ${c.gray} ${c.gray} ${c.fg}
          inactive_workspace ${c.bg} ${c.bg} ${c.gray}
          urgent_workspace   ${c.red} ${c.red} ${c.fg}
        }
      }
    '';

    systemd.enable = true;
    wrapperFeatures = { gtk = true; };
  };

  home.file.".hm-graphical-session".text = pkgs.lib.concatStringsSep "\n" [
    "export MOZ_ENABLE_WAYLAND=1"
    "export NIXOS_OZONE_WL=1"
  ];

  services.cliphist.enable = true;
  
  fonts.fontconfig.enable = true;

  # Environment variables for GTK/Qt apps and Sway
  home.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
    QT_STYLE_OVERRIDE = "Adwaita-dark";
    XDG_CURRENT_DESKTOP = "sway";
  };

  xdg.configFile."gtk-3.0/settings.ini" = {
    text = ''
      [Settings]
      gtk-application-prefer-dark-theme=1
    '';
    force = true; # allows Home Manager to overwrite any existing file
  };
}
