---
name: nixos-agent-tooling
description: Use Nix/NixOS to the fullest during agent tasks: run missing tools with ephemeral nix shells, inspect packages, use flakes, run nix develop/nix run, and make persistent Home Manager/NixOS/project changes only when requested. Use whenever a needed command/package is not installed or when working on NixOS configuration.
compatibility: NixOS or Linux with Nix flakes enabled.
---

# NixOS Agent Tooling

Use this skill whenever an agent task can benefit from Nix/NixOS, especially when a command/tool is missing, a package is needed temporarily, a flake can provide a runnable app, or the user asks for NixOS/Home Manager/project environment changes. Prefer ephemeral Nix usage for task runs and persistent Nix configuration only when the user asks for it.

## Core rule

Do **not** install tools globally just to complete a task. Use Nix:

- One-off command with temporary packages: `nix shell nixpkgs#pkg -c command`
- Legacy/simple one-off command: `nix-shell -p pkg --run 'command'`
- Project development shell: `nix develop`
- Specific flake shell: `nix develop .#name`
- Run flake apps/packages: `nix run nixpkgs#pkg -- args`

## Quick package usage

When a command is missing, find the package and run it ephemerally:

```bash
command -v rg || nix shell nixpkgs#ripgrep -c rg --version
nix shell nixpkgs#jq -c jq --version
nix shell nixpkgs#nodejs nixpkgs#pnpm -c pnpm --version
nix-shell -p ffmpeg --run 'ffmpeg -version'
```

For multiple commands, enter a short shell script through `bash -lc`:

```bash
nix shell nixpkgs#python3 nixpkgs#ruff nixpkgs#mypy -c bash -lc 'python --version && ruff check . && mypy .'
```

## Search for packages

Use these in order:

```bash
nix search nixpkgs package-name
nix eval nixpkgs#package-name.version --raw
```

If `nix-index`/`nix-locate` is available:

```bash
nix-locate bin/tool-name
```

## Creating a project dev environment

Only when the user asks to create a persistent dev environment, prefer adding a `flake.nix` to that project. Ask before overwriting an existing flake.

Minimal pattern:

```nix
{
  description = "Project development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          git
          jq
        ];

        shellHook = ''
          echo "Development shell loaded"
        '';
      };
    };
}
```

Then test:

```bash
nix flake check
nix develop -c bash -lc 'command -v jq && jq --version'
```

## Common package sets for persistent dev shells

Python:

```nix
packages = with pkgs; [
  python3
  python3Packages.pip
  python3Packages.virtualenv
  ruff
  mypy
];
```

Node/JS:

```nix
packages = with pkgs; [
  nodejs
  pnpm
  yarn
];
```

PHP/Laravel:

```nix
packages = with pkgs; [
  (php84.withExtensions ({ enabled, all }: enabled ++ [
    all.mbstring all.bcmath all.curl all.sqlite3 all.dom all.fileinfo
  ]))
  php84Packages.composer
  nodejs
  pnpm
  mariadb-connector-c
];
```

Rust:

```nix
packages = with pkgs; [
  rustc
  cargo
  rustfmt
  clippy
  pkg-config
  openssl
];
```

Go:

```nix
packages = with pkgs; [
  go
  gopls
  gotools
];
```

C/C++:

```nix
packages = with pkgs; [
  gcc
  gnumake
  cmake
  pkg-config
];
```

## direnv integration

If the user wants the shell to load automatically, create `.envrc`:

```bash
use flake
```

Then run:

```bash
direnv allow
```

Only do this when the user wants automatic environment loading.

## Modifying this NixOS repo

For this repo:

- Keep reusable development environment definitions in Nix modules or flake outputs when the user asks for persistent project environments.
- Prefer adding or updating `devShells` in `flake.nix` for flake-based projects.
- Validate with `nix flake check` or targeted `nix develop .#name -c <command>`.

## Home Manager / NixOS changes

When changing user applications or dotfiles, prefer Home Manager modules under `/home/jurre/nixos/home/`.

When changing system services/packages, prefer NixOS modules under `/home/jurre/nixos/modules/` or host config under `/home/jurre/nixos/hosts/nixos-usb/`.

Validate before suggesting activation:

```bash
cd /home/jurre/nixos
nix flake check
sudo nixos-rebuild dry-run --flake .#nixos-usb
```

Activation command:

```bash
sudo nixos-rebuild switch --flake /home/jurre/nixos#nixos-usb
```

## Safety and cleanup

- Prefer ephemeral `nix shell` for agent task runs.
- Do not add packages globally unless the user asks for persistent installation.
- Do not run `nix-collect-garbage` unless asked.
- Do not overwrite existing `flake.nix`, `shell.nix`, `.envrc`, or project configs without checking first.
- Avoid adding secrets to Nix files or flakes.
