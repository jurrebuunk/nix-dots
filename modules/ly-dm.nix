{ config, pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway --config /etc/greetd/sway";
        user = "jurre";  # default username
      };
    };
  };

  environment.systemPackages = with pkgs; [
    gtkgreet
  ];

  ## Sway-config voor greetd
  environment.etc."greetd/sway".text = ''
    # start gtkgreet fullscreen / borderless
    exec ${pkgs.gtkgreet}/bin/gtkgreet -l
  '';

  ## Sessies die beschikbaar zijn in gtkgreet
  environment.etc."greetd/environments".text = ''
    sway
    bash
  '';
}
