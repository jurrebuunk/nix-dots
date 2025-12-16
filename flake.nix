{
  description = "A very basic flake with sops-nix integration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    sops-nix.url = "github:Mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, winapps, ... }:
  {
    nixosConfigurations = {
      nixos-usb = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit winapps;
          theme = import ./themes/theme.nix;
        };

        modules = [
          ./hosts/nixos-usb/configuration.nix

          # Home Manager module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = {
              theme = import ./themes/theme.nix;
            };

            home-manager.users.jurre = import ./home/default.nix;
          }

          # SOPS-Nix module
          sops-nix.nixosModules.sops {
            age = {
              enable = true;
              keyFiles = [ "/home/jurre/.config/sops/age/keys.txt" ];
            };

            # encrypted secrets bestand
            defaultSopsFile = ./secrets/secrets.yaml;
          }

          # WinApps installatie (zonder config)
          ({ pkgs, ... }:
            let
              winpkgs = winapps.packages.${pkgs.system};
            in {
              environment.systemPackages = [
                winpkgs.winapps
                winpkgs.winapps-launcher
              ];
            }
          )
        ];
      };
    };

    devShells.x86_64-linux =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        envs = import ./modules/development/envs.nix { inherit pkgs; };
      in
      {
        docker = pkgs.mkShell {
          packages = envs.docker.packages;
          shellHook = envs.docker.shellHook;
        };

        python = pkgs.mkShell {
          packages = envs.python.packages;
          shellHook = envs.python.shellHook;
        };

        laravel = pkgs.mkShell {
          packages = envs.laravel.packages;
          shellHook = envs.laravel.shellHook;
        };

        b302growpad = pkgs.mkShell {
          packages = envs.b302growpad.packages;
          shellHook = envs.b302growpad.shellHook;
        };
      };
  };
}
