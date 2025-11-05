{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.url = "github:0xc000022070/zen-browser-flake/beta";

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, zen-browser, winapps }: {
    nixosConfigurations = {
      nixos-usb = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nixos-usb/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit zen-browser; };
            home-manager.users.jurre = import ./home/default.nix;
          }

          # WinApps integratie
          ({ pkgs, ... }: {
            environment.systemPackages = [
              winapps.packages.${pkgs.system}.winapps
              winapps.packages.${pkgs.system}.winapps-launcher
            ];
          })
        ];
      };
    };
  };
}
