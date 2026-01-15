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

  # Project: Windows Programming
  windows = {
    packages = with pkgs; [
      curl
      jq
      sshpass
      netcat-gnu
      python3Packages.impacket
    ];
    shellHook = ''
      # Start userspace SMB server
      # Using the Tailscale IP for reliability
      LOCAL_IP=$(ip addr show tailscale0 | grep "inet " | awk '{print $2}' | cut -d/ -f1)
      [ -z "$LOCAL_IP" ] && LOCAL_IP="100.104.62.7" # Fallback to provided Tailscale IP

      # Cleanup any existing SMB server instances first
      sudo ${pkgs.procps}/bin/pkill -f "smbserver.py" 2>/dev/null || true

      # Check if we have passwordless sudo access to smbserver
      if ! sudo -n ${pkgs.python3Packages.impacket}/bin/smbserver.py --help >/dev/null 2>&1; then
        echo "⚠️  Passwordless sudo for smbserver.py not working! You may need to enter password."
      fi

      # Use a temporary file to store the PID and logs

      SMB_LOG_FILE=$(mktemp)
      
      # Bind to 0.0.0.0 for compatibility, but client will use Tailscale IP
      # Run directly with sudo to match sudoers exception
      # NOTE: Options MUST come before positional arguments (shareName sharePath)
      sudo ${pkgs.python3Packages.impacket}/bin/smbserver.py -smb2support -username jurre -password 'REDACTED' home /home/jurre > "$SMB_LOG_FILE" 2>&1 &
      SMB_PID=$!
      
      # Watchdog: ensure cleanup even if the shell is force-killed
      (while kill -0 $$ 2>/dev/null; do sleep 2; done; sudo ${pkgs.procps}/bin/kill $SMB_PID 2>/dev/null; rm -f "$SMB_LOG_FILE") &
      
      trap "sudo ${pkgs.procps}/bin/kill $SMB_PID 2>/dev/null; rm -f $SMB_LOG_FILE" EXIT
      
      # Wait for SMB server to initialize and check for failure
      sleep 3
      if ! sudo ${pkgs.procps}/bin/kill -0 $SMB_PID 2>/dev/null; then
         echo "❌ SMB server failed to start:"
         cat "$SMB_LOG_FILE"
         rm "$SMB_LOG_FILE"
         exit 1
      fi

      WIN_HOST="winsrv1.lan.buunk.org"
      WIN_USER="Administrator"
      WIN_PASS="REDACTED"
      PVE_HOST="192.168.1.13:8006"
      PVE_USER="root@pam"
      PVE_PASS="REDACTED"
      VMID="107"

      check_win() {
        ping -c 1 -W 1 $WIN_HOST >/dev/null 2>&1
      }

      if ! check_win; then
        # Get Ticket
        TICKET_DATA=$(curl -s -k --max-time 5 -d "username=$PVE_USER&password=$PVE_PASS" "https://$PVE_HOST/api2/json/access/ticket")
        TICKET=$(echo "$TICKET_DATA" | jq -r '.data.ticket // empty')
        CSRF=$(echo "$TICKET_DATA" | jq -r '.data.CSRFPreventionToken // empty')

        if [ -z "$TICKET" ]; then
          echo -e "\n❌ Proxmox Auth Failed"
        else
          # Find Node
          NODE=$(curl -s -k --max-time 5 -b "PVEAuthCookie=$TICKET" "https://$PVE_HOST/api2/json/cluster/resources" | jq -r ".data[] | select(.vmid == $VMID) | .node")
          
          # Send Start Command
          curl -s -k -X POST --max-time 5 -b "PVEAuthCookie=$TICKET" -H "CSRFPreventionToken: $CSRF" "https://$PVE_HOST/api2/json/nodes/$NODE/qemu/$VMID/status/start" > /dev/null
          
          # Fast Dot Animation while waiting for Ping
          i=0
          while ! check_win; do
            case $((i % 3)) in
              0) dots=".  " ;;
              1) dots=".. " ;;
              2) dots="..." ;;
            esac
            printf "\r🚀 Starting %s %s" "$WIN_HOST" "$dots"
            sleep 0.2
            ((i++))
          done
          printf "\r🚀 Starting %s ... ✅\n" "$WIN_HOST"
          sleep 2
        fi
      fi
      # Path translation
      REL_PATH=$(realpath --relative-to="$HOME" "$PWD")
      if [ "$REL_PATH" == "." ]; then
        SYNC_PATH="\\\\$LOCAL_IP\\home"
      else
        WIN_REL_PATH=$(echo "$REL_PATH" | tr '/' '\\')
        SYNC_PATH="\\\\$LOCAL_IP\\home\\$WIN_REL_PATH"
      fi
      
      # Use net use with credentials. Correct order: net use \\share password /user:username
      WIN_CMD="net use \\\\$LOCAL_IP\\home \"REDACTED\" /user:jurre /persistent:no & (pushd $SYNC_PATH 2>nul || echo ⚠️ Sync path failed: $SYNC_PATH) & cmd /k"

      sshpass -p "$WIN_PASS" ssh -t -o StrictHostKeyChecking=no -o ConnectTimeout=10 -o LogLevel=ERROR "$WIN_USER@$WIN_HOST" "$WIN_CMD"
      exit
    '';
  };
}
