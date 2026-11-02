# ❄️ nix-dots

Personal NixOS / Home Manager configuration using flakes

## Overview

This repository contains my personal setup: a flake-based configuration for both system-level (NixOS) and user-level (Home Manager) settings.

It also defines Nixy's operating style for this laptop: a calm, Nix-native assistant that prefers declarative changes, terminal-first workflows, and reproducible fixes.

## Structure

| Path         | Content                               |
| ------------ | ------------------------------------- |
| `hosts/`     | Host-specific NixOS configuration     |
| `home/`      | Home Manager configuration for users  |
| `modules/`   | Shared modules (system, dev environments) |
| `themes/`    | Themes and visual customizations      |
| `flake.nix`  | Flake definition                      |
| `flake.lock` | Locks dependencies                    |
| `NIXY.md`    | Assistant persona and working style   |

## Hosts

| Hostname / flake target | Configuration | Rebuild |
| --- | --- | --- |
| `surface3` | `hosts/surface3/` | `sudo nixos-rebuild switch --flake .#surface3` |
| `probookg8` | `hosts/probookg8/` | `sudo nixos-rebuild switch --flake .#probookg8` |

Run rebuild commands from this repository on the corresponding machine.

### Host-local core modules

Each host imports its own `hosts/<hostname>/core/` directory. These are independent system configurations, not a shared baseline:

- `hosts/probookg8/core/`: boot/kernel, Intel hardware, hibernation, networking, audio workarounds, Bluetooth, users, applications, services, Nix settings, overlays, and Python tools.
- `hosts/surface3/core/`: boot/Surface kernel, hardware, power and sensor workarounds, networking, audio, Bluetooth, users/SSH, applications, services, and Nix settings.

`configuration.nix` selects the host's hardware, core, shared desktop, optional development modules, and original state version. Blueman and pavucontrol belong only to the ProBook's package configuration. Tailscale and its routing/resume hooks have been removed.

### Desktop modules

Desktop environments are shared, opt-in NixOS modules:

- `modules/desktop/niri/`: Niri, greetd, portals, locking, OSD, and the patched compositor; imported by `probookg8`.
- `modules/desktop/gnome/`: GNOME, GDM, graphics support, and GNOME Tweaks; imported by `surface3`.

Hardware workarounds and power policies stay in `hosts/`. Home Manager desktop and monitor settings are unchanged.

## Usage

1. Clone the repository:

   ```bash
   git clone https://github.com/jurrebuunk/nix-dots.git
   ```
2. Go into the directory and update the flake:

   ```bash
   cd nix-dots
   nix flake update
   ```
3. For a NixOS host, edit `hosts/<hostname>/configuration.nix` and run:

   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```
4. For a user with Home Manager:

   ```bash
   home-manager switch --flake .#<username>
   ```

## Development Environments

This configuration uses a modular approach for development environments to keep the base system clean.

- **Structure**: Development tools are defined in `modules/development/`.
  - `default.nix`: Imports system-wide dev tools (like Docker).
  - `envs.nix`: Defines isolated environments (Python, Laravel, project-specific).
  - `docker.nix`: System-level Docker configuration.

- **Usage**: Use `nix develop` to enter specific shells defined in `flake.nix` (which pull from `envs.nix`).

  ```bash
  # Enter the Python environment
  nix develop .#python

  # Enter the Laravel environment
  nix develop .#laravel

  # Enter the Growpad project environment
  nix develop .#b302growpad
  ```

- **Project Shells**: Project-specific shells (like `b302growpad`) come with automated service management.
  - **Auto-start**: Services (Docker containers, dev servers) start automatically in background `screen` sessions upon entry.
  - **Commands**:
    - `*-start`: Start services (e.g. `growpad-start`).
    - `*-stop`: Stop services.
    - `*-restart`: Restart services.
    - `*-status`: Check if services are running.

## Secrets with agenix

This repo includes `agenix` for encrypted secrets:

- Recipient definitions live in `secrets/secrets.nix`
- Encrypted secret files live in `secrets/*.age`
- NixOS wiring is enabled in `flake.nix` and `hosts/probookg8/configuration.nix`

Common commands:

```bash
# Edit or create a secret (uses secrets/secrets.nix)
nix run github:ryantm/agenix -- -e secrets/proxmox-token-secret.age

# Rebuild and activate
sudo nixos-rebuild switch --flake .#probookg8
```

## Purpose

- Single source of truth for all system and user configurations
- Reusable modules to quickly set up new systems
- Clean, declarative configuration via flakes

## Notes

- This is a **personal configuration**: modifications are needed for your own use
- Some modules or settings may be hardware- or machine-dependent
- Use at your own risk — back up your system before applying changes

## Contributions & Ideas

While this is my personal setup, suggestions or discussions are welcome! Feel free to open an issue or pull request.
