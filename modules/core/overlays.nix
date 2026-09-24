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

      gnome1-icon-theme = prev.stdenvNoCC.mkDerivation {
        pname = "gnome1-icon-theme";
        version = "0.1.5";

        src = prev.fetchurl {
          url = "https://download.gnome.org/sources/gnome-icon-theme/0.1/gnome-icon-theme-0.1.5.tar.gz";
          hash = "sha256-WRZcKCJ4UNA2Ja+tODVadCQRobVEOSfGm7C0XcKjV3g=";
        };

        dontConfigure = true;
        dontBuild = true;

        installPhase = ''
          runHook preInstall
          mkdir -p $out/share/icons/gnome-1
          cp -r index.theme 12x12 24x24 36x36 48x48 72x72 96x96 192x192 scalable $out/share/icons/gnome-1/
          substituteInPlace $out/share/icons/gnome-1/index.theme \
            --replace-fail "Name=Gnome" "Name=GNOME 1" \
            --replace-fail "Comment=Default Gnome Theme" "Comment=Early GNOME icon theme"
          printf '\nInherits=hicolor\n' >> $out/share/icons/gnome-1/index.theme

          # A few modern icon-name aliases make the old theme usable in current GTK apps.
          for size in 24x24 36x36 48x48 72x72 96x96; do
            fs="$out/share/icons/gnome-1/$size/filesystems"
            apps="$out/share/icons/gnome-1/$size/apps"
            dev="$out/share/icons/gnome-1/$size/devices"
            [ -e "$fs/gnome-fs-directory.png" ] && ln -s gnome-fs-directory.png "$fs/folder.png"
            [ -e "$fs/gnome-fs-home.png" ] && ln -s gnome-fs-home.png "$fs/user-home.png"
            [ -e "$fs/gnome-fs-regular.png" ] && ln -s gnome-fs-regular.png "$fs/text-x-generic.png"
            [ -e "$fs/gnome-fs-trash-empty.png" ] && ln -s gnome-fs-trash-empty.png "$fs/user-trash.png"
            [ -e "$fs/gnome-fs-trash-full.png" ] && ln -s gnome-fs-trash-full.png "$fs/user-trash-full.png"
            [ -e "$dev/gnome-dev-harddisk.png" ] && ln -s gnome-dev-harddisk.png "$dev/drive-harddisk.png"
            [ -e "$apps/gnome-starthere.png" ] && ln -s gnome-starthere.png "$apps/start-here.png"
          done
          runHook postInstall
        '';

        meta = with prev.lib; {
          description = "Early GNOME icon theme from the GNOME 1/2 transition era";
          homepage = "https://download.gnome.org/sources/gnome-icon-theme/0.1/";
          license = licenses.lgpl2Plus;
          platforms = platforms.linux;
        };
      };

      nscde-icon-theme = prev.stdenvNoCC.mkDerivation {
        pname = "nscde-icon-theme";
        version = "2.3";

        src = prev.fetchFromGitHub {
          owner = "NsCDE";
          repo = "NsCDE";
          rev = "2.3";
          hash = "sha256-tEy/XygLQOOGT2HIshk/qG+lFwT7Ol9Ewze+wY/th4Q=";
        };

        dontConfigure = true;
        dontBuild = true;

        installPhase = ''
          runHook preInstall
          mkdir -p $out/share/icons
          cp -r xdg/icons/NsCDE $out/share/icons/NsCDE
          # Prefer installed/common fallbacks; don't point at unavailable KDE/MATE themes.
          substituteInPlace $out/share/icons/NsCDE/index.theme \
            --replace-fail "Inherits=hicolor,breeze,mate,oxygen" "Inherits=gnome,hicolor"
          runHook postInstall
        '';

        meta = with prev.lib; {
          description = "CDE-inspired icon theme from NsCDE";
          homepage = "https://github.com/NsCDE/NsCDE";
          license = licenses.gpl3Only;
          platforms = platforms.linux;
        };
      };

      kde-locolor-icon-theme = prev.stdenvNoCC.mkDerivation {
        pname = "kde-locolor-icon-theme";
        version = "2.2.2";

        src = prev.fetchurl {
          url = "https://download.kde.org/Attic/2.2.2/src/kdeartwork-2.2.2.tar.bz2";
          hash = "sha256-LvgyNs5flZryd4pC9rr10FEy7tm5QSeHmW3eGL1bjBw=";
        };

        dontConfigure = true;
        dontBuild = true;

        installPhase = ''
          runHook preInstall
          iconDir=$out/share/icons/kde-locolor
          mkdir -p $iconDir
          cp -r Themes/Locolor/locolor/16x16 Themes/Locolor/locolor/32x32 $iconDir/
          rm -rf $iconDir/*/CVS $iconDir/*/*/CVS

          cat > $iconDir/index.theme <<'EOF'
[Icon Theme]
Name=KDE Locolor
Comment=Classic KDE low-color icon theme from KDE 2 era
Inherits=gnome,hicolor
Directories=16x16/actions,16x16/apps,16x16/devices,16x16/filesystems,16x16/mimetypes,32x32/actions,32x32/apps,32x32/devices,32x32/filesystems,32x32/mimetypes

[16x16/actions]
Size=16
Context=Actions
Type=Fixed
[16x16/apps]
Size=16
Context=Applications
Type=Fixed
[16x16/devices]
Size=16
Context=Devices
Type=Fixed
[16x16/filesystems]
Size=16
Context=FileSystems
Type=Fixed
[16x16/mimetypes]
Size=16
Context=MimeTypes
Type=Fixed
[32x32/actions]
Size=32
Context=Actions
Type=Fixed
[32x32/apps]
Size=32
Context=Applications
Type=Fixed
[32x32/devices]
Size=32
Context=Devices
Type=Fixed
[32x32/filesystems]
Size=32
Context=FileSystems
Type=Fixed
[32x32/mimetypes]
Size=32
Context=MimeTypes
Type=Fixed
EOF

          for size in 16x16 32x32; do
            fs="$iconDir/$size/filesystems"
            apps="$iconDir/$size/apps"
            dev="$iconDir/$size/devices"
            [ -e "$fs/folder.png" ] && ln -s folder.png "$fs/user-home.png"
            [ -e "$fs/folder_open.png" ] && ln -s folder_open.png "$fs/folder-open.png"
            [ -e "$fs/trashcan_empty.png" ] && ln -s trashcan_empty.png "$fs/user-trash.png"
            [ -e "$fs/trashcan_full.png" ] && ln -s trashcan_full.png "$fs/user-trash-full.png"
            [ -e "$fs/txt.png" ] && ln -s txt.png "$fs/text-x-generic.png"
            [ -e "$fs/exec.png" ] && ln -s exec.png "$fs/application-x-executable.png"
            [ -e "$dev/hdd_mount.png" ] && ln -s hdd_mount.png "$dev/drive-harddisk.png"
            [ -e "$apps/kfm_home.png" ] && ln -s kfm_home.png "$apps/go-home.png"
            [ -e "$apps/go.png" ] && ln -s go.png "$apps/start-here.png"
            [ -e "$apps/terminal.png" ] && ln -s terminal.png "$apps/utilities-terminal.png"
          done
          runHook postInstall
        '';

        meta = with prev.lib; {
          description = "Classic KDE Locolor icon theme from kdeartwork 2.2.2";
          homepage = "https://download.kde.org/Attic/2.2.2/src/";
          license = licenses.gpl2Plus;
          platforms = platforms.linux;
        };
      };
    })
  ];
}
