{ config, lib, pkgs, theme, ... }:

let
  inherit (theme.colors) bg fg blue yellow gray;

  gray30 = "${gray}4D";
  blue15 = "${blue}26";
  yellow05 = "${yellow}0D";

  fontRegular = "${pkgs.nerd-fonts.caskaydia-mono}/share/fonts/truetype/NerdFonts/CaskaydiaMono/CaskaydiaMonoNerdFont-Regular.ttf";
  fontBold = "${pkgs.nerd-fonts.caskaydia-mono}/share/fonts/truetype/NerdFonts/CaskaydiaMono/CaskaydiaMonoNerdFont-Bold.ttf";
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
text = set_key(text, "Theme", "ThemeFile", "\"hue-gradient.toml\"")

path.write_text(text)
PY
  '';

  xdg.configFile."supersonic/themes/hue-gradient.toml" = {
    force = true;
    text = ''
      [SupersonicTheme]
      Name = "Hue Gradient"
      Version = "0.2"
      SupportsDark = true
      SupportsLight = false

      [DarkColors]
      PageBackground = "${bg}"
      InputBackground = "${bg}"
      InputBorder = "${gray30}"
      MenuBackground = "${bg}"
      OverlayBackground = "${bg}"
      Pressed = "${blue15}"
      Hyperlink = "${yellow}"
      ListHeader = "${yellow05}"
      PageHeader = "${bg}"
      Background = "${bg}"
      ScrollBar = "${gray30}"
      Button = "${bg}"
      DisabledButton = "${bg}"
      Separator = "${gray30}"
      Foreground = "${fg}"
      Hover = "${blue15}"
    '';
  };
}
