{ inputs, pkgs, zen-browser, ... }:
{
  programs.firefox = {
    enable = true;
    package = inputs.zen-browser.packages.25.05.default;
    profiles.default.settings = {
      "browser.theme.content-theme" = 2;
      "zen.theme.custom_background_color" = "#1e1e2e";
    };
  };
}