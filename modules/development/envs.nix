{ pkgs }:

let
  # ---------------------------------------------------------------------------
  # Modular Environment Definitions
  # ---------------------------------------------------------------------------

  python = {
    packages = with pkgs; [
      python315
    ];
    shellHook = ''
      echo "🐍 Python Environment Loaded"
    '';
  };

  php82-env = {
    packages = with pkgs; [
      (php82.withExtensions ({ enabled, all }: enabled ++ [
        all.mbstring
        all.bcmath
        all.curl
        all.sqlite3
        all.dom
        all.fileinfo
      ]))
      php82Packages.composer
      mariadb-connector-c
    ];
    shellHook = ''
      echo "🐘 PHP 8.2 Environment Loaded"
      export PATH=$HOME/.config/composer/vendor/bin:$PATH
    '';
  };

  php84-env = {
    packages = with pkgs; [
      (php84.withExtensions ({ enabled, all }: enabled ++ [
        all.mbstring
        all.bcmath
        all.curl
        all.sqlite3
        all.dom
        all.fileinfo
      ]))
      php84Packages.composer
      mariadb-connector-c
    ];
    shellHook = ''
      echo "🐘 PHP 8.4 Environment Loaded"
      export PATH=$HOME/.config/composer/vendor/bin:$PATH
    '';
  };

  node = {
    packages = with pkgs; [
      nodejs
    ];
    shellHook = ''
      echo "📦 Node/NPM Environment Loaded"
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

  net = {
    packages = with pkgs; [
      nmap
      tcpdump
      mtr
      dnsutils
      wirelesstools
      tshark
    ];
    shellHook = ''
      echo "🌐 Networking Tools Loaded"
    '';
  };

in
{
  # ---------------------------------------------------------------------------
  # Composed Shells
  # ---------------------------------------------------------------------------

  inherit python docker net;

  # Project: Growpad
  growpad = {
    packages = php84-env.packages ++ node.packages ++ docker.packages;
    shellHook = ''
      ${php84-env.shellHook}
      ${node.shellHook}
      ${docker.shellHook}
      
      # Load environment variables
      if [ -f .env ]; then
        set -a
        source .env
        set +a
      fi

      # Set defaults
      : ''${GROWPAD_BACKEND_PATH:=~/repos/2007-doorontwikkeling-growpad-be}
      : ''${GROWPAD_FRONTEND_PATH:=~/repos/2007-doorontwikkeling-growpad-fe}

      growpad-start() {
        # Backend
        if ! screen -list | grep -q "\.growpad-be"; then
          echo "🚀 Starting backend screen..."
          screen -dmS growpad-be bash -c "cd $GROWPAD_BACKEND_PATH && docker compose up -d && php artisan serve"
        else
          echo "✅ Backend screen already running."
        fi

        # Frontend
        if ! screen -list | grep -q "\.growpad-fe"; then
          echo "🚀 Starting frontend screen..."
          screen -dmS growpad-fe bash -c "cd $GROWPAD_FRONTEND_PATH && npm run dev"
        else
          echo "✅ Frontend screen already running."
        fi
      }

      growpad-stop() {
        screen -S growpad-be -X quit 2>/dev/null || echo "Backend not running."
        echo "❌ Backend screen stopped."
        screen -S growpad-fe -X quit 2>/dev/null || echo "Frontend not running."
        echo "❌ Frontend screen stopped."
      }

      growpad-restart() {
        growpad-stop
        sleep 1
        growpad-start
      }

      growpad-status() {
        if screen -list | grep -q "\.growpad-be"; then
            echo "Backend (Laravel):   Running (Screen: growpad-be)"
        else
            echo "Backend (Laravel):   Stopped"
        fi

        if screen -list | grep -q "\.growpad-fe"; then
            echo "Frontend (Vite):     Running (Screen: growpad-fe)"
        else
            echo "Frontend (Vite):     Stopped"
        fi
      }

      # Start services on shell entry
      growpad-start
      echo "Commands available: growpad-start, growpad-stop, growpad-restart, growpad-status"
    '';
  };

  # Project: Meldcoach
  meldcoach = {
    packages = php82-env.packages ++ node.packages ++ docker.packages;
    shellHook = ''
      ${php82-env.shellHook}
      ${node.shellHook}
      ${docker.shellHook}
      echo "🚀 Meldcoach Environment Loaded"
    '';
  };
}
