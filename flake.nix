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

  outputs = inputs@{ self, nixpkgs, home-manager, winapps, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
    in
    {
      nixosConfigurations = {
        nixos-usb = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/nixos-usb/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jurre = import ./home/default.nix;
            }
            # WinApps integratie
            ({ pkgs, ... }: let
              winpkgs = winapps.packages.${pkgs.system};
            in
            {
              environment.systemPackages = [
                winpkgs.winapps
                winpkgs.winapps-launcher
              ];
            })
          ];
        };
      };
    };
}
