{ lib, ... }:

let
  # SHORiN-KiWATA's experimental niri fork with grid overview,
  # KDE-style cursor shake-to-enlarge, and magnifier support.
  shorinNiriRev = "8ebd8b165bd84a9e5c3912f2f0792996769137eb";
in
{
  nixpkgs.overlays = [
    (final: prev:
      let
        # Keep upstream version so nixpkgs' versionCheckHook matches `niri --version`.
        version = "26.04";
        niriSrc = final.fetchFromGitHub {
          owner = "SHORiN-KiWATA";
          repo = "niri";
          rev = shorinNiriRev;
          hash = "sha256-Ibvvb2fCXv2NDDiENut1qqcfcXz7F5RjeZA5PqeWnk8=";
        };
      in
      {
        niri = prev.niri.overrideAttrs (old: {
          inherit version;
          src = niriSrc;
          patches = [ ];
          cargoHash = "sha256-tBApUDTVMnOTemx251sVVgq7FH8PhDnmdxI1Il+vVmU=";
          cargoDeps = final.rustPlatform.fetchCargoVendor {
            pname = "niri";
            inherit version;
            src = niriSrc;
            hash = "sha256-tBApUDTVMnOTemx251sVVgq7FH8PhDnmdxI1Il+vVmU=";
          };
          checkFlags = (old.checkFlags or [ ]) ++ [
            "--skip=tests::animations::closing_window_stays_in_place_during_left_refill"
            "--skip=tests::animations::closing_windows_stay_in_place_during_rightmost_refill"
          ];
          env = (old.env or { }) // {
            NIRI_BUILD_COMMIT = shorinNiriRev;
          };
        });
      })
  ];
}
