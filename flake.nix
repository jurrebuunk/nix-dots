{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, winapps, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
    in
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

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                theme = import ./themes/theme.nix;
              };
              home-manager.users.jurre = import ./home/default.nix;
            }

            # WinApps integratie
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

      devShells.x86_64-linux = let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        envs = import ./modules/development/envs.nix { inherit pkgs; };
      in {

        docker = pkgs.mkShell {
          packages = envs.docker.packages;
          shellHook = envs.docker.shellHook;
        };

        net = pkgs.mkShell {
          packages = envs.net.packages;
          shellHook = envs.net.shellHook;
        };

        python = pkgs.mkShell {
          packages = envs.python.packages;
          shellHook = envs.python.shellHook;
        };

        growpad = pkgs.mkShell {
          packages = envs.growpad.packages;
          shellHook = envs.growpad.shellHook;
        };

        meldcoach = pkgs.mkShell {
          packages = envs.meldcoach.packages;
          shellHook = envs.meldcoach.shellHook;
        };
      };
    };
}
