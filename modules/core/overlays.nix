{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      ibm-plex-mono-nerd = prev.stdenvNoCC.mkDerivation {
        pname = "ibm-plex-mono-nerd-font";
        version = "3.3.0";

        src = prev.fetchzip {
          url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/IBMPlexMono.zip";
          sha256 = "13vbwibl5b5y8g3x8y5v5m84fx4v90s3iwc338jdhahxxisy4696";
          stripRoot = false;
        };

        installPhase = ''
          runHook preInstall
          mkdir -p $out/share/fonts/truetype
          cp -v *.ttf $out/share/fonts/truetype/
          runHook postInstall
        '';

        meta = with prev.lib; {
          description = "IBM Plex Mono Nerd Font";
          homepage = "https://www.nerdfonts.com/";
          license = licenses.mit;
          platforms = platforms.all;
        };
      };
    })
  ];
}
