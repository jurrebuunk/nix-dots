{ pkgs, ... }:

let
  # Python interpreter
  pythonBase = with pkgs; [
    python3
  ];

  # Python packages
  pythonPackages = with pkgs; [
    python3Packages.numpy
    python3Packages.notebook
    python3Packages.jupyter
    python3Packages.pip
  ];

  pythonSystemPackages = pythonBase ++ pythonPackages;
in
{
  environment.systemPackages = pythonSystemPackages;

  # Fix for python cert files
  environment.etc.certfile = {
    source = "/etc/ssl/certs/ca-bundle.crt";
    target = "ssl/cert.pem";
  };
}
