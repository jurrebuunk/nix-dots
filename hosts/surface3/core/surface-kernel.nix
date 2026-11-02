{ lib, pkgs, linux-surface, ... }:

let
  # Official linux-surface release (2026-10-27), with its matching upstream
  # patch/config directory. Keep these in sync when upgrading the kernel.
  # No locally authored kernel patches; linux-surface is pinned by flake.lock.
  kernelVersion = "7.2.13";
  patchSeries = "7.2";
  patchDir = linux-surface + "/patches/${patchSeries}";

  # Translate upstream's standard .config fragment to NixOS kernel settings.
  configEntries = lib.concatMap (line:
    let
      enabled = builtins.match "CONFIG_([^=]+)=([ymn])" line;
      disabled = builtins.match "# CONFIG_([^ ]+) is not set" line;
      tristates = { y = lib.kernel.yes; m = lib.kernel.module; n = lib.kernel.no; };
    in
      if enabled != null then [
        (lib.nameValuePair (builtins.elemAt enabled 0)
          tristates.${builtins.elemAt enabled 1})
      ] else if disabled != null then [
        (lib.nameValuePair (builtins.elemAt disabled 0) lib.kernel.no)
      ] else [ ]
  ) (lib.splitString "\n" (builtins.readFile
    (linux-surface + "/configs/surface-${patchSeries}.config")));

  surfaceKernel = pkgs.buildLinux {
    pname = "linux-surface";
    version = kernelVersion;
    modDirVersion = "${kernelVersion}-surface";
    src = pkgs.fetchurl {
      url = "https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-${kernelVersion}.tar.xz";
      hash = "sha256-COewxPLdGXH5ctonS15YmpiYk5CsVqzXoaWvkiNj6mw=";
    };
    structuredExtraConfig = (builtins.listToAttrs configEntries) // {
      LOCALVERSION = lib.kernel.freeform "-surface";
      LOCALVERSION_AUTO = lib.kernel.no;
    };
    # Upstream's cross-device fragment can contain symbols absent on x86 or
    # selected automatically by newer kernels. Required driver settings are
    # checked explicitly before deployment.
    ignoreConfigErrors = true;
    kernelPatches = map (name: {
      name = "linux-surface/${name}";
      patch = patchDir + "/${name}";
    }) (builtins.filter (lib.hasSuffix ".patch")
      (builtins.attrNames (builtins.readDir patchDir)));
    extraMeta = {
      description = "Linux with the maintained linux-surface patches";
      homepage = "https://github.com/linux-surface/linux-surface";
    };
  };
in
{
  assertions = [
    {
      assertion = lib.hasInfix ''KERNEL_VERSION="${kernelVersion}"''
        (builtins.readFile (linux-surface + "/pkg/debian/kernel/version.conf"));
      message = "linux-surface changed its release: update kernelVersion, patchSeries, and the source hash in surface.nix together with flake.lock.";
    }
  ];

  boot.kernelPackages = pkgs.linuxPackagesFor surfaceKernel;
  # This SL3 advertises s2idle, not S3/deep, and achieved S0ix on stock Linux.
  boot.kernelParams = [
    "mem_sleep_default=s2idle"
    # The USB-C Ethernet dongle (Realtek 0bda:8152, the "Wired connection"
    # profile's MAC 00:E0:4C:36:59:C3) binds and comes up, then dies in an
    # unrecoverable Tx-timeout/USB-reset loop within ~40s under this kernel.
    # The same hardware is fine on the stock 6.18.59 kernel, so this isn't a
    # dongle/cable fault. The kernel already ships this exact NO_LPM quirk
    # built-in for sibling RTL8153 adapters (USB3 link-power-management
    # breaks these chips); apply it explicitly for this PID too.
    "usbcore.quirks=0bda:8152:k"
  ];
  services.iptsd.enable = true;
  hardware.sensor.iio.enable = true;
  system.nixos.tags = [ "surface" ];

  # A continuously available, unpatched boot option, independent of how many
  # old generations are retained. Ambient-light/audio fixes still apply here.
  specialisation.stock-kernel.configuration = {
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
    services.iptsd.enable = lib.mkForce false;
    system.nixos.tags = lib.mkForce [ "stock-kernel" ];
  };
}
