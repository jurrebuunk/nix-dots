# Hue Gradient theme with expanded design-system tokens.
#
# This keeps the legacy shape (`wallpaper`, `colors.bg`, `colors.fg`,
# `colors.blue`, `fonts.main`, etc.) so existing configs can adopt this file
# incrementally, while adding richer tokens from DESIGN.MD for later cleanup.
{
  name = "hue-gradient-design";
  wallpaper = "/home/jurre/nixos/themes/wallpapers/hue-gradient.jpg";

  colors = {
    # Legacy/common aliases used throughout the current config.
    bg = "#1b1818";
    fg = "#c4c1c1";
    black = "#1b1818";
    red = "#c97070";
    green = "#8fae9a";
    yellow = "#c2a27d";
    blue = "#8aa1a8";
    magenta = "#9b8fa3";
    cyan = "#9fc7c4";
    white = "#c4c1c1";
    orange = "#c2a27d";
    gray = "#666262";

    # DESIGN.MD palette tokens.
    background = "#1b1818";
    surface = "#252121";
    surfaceAlt = "#302b2b";

    text = "#c4c1c1";
    textMuted = "#918c8c";
    textFaint = "#777272";

    border = "#666262";
    borderStrong = "#7b7676";

    accent = "#8aa1a8";
    accentBright = "#a5bbc2";
    accentSoft = "#9fc7c4";
    highlight = "#d7ffc3";

    error = "#c97070";
    success = "#8fae9a";
    warning = "#c2a27d";
    secondary = "#9b8fa3";

    states = {
      default = "#252121";
      hover = "#302b2b";
      active = "#8aa1a8";
      focus = "#a5bbc2";
      disabled = "#777272";
      error = "#c97070";
      success = "#8fae9a";
      warning = "#c2a27d";
    };

    terminal = {
      black = "#1b1818";
      red = "#c97070";
      green = "#8fae9a";
      yellow = "#c2a27d";
      blue = "#8aa1a8";
      magenta = "#9b8fa3";
      cyan = "#9fc7c4";
      white = "#c4c1c1";

      brightBlack = "#777272";
      brightRed = "#df8a8a";
      brightGreen = "#a9c9b4";
      brightYellow = "#d8bb96";
      brightBlue = "#a5bbc2";
      brightMagenta = "#b7aabd";
      brightCyan = "#badeda";
      brightWhite = "#e5e2e2";

      foreground = "#c4c1c1";
      background = "#1b1818";
      cursor = "#a5bbc2";
    };
  };

  fonts = {
    # Legacy/common alias currently used by configs.
    main = "IBM Plex Mono";
    size = "10";

    # DESIGN.MD typography families.
    serif = "STIX Two Text";
    serifItalic = "STIX Two Text Italic";
    mono = "IBM Plex Mono";
    monoItalic = "IBM Plex Mono Italic";

    roles = {
      display = { family = "STIX Two Text"; sizePx = 26; weight = "regular"; style = "normal"; };
      heading = { family = "STIX Two Text"; sizePx = 19; weight = "regular"; style = "normal"; };
      subheading = { family = "STIX Two Text"; sizePx = 17; weight = "regular"; style = "italic"; };
      body = { family = "STIX Two Text"; sizePx = 16; weight = "regular"; style = "normal"; };
      supporting = { family = "STIX Two Text"; sizePx = 14; weight = "regular"; style = "italic"; };
      label = { family = "STIX Two Text"; sizePx = 14; weight = "regular"; style = "normal"; };
      caption = { family = "STIX Two Text"; sizePx = 13; weight = "regular"; style = "italic"; };
      technicalMetadata = { family = "IBM Plex Mono"; sizePx = 13; weight = "regular"; style = "normal"; };
      terminal = { family = "IBM Plex Mono"; sizePx = 15; weight = "regular"; style = "normal"; };
      code = { family = "IBM Plex Mono"; weight = "regular"; style = "normal"; };
    };
  };

  geometry = {
    radius = 0;
    radiusPx = "0px";

    border = {
      width = 1;
      widthPx = "1px";
      emphasisWidth = 2;
      emphasisWidthPx = "2px";
    };

    focusOutline = {
      width = 2;
      widthPx = "2px";
      color = "#a5bbc2";
    };

    shadow = "none";
    boxShadow = "none";
  };

  layout = {
    # Practical compact scale for configs. DESIGN.MD names compact, precise,
    # restrained spacing but does not prescribe exact numeric values.
    spacing = {
      none = 0;
      xxs = 2;
      xs = 4;
      sm = 6;
      md = 8;
      lg = 12;
      xl = 16;
      xxl = 24;
      xxxl = 32;
    };

    bar = {
      height = 20;
      margin = 8;
    };

    panel = {
      gap = 4;
      padding = 4;
      width = 380;
    };

    notification = {
      width = 380;
      padding = 12;
      margin = 4;
    };
  };

  animation = {
    subtle = true;
    durationFastMs = 120;
    durationNormalMs = 220;
    easing = "ease-out";
  };

  icons = {
    name = "Vimix-dark";
    package = "vimix-icon-theme";
  };

  cursor = {
    name = "McMojave-cursors";
    package = "mcmojave-cursors";
    size = 12;
  };

  gtk = {
    preferDark = true;
    iconTheme = "Vimix-dark";
    cursorTheme = "McMojave-cursors";
    cursorSize = 12;
  };
}
