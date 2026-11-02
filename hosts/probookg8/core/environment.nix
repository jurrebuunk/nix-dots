{ lib, ... }:

{
  environment.variables.PATH = [ "/home/jurre/.local/bin" ];
  environment.sessionVariables = {
    NIXOS_OZONE_WL = lib.mkForce "";
    XCURSOR_SIZE = "12";
  };
}
