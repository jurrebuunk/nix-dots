{ pkgs, ... }:

{
  boot.kernelPackages =
    pkgs.linuxPackagesFor pkgs.linuxKernel.kernels.linux_7_0;
}