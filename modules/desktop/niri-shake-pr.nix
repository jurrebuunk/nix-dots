{ lib, ... }:

let
  # Snapshot of niri main used for the local shake-to-locate test build.
  # Update this rev/hash when rebasing the PR patch onto newer upstream main.
  niriMainRev = "ed22699d99462f61ab171472d3ea67e844ea580d";
in
{
  nixpkgs.overlays = [
    (final: prev:
      let
        # Keep upstream version so nixpkgs' versionCheckHook matches `niri --version`.
        version = "26.04";
        niriSrc = final.fetchFromGitHub {
          owner = "niri-wm";
          repo = "niri";
          rev = niriMainRev;
          hash = "sha256-3BtIY8xxJHLai3/73kOqgSgcVmqpSKpz9uUstQYgfLk=";
        };
      in
      {
        niri = prev.niri.overrideAttrs (old: {
          inherit version;
          src = niriSrc;
          patches = (old.patches or [ ]) ++ [
            ../../patches/niri-shake-to-locate-pr2797.patch
          ];
          cargoHash = "sha256-vtTh+TG6TdX46QydGKaeo50u2qdQf3UkQ50EML+5H9c=";
          cargoDeps = final.rustPlatform.fetchCargoVendor {
            pname = "niri";
            inherit version;
            src = niriSrc;
            hash = "sha256-vtTh+TG6TdX46QydGKaeo50u2qdQf3UkQ50EML+5H9c=";
          };
          env = (old.env or { }) // {
            NIRI_BUILD_COMMIT = niriMainRev;
          };
        });
      })
  ];
}
