{ pkgs, lib, config, ... }:

let
  autoLockCfg = config.custom.desktop.autoLock;
  screensaverCfg = config.custom.desktop.pipesScreensaver;

  screensaverWorkspacePrefix = "__pipes_saver";
  screensaverCloseCmd = if screensaverCfg.enable then "${screensaverClose}/bin/pipes-screensaver-close && " else "";

  screensaverOpen = pkgs.writeShellScriptBin "pipes-screensaver-open" ''
    set -euo pipefail

    export PATH=${lib.makeBinPath [ pkgs.coreutils pkgs.jq pkgs.sway pkgs.alacritty pkgs.pipes ]}:$PATH

    state_dir="$HOME/.cache/pipes-screensaver"
    workspaces_file="$state_dir/workspaces.tsv"
    mkdir -p "$state_dir"

    : > "$workspaces_file"

    ${pkgs.sway}/bin/swaymsg -t get_workspaces -r | ${pkgs.jq}/bin/jq -r '.[] | select(.visible == true) | [.output, .name] | @tsv' | while IFS=$'\t' read -r output workspace; do
      [ -n "${output:-}" ] || continue
      [ -n "${workspace:-}" ] || continue

      safe_output=$(printf '%s' "$output" | tr -cs 'A-Za-z0-9._-' '_')
      screensaver_workspace="${screensaverWorkspacePrefix}_$safe_output"
      title="pipes-$safe_output"

      printf '%s\t%s\t%s\n' "$output" "$workspace" "$title" >> "$workspaces_file"
      ${pkgs.sway}/bin/swaymsg "for_window [title=\"$title\"] fullscreen enable"
      ${pkgs.sway}/bin/swaymsg "workspace \"$screensaver_workspace\"; exec ${pkgs.alacritty}/bin/alacritty --title \"$title\" -o window.startup_mode=Fullscreen -e ${pkgs.pipes}/bin/pipes.sh -r 5000"
      ${pkgs.sway}/bin/swaymsg "move workspace to output \"$output\""
    done
  '';

  screensaverClose = pkgs.writeShellScriptBin "pipes-screensaver-close" ''
    set -euo pipefail

    export PATH=${lib.makeBinPath [ pkgs.coreutils pkgs.sway ]}:$PATH

    state_dir="$HOME/.cache/pipes-screensaver"
    workspaces_file="$state_dir/workspaces.tsv"

    if [ -f "$workspaces_file" ]; then
      while IFS=$'\t' read -r output workspace title; do
        [ -n "${title:-}" ] || continue
        ${pkgs.sway}/bin/swaymsg "[title=\"$title\"] kill" || true
        ${pkgs.sway}/bin/swaymsg "workspace \"$workspace\"; move workspace to output \"$output\"" || true
      done < "$workspaces_file"
      rm -f "$workspaces_file"
    fi
  '';
in
{
  options.custom.desktop.autoLock = {
    enable = lib.mkEnableOption "auto lock screen" // {
      default = true;
    };
  };

  options.custom.desktop.pipesScreensaver = {
    enable = lib.mkEnableOption "pipes screensaver" // {
      default = true;
    };

    timeout = lib.mkOption {
      type = lib.types.int;
      default = 300;
      description = "Time in seconds before starting the pipes screensaver";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf autoLockCfg.enable {
      services.swayidle = {
        enable = true;
        events = {
          before-sleep = "${screensaverCloseCmd}${pkgs.systemd}/bin/loginctl lock-session && ${pkgs.gtklock}/bin/gtklock -d && ${pkgs.coreutils}/bin/sleep 2";
          after-resume = "${pkgs.gtklock}/bin/gtklock -d";
          lock = "${pkgs.gtklock}/bin/gtklock -d";
        };
      };

      # Ensure lock tool is installed
      home.packages = [ pkgs.gtklock ];
    })

    (lib.mkIf screensaverCfg.enable {
      home.packages = [
        pkgs.pipes
        pkgs.jq
        screensaverOpen
        screensaverClose
      ];

      services.swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = screensaverCfg.timeout;
            command = "${screensaverOpen}/bin/pipes-screensaver-open";
            resumeCommand = "${screensaverClose}/bin/pipes-screensaver-close";
          }
        ];
      };
    })
  ];
}
