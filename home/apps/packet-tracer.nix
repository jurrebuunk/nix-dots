{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cisco-packet-tracer
  ];
}
