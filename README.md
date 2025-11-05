# ❄️ nix-dots

Personal NixOS / Home Manager configuration using flakes

## Overview

This repository contains my personal setup: a flake-based configuration for both system-level (NixOS) and user-level (Home Manager) settings.

## Structure

| Path         | Content                              |
| ------------ | ------------------------------------ |
| `hosts/`     | Host-specific NixOS configuration    |
| `home/`      | Home Manager configuration for users |
| `modules/`   | Modules shared across hosts/users    |
| `themes/`    | Themes and visual customizations     |
| `flake.nix`  | Flake definition                     |
| `flake.lock` | Locks dependencies                   |

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

## Purpose

* Single source of truth for all system and user configurations
* Reusable modules to quickly set up new systems
* Clean, declarative configuration via flakes

## ℹNotes

* This is a **personal configuration**: modifications are needed for your own use
* Some modules or settings may be hardware- or machine-dependent
* Use at your own risk — back up your system before applying changes

## Contributions & Ideas

While this is my personal setup, suggestions or discussions are welcome! Feel free to open an issue or pull request.