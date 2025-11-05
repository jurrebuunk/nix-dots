{ config, pkgs, ... }:

{
  # PHP + common extensions
  environment.systemPackages = with pkgs; [
    php
    phpExtensions.mbstring
    phpExtensions.bcmath
    phpExtensions.curl
    phpExtensions.sqlite3
    phpExtensions.dom
    phpExtensions.fileinfo
    php84Packages.composer
    nodejs
  ];


  # Laravel installer via Composer
  environment.shellInit = ''
    export PATH=$HOME/.config/composer/vendor/bin:$PATH
  '';
}