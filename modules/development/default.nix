{ ... }:

{
  imports = [
    ./docker.nix
    # ./python.nix  # Commented out to keep OS clean, use 'nix develop .#python'
    # ./laravel.nix # Commented out to keep OS clean, use 'nix develop .#laravel'
  ];
}
