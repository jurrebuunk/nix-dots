{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
    in
    {
      nixosConfigurations = {
        nixos-usb = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
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
          ];
        };
      };
    };
}
