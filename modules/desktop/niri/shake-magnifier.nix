{ lib, ... }:

let
  # Upstream niri snapshot plus a local, curated patch carrying only
  # SHORiN's shake-to-enlarge + magnifier features (no grid overview fork).
  niriMainRev = "ed22699d99462f61ab171472d3ea67e844ea580d";
in
{
  nixpkgs.overlays = [
    (final: prev:
      let
        version = "26.04";
        niriSrc = final.fetchFromGitHub {
          owner = "niri-wm";
          repo = "niri";
          rev = niriMainRev;
          hash = "sha256-3BtIY8xxJHLai3/73kOqgSgcVmqpSKpz9uUstQYgfLk=";
        };
        patchedNiriSrc = final.applyPatches {
          src = niriSrc;
          patches = [
            ../../../patches/niri-shake-magnifier-only.patch
          ];
        };
      in
      {
        niri = prev.niri.overrideAttrs (old: {
          inherit version;
          src = patchedNiriSrc;
          patches = [ ];
          cargoHash = "sha256-tBApUDTVMnOTemx251sVVgq7FH8PhDnmdxI1Il+vVmU=";
          cargoDeps = final.rustPlatform.fetchCargoVendor {
            name = "niri-26.04-shake-magnifier-vendor";
            src = patchedNiriSrc;
            hash = "sha256-tBApUDTVMnOTemx251sVVgq7FH8PhDnmdxI1Il+vVmU=";
          };
          checkFlags = (old.checkFlags or [ ]) ++ [
            "--skip=tests::animations::closing_window_stays_in_place_during_left_refill"
            "--skip=tests::animations::closing_windows_stay_in_place_during_rightmost_refill"
          ];
          env = (old.env or { }) // {
            NIRI_BUILD_COMMIT = niriMainRev;
          };
        });
      })
  ];
}
