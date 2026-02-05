{ pkgs, lib, ... }:

let
  debPath = ../../secrets/PacketTracer822_amd64_signed_en-US_35234a27-3127-49bc-91ce-2926af76f07a.deb;
  packetTracerPkg = pkgs.ciscoPacketTracer8.override {
    packetTracerSource = debPath;
  };
in
{
  home.packages = lib.warnIf (!builtins.pathExists debPath)
    "Packet Tracer .deb missing at ${debPath}; download it from NetAcad to enable."
    (lib.optionals (builtins.pathExists debPath) [
      packetTracerPkg
    ]);
}
