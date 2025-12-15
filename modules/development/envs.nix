{ pkgs }:

{
  python = {
    packages = with pkgs; [
      python315
    ];
    shellHook = ''
      echo "🐍 Python Environment Loaded"
    '';
  };

  laravel = {
    packages = with pkgs; [
      php
      phpExtensions.mbstring
      phpExtensions.bcmath
      phpExtensions.curl
      phpExtensions.sqlite3
      phpExtensions.dom
      phpExtensions.fileinfo
      php84Packages.composer
      nodejs
      mariadb-connector-c
    ];
    shellHook = ''
      echo "🐘 Laravel/PHP Environment Loaded"
      export PATH=$HOME/.config/composer/vendor/bin:$PATH
    '';
  };

  docker = {
    packages = with pkgs; [
      docker-compose
      lazydocker
    ];
    shellHook = ''
      echo "🐳 Docker Tools Loaded"
    '';
  };
}
