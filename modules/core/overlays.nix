{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    # Fix opencloud-desktop Qt6 QML dependencies
    (final: prev: {
      opencloud-desktop = prev.opencloud-desktop.overrideAttrs (oldAttrs: {
        buildInputs = (oldAttrs.buildInputs or []) ++ (with prev.qt6; [
          qtdeclarative
          qt5compat
          qttools
        ]);
        
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ (with prev.qt6; [
          wrapQtAppsHook
        ]);
        
        cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
          "-DQT_QML_GENERATE_QMLLS_INI=OFF"
        ];
        
        # Patch to fix QtQmlMeta include
        postPatch = (oldAttrs.postPatch or "") + ''
          # QtQmlMeta is not a standard Qt header, replace with proper QML headers
          find . -type f \( -name "*.h" -o -name "*.cpp" \) -exec sed -i 's|#include <QtQmlMeta>|#include <QtQml/qqmlregistration.h>|g' {} +
        '';
      });
    })
  ];
}
