{ theme, ... }:

let
  c = theme.colors;
in
{
  xdg.configFile."swayosd/config.toml".text = ''
    [server]
    top_margin = 0.012
    min_brightness = 5
    show_percentage = true

    [client]
  '';

  xdg.configFile."swayosd/style.css".text = ''
    window#osd {
      min-height: 40px;
      border-radius: 0;
      border: 2px solid ${c.blue};
      background: ${c.bg};
      color: ${c.fg};
    }

    window#osd #container {
      margin: 12px;
    }

    window#osd image,
    window#osd label {
      color: ${c.fg};
      font-size: 10pt;
    }

    window#osd image {
      -gtk-icon-size: 14px;
    }

    window#osd progressbar:disabled,
    window#osd image:disabled {
      opacity: 0.5;
    }

    window#osd progressbar,
    window#osd segmentedprogress {
      min-height: 4px;
      min-width: 180px;
      border-radius: 0;
      background: transparent;
      border: none;
    }

    window#osd trough,
    window#osd segment {
      min-height: inherit;
      border-radius: 0;
      border: none;
      background: ${c.gray};
    }

    window#osd progress,
    window#osd segment.active {
      min-height: inherit;
      border-radius: 0;
      border: none;
      background: ${c.blue};
    }

    window#osd segment {
      margin-left: 4px;
    }

    window#osd segment:first-child {
      margin-left: 0;
    }
  '';
}
