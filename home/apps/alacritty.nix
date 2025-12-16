{ pkgs, theme, ... }:

let
  alacrittyConfig = ''
    # Window
    window:
      padding:
        x: 5
        y: 5
      dynamic_title: false

    # Font
    font:
      normal:
        family: "${theme.fonts.main}"
      size: ${theme.fonts.size}

    # Colors
    colors:
      primary:
        background: "${theme.colors.bg}"
        foreground: "${theme.colors.fg}"

      cursor:
        text: "${theme.colors.bg}"
        cursor: "${theme.colors.fg}"

      selection:
        text: "${theme.colors.fg}"
        background: "${theme.colors.blue}"

      normal:
        black: "${theme.colors.black or "#000000"}"
        red: "${theme.colors.red}"
        green: "${theme.colors.green}"
        yellow: "${theme.colors.yellow}"
        blue: "${theme.colors.blue}"
        magenta: "${theme.colors.magenta}"
        cyan: "${theme.colors.cyan}"
        white: "${theme.colors.gray}"

      bright:
        black: "${theme.colors.gray}"
        red: "${theme.colors.red}"
        green: "${theme.colors.green}"
        yellow: "${theme.colors.yellow}"
        blue: "${theme.colors.blue}"
        magenta: "${theme.colors.magenta}"
        cyan: "${theme.colors.cyan}"
        white: "${theme.colors.fg}"

    # Cursor style
    cursor:
      style: Block
  '';
in
{
  programs.alacritty = {
    enable = true;
    extraConfig = alacrittyConfig;
  };
}
