{ config, pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "/run/current-system/sw/bin/niri --session";
        user = "jurre";
      };
      default_session = {
        command = "/run/current-system/sw/bin/scroll --config /etc/greetd/scroll";
        user = "jurre";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    gtkgreet
    niri
  ];

  ## Scroll-config for greetd
  environment.etc."greetd/scroll".text = ''
    # start gtkgreet fullscreen / borderless
    exec ${pkgs.gtkgreet}/bin/gtkgreet -l
  '';

  ## Sessies die beschikbaar zijn in gtkgreet
  environment.etc."greetd/environments".text = ''
    niri --session
    scroll
    sway
    bash
  '';
}
