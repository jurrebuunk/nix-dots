{ config, pkgs, lib, ... }:

let
  cfg = config.custom.proxmox;
  
  proxmox-cli = pkgs.writeShellScriptBin "proxmox" ''
    #!/usr/bin/env bash
    
    set -e
    
    # Configuration
    PROXMOX_HOST="${cfg.host}"
    PROXMOX_USER="${cfg.user}"
    PROXMOX_TOKEN_ID="${cfg.tokenId}"
    PROXMOX_TOKEN_SECRET="${cfg.tokenSecret}"
    
    # Verify credentials are set
    if [[ -z "$PROXMOX_TOKEN_ID" ]] || [[ -z "$PROXMOX_TOKEN_SECRET" ]]; then
      echo "Error: Proxmox token credentials not configured" >&2
      exit 1
    fi
    
    if [[ -z "$PROXMOX_USER" ]]; then
      echo "Error: Proxmox user not configured" >&2
      exit 1
    fi
    
    # Function to make API calls
    proxmox_api() {
      local method=$1
      local endpoint=$2
      local data=$3
      
      local auth_header="Authorization: PVEAPIToken=$PROXMOX_TOKEN_ID=$PROXMOX_TOKEN_SECRET"
      
      local cmd="curl -s -X $method \
        -H '$auth_header' \
        -H 'Content-Type: application/json' \
        -k https://$PROXMOX_HOST:8006/api2/json$endpoint"
      
      if [[ -n "$data" ]]; then
        cmd="$cmd -d '$data'"
      fi
      
      eval "$cmd"
    }
    
    # Parse command
    case "''${1:-list}" in
      list)
        echo "=== Listing VMs and Containers on $PROXMOX_HOST ==="
        echo ""
        
        # Get all nodes first (in case we need it)
        nodes=$(proxmox_api GET "/nodes" | ${pkgs.jq}/bin/jq -r '.data[].node' 2>/dev/null || echo "")
        
        # List VMs and containers - try to get from all nodes or specific node
        proxmox_api GET "/nodes/$(hostname)/qemu" | ${pkgs.jq}/bin/jq '.' 2>/dev/null && echo "" || true
        proxmox_api GET "/nodes/$(hostname)/lxc" | ${pkgs.jq}/bin/jq '.' 2>/dev/null && echo "" || true
        
        echo "Tip: Set environment variables to connect:"
        echo "  export PROXMOX_USER='user@pam'"
        echo "  export PROXMOX_TOKEN='tokenid=xxxxx-xxxxx, uuid=xxxxx-xxxxx'"
        ;;
      
      vms)
        echo "=== VMs on $PROXMOX_HOST ==="
        proxmox_api GET "/nodes/$(hostname)/qemu" | ${pkgs.jq}/bin/jq '.data[] | {vmid, name, status}' 2>/dev/null || echo "Error querying VMs"
        ;;
      
      containers)
        echo "=== Containers on $PROXMOX_HOST ==="
        proxmox_api GET "/nodes/$(hostname)/lxc" | ${pkgs.jq}/bin/jq '.data[] | {vmid, hostname, status}' 2>/dev/null || echo "Error querying containers"
        ;;
      
      status)
        echo "=== Status on $PROXMOX_HOST ==="
        proxmox_api GET "/nodes/$(hostname)/status" | ${pkgs.jq}/bin/jq '.' 2>/dev/null || echo "Error querying status"
        ;;
      
      help)
        cat << 'EOF'
Proxmox CLI Tool

Usage: proxmox [command]

Commands:
  list          - List all VMs and containers (default)
  vms           - List VMs only
  containers    - List containers only
  status        - Show node status
  help          - Show this help message

Configuration:
  Add to your NixOS configuration:
  
  custom.proxmox = {
    enable = true;
    host = "192.168.1.13";
    user = "root@pam";
    tokenId = "root@pam!mytoken";
    tokenSecret = "29cbc214-8dd7-417e-99d8-24a012e9e563";
  };

Example:
  proxmox list
  proxmox vms
  proxmox containers
EOF
        ;;
      
      *)
        echo "Unknown command: $1" >&2
        echo "Run 'proxmox help' for usage" >&2
        exit 1
        ;;
    esac
  '';

in
{
  options.custom.proxmox = {
    enable = lib.mkEnableOption "Proxmox management tools";
    
    host = lib.mkOption {
      type = lib.types.str;
      default = "192.168.1.13";
      description = "Proxmox hypervisor host IP or hostname";
    };
    
    user = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Proxmox API user (e.g., root@pam)";
    };
    
    tokenId = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Proxmox API token ID (e.g., root@pam!mytoken)";
    };
    
    tokenSecret = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Proxmox API token secret/UUID";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      proxmox-cli
      curl
      jq
    ];
  };
}
