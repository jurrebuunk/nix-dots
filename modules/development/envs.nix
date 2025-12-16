{ pkgs }:

rec {
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

  b302growpad = {
    packages = laravel.packages ++ docker.packages;
    shellHook = ''
      ${laravel.shellHook}
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
        if ! screen -list | grep -q "\.b302growpad-be"; then
          echo "🚀 Starting backend screen..."
          screen -dmS b302growpad-be bash -c "cd $GROWPAD_BACKEND_PATH && docker compose up -d && php artisan serve"
        else
          echo "✅ Backend screen already running."
        fi

        # Frontend
        if ! screen -list | grep -q "\.b302growpad-fe"; then
          echo "🚀 Starting frontend screen..."
          screen -dmS b302growpad-fe bash -c "cd $GROWPAD_FRONTEND_PATH && npm run dev"
        else
          echo "✅ Frontend screen already running."
        fi
      }

      growpad-stop() {
        screen -S b302growpad-be -X quit 2>/dev/null || echo "Backend not running."
        echo "❌ Backend screen stopped."
        screen -S b302growpad-fe -X quit 2>/dev/null || echo "Frontend not running."
        echo "❌ Frontend screen stopped."
      }

      growpad-restart() {
        growpad-stop
        sleep 1
        growpad-start
      }

      growpad-status() {
        if screen -list | grep -q "\.b302growpad-be"; then
            echo "Backend (Laravel):   Running (Screen: b302growpad-be)"
        else
            echo "Backend (Laravel):   Stopped"
        fi

        if screen -list | grep -q "\.b302growpad-fe"; then
            echo "Frontend (Vite):     Running (Screen: b302growpad-fe)"
        else
            echo "Frontend (Vite):     Stopped"
        fi
      }

      # Start services on shell entry
      growpad-start
      echo "Commands available: growpad-start, growpad-stop, growpad-restart, growpad-status"
    '';
  };
}
