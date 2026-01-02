{ config, pkgs, lib, theme, ... }:
{
  services.mako = {
    enable = true;

    settings = {
      default-timeout = 10000;
      background-color = theme.colors.bg;
      text-color       = theme.colors.fg;
      border-color     = theme.colors.gray;
      progress-color   = theme.colors.green;

      border-size = 2;
      padding = 10;
      margin = 20;
      font = "${theme.fonts.main} ${theme.fonts.size}";
      anchor = "top-right";
    };

    extraConfig = ''
      [urgency=high]
      border-color=${theme.colors.red}
      default-timeout=0

      [category=status-update]
      anchor=top-center
      margin=25,0,0,0
      padding=5
      width=300
      text-alignment=center
      default-timeout=3000
    '';
  };
}
