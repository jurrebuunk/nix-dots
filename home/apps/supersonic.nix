{ pkgs, theme, ... }:

let
  inherit (theme.colors) bg fg blue yellow gray;

  gray30 = "${gray}4D";
  blue15 = "${blue}26";
  yellow05 = "${yellow}0D";
in
{
  home.packages = with pkgs; [
    supersonic-wayland
  ];

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
