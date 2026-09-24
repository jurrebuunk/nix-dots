{ config, lib, pkgs, theme, ... }:

let
  c = theme.colors;

  border30 = "${c.border}4D";
  accent15 = "${c.accent}26";
  highlight05 = "${c.highlight}0D";

  fontRegular = "${pkgs.ibm-plex}/share/fonts/truetype/IBMPlexMono-Regular.ttf";
  fontBold = "${pkgs.ibm-plex}/share/fonts/truetype/IBMPlexMono-Bold.ttf";
in
{
  home.packages = with pkgs; [
    supersonic-wayland
  ];

  home.activation.supersonicConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    cfg="${config.xdg.configHome}/supersonic/config.toml"
    mkdir -p "$(dirname "$cfg")"
    ${pkgs.python3}/bin/python - <<'PY'
import pathlib

path = pathlib.Path(r"""${config.xdg.configHome}/supersonic/config.toml""")
font_regular = r"""${fontRegular}"""
font_bold = r"""${fontBold}"""
text = path.read_text() if path.exists() else ""

def set_key(src, section, key, value):
    lines = src.splitlines()
    header = f"[{section}]"
    sec_idx = None
    for i, line in enumerate(lines):
        if line.strip() == header:
            sec_idx = i
            break
    if sec_idx is None:
        if src and not src.endswith("\n"):
            src += "\n"
        return src + f"{header}\n{key} = {value}\n"

    end = sec_idx + 1
    while end < len(lines) and not lines[end].strip().startswith("["):
        end += 1

    key_idx = None
    for i in range(sec_idx + 1, end):
        if lines[i].split("=", 1)[0].strip() == key:
            key_idx = i
            break

    if key_idx is not None:
        lines[key_idx] = f"{key} = {value}"
    else:
        lines.insert(sec_idx + 1, f"{key} = {value}")

    return "\n".join(lines) + ("\n" if src.endswith("\n") else "")

text = set_key(text, "Application", "FontNormalTTF", f"\"{font_regular}\"")
text = set_key(text, "Application", "FontBoldTTF", f"\"{font_bold}\"")
text = set_key(text, "Theme", "ThemeFile", "\"system-design.toml\"")

path.write_text(text)
PY
  '';

  xdg.configFile."supersonic/themes/system-design.toml" = {
    force = true;
    text = ''
      [SupersonicTheme]
      Name = "System Design"
      Version = "0.3"
      SupportsDark = true
      SupportsLight = false

      [DarkColors]
      PageBackground = "${c.background}"
      InputBackground = "${c.background}"
      InputBorder = "${border30}"
      MenuBackground = "${c.background}"
      OverlayBackground = "${c.background}"
      Pressed = "${accent15}"
      Hyperlink = "${c.accent}"
      ListHeader = "${highlight05}"
      PageHeader = "${c.background}"
      Background = "${c.background}"
      ScrollBar = "${border30}"
      Button = "${c.background}"
      DisabledButton = "${c.background}"
      Separator = "${border30}"
      Foreground = "${c.text}"
      Hover = "${accent15}"
    '';
  };
}
