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
    python310Full                # Python
    mariadb-connector-c          # MariaDB Connector/C

  ];

  #fix for python cert files
  environment.etc.certfile = {
    source = "/etc/ssl/certs/ca-bundle.crt";
    target = "ssl/cert.pem";
  };

  # Laravel installer via Composer
  environment.shellInit = ''
    export PATH=$HOME/.config/composer/vendor/bin:$PATH
  '';
}