{
  wallpaper = "/home/jurre/nixos/themes/wallpapers/starship-stage-sep.jpg";

  colors = {
    bg        = "#010409";
    fg        = "#e6edf3";

    # Normal colors
    black     = "#484f58";
    red       = "#ff7b72";
    green     = "#3fb950";
    yellow    = "#d29922";
    blue      = "#58a6ff";
    magenta   = "#bc8cff";
    cyan      = "#39c5cf";
    white     = "#b1bac4";

    # Bright colors
    brightBlack   = "#6e7681";
    brightRed     = "#ffa198";
    brightGreen   = "#56d364";
    brightYellow  = "#e3b341";
    brightBlue    = "#79c0ff";
    brightMagenta = "#d2a8ff";
    brightCyan    = "#56d4dd";
    brightWhite   = "#ffffff";

    # Legacy mappings (for tools expecting the older theme structure)
    orange    = "#d29922"; # Mapping yellow to orange as fallback
    gray      = "#484f58";
  };

  fonts = {
    main = "CaskaydiaMono Nerd Font";
    size = "10";
  };
}
