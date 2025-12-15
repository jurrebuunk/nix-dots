{
  description = "A basic development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          # Add your project specific packages here
          # python3
          # nodejs
          # docker-compose
        ];

        shellHook = ''
          echo "Environment Loaded"
        '';
      };
    };
}
