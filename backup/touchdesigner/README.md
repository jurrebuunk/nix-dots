# TouchDesigner configuration backup

Snapshots taken before removing TouchDesigner from the active configuration:

- `flake.nix`: local input, NixOS modules, OBS virtual camera settings, and Home Manager module wiring.
- `flake.lock`: pinned inputs, including TouchDesigner and its tdlinux source.
- `home/default.nix`: TouchDesigner enablement and td-hueControl plugin settings.

These files are archival only and are not imported by the active flake.
Do not restore the whole snapshots over newer configuration; copy the relevant sections instead.
The original `/home/jurre/touchdesigner-nix` source directory was missing, so its contents could not be backed up.
Removing the module also removes its OBS virtual camera integration; standalone OBS remains configured.
