{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    scroll-flake = {
      url = "github:Diax170/scroll-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jurre-theme = {
      url = "git+https://github.com/jurrebuunk/jurre-theme.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          envs = import ./modules/development/envs.nix { inherit pkgs; };
        in
        {
          python = pkgs.mkShell envs.python;
          docker = pkgs.mkShell envs.docker;
          net = pkgs.mkShell envs.net;
          growpad = pkgs.mkShell envs.growpad;
          meldcoach = pkgs.mkShell envs.meldcoach;
        }
      );

      nixosConfigurations = {
        nixos-usb = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            theme = inputs.jurre-theme.lib.themes.default;
          };
          modules = [
            ./hosts/nixos-usb/configuration.nix
            inputs.agenix.nixosModules.default
            inputs.nix-index-database.nixosModules.default

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = {
                inherit inputs;
                theme = inputs.jurre-theme.lib.themes.default;
              };
              home-manager.users.jurre = import ./home/default.nix;
            }
          ];
        };
      };
    };
}
