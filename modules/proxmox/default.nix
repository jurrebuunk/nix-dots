{ config, pkgs, lib, ... }:

let
  cfg = config.custom.proxmox;

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
      curl
      (python3.withPackages (ps: with ps; [
        proxmoxer
        requests
      ]))
    ];
    
    # Create a wrapper script for proxmox-cli
    environment.etc."proxmox-cli-wrapper".source = pkgs.writeShellScript "proxmox-cli" ''
      ${pkgs.python3.withPackages (ps: with ps; [ proxmoxer requests ])}/bin/python3 -m proxmoxer.cli "$@"
    '';
  };
}
