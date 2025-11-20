{ config, pkgs, ... }:

let
  theme = import ../../themes/theme.nix;

  lyConfig = ''
    # Minimal Ly config using theme colors
    font = ${theme.fonts.main} ${theme.fonts.size}
    username-color = ${theme.colors.fg}
    password-color = ${theme.colors.fg}
    background-color = ${theme.colors.bg}
    password-char = "•"
    autologin = false
    hide-tty = false
    lock-screen = true
  '';
in
{
  home.file."/etc/ly/config.ini" = {
    text = lyConfig;
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
