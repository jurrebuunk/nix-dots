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
        command = "/run/current-system/sw/bin/niri --session";
        user = "jurre";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    niri
  ];

  environment.etc."greetd/environments".text = ''
    niri --session
    bash
  '';
}
