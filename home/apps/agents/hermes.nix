{ pkgs, theme, ... }:

{
  home.file.".local/share/icons/nix-flake.png".source = ../../../assets/images/nix-flake.png;

  home.file.".local/bin/launch-hermes" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      exec env HERMES_TUI=0 hermes chat
    '';
  };

  xdg.desktopEntries.hermes = {
    name = "Nixy";
    comment = "Launch Hermes in a floating terminal";
    exec = "${pkgs.alacritty}/bin/alacritty --class Hermes --title Hermes -e /home/jurre/.local/bin/launch-hermes";
    icon = "nix-flake";
    terminal = false;
    type = "Application";
    categories = [ "Utility" "Development" ];
  };

  home.file.".hermes/skins/nixy.yaml".text = ''
    name: nixy
    description: Nixy skin using active Nix theme colors
    colors:
      banner_border: "${theme.colors.gray}"
      banner_title: "${theme.colors.blue}"
      banner_accent: "${theme.colors.cyan}"
      banner_dim: "${theme.colors.gray}"
      banner_text: "${theme.colors.fg}"
      ui_accent: "${theme.colors.blue}"
      ui_label: "${theme.colors.cyan}"
      ui_ok: "${theme.colors.green}"
      ui_error: "${theme.colors.red}"
      ui_warn: "${theme.colors.yellow}"
      prompt: "${theme.colors.fg}"
      input_rule: "${theme.colors.gray}"
      response_border: "${theme.colors.blue}"
      status_bar_bg: "${theme.colors.bg}"
      status_bar_text: "${theme.colors.fg}"
      status_bar_strong: "${theme.colors.blue}"
      status_bar_dim: "${theme.colors.gray}"
      status_bar_good: "${theme.colors.green}"
      status_bar_warn: "${theme.colors.yellow}"
      status_bar_bad: "${theme.colors.orange}"
      status_bar_critical: "${theme.colors.red}"
      session_label: "${theme.colors.cyan}"
      session_border: "${theme.colors.gray}"
    branding:
      agent_name: "Nixy"
      welcome: "Nixy"
      goodbye: "Bye"
      response_label: " Nixy "
      prompt_symbol: ">"
      help_header: "Commands"
    banner_logo: |
      [bold ${theme.colors.blue}]_   _ _            [/]
      [bold ${theme.colors.blue}]| \ | (_)_  ___   _[/]
      [bold ${theme.colors.cyan}]|  \| | \ \/ / | | |[/]
      [bold ${theme.colors.cyan}]| |\  | |>  <| |_| |[/]
      [bold ${theme.colors.blue}]|_| \_|_/_/\_\\__, |[/]
      [bold ${theme.colors.blue}]               |___/[/]
    banner_hero: ""
  '';

  home.activation.setHermesNixySkin = ''
    if command -v hermes >/dev/null 2>&1; then
      hermes config set display.skin nixy >/dev/null 2>&1 || true
      hermes config set display.compact false >/dev/null 2>&1 || true
    fi
  '';
}
