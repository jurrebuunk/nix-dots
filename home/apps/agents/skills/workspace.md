---
name: workspace
description: Launch a fresh Scroll WM development workspace for a project by detecting the repo type, choosing the typical windows needed to start working, opening them, and verifying they actually appeared. Use when the user asks to open a new workspace for a project.
compatibility: Linux Wayland session with Scroll WM and scrollmsg available.
---

# Development Workspace Launch

Use this skill when the user wants a new project workspace started in Scroll WM.

## Goal

Create a fresh workspace with the typical windows for the project type, then verify all windows launched successfully.

## Detect the repo type

Inspect the project root for common hints:

- `flake.nix`, `shell.nix`, `default.nix` → Nix-based dev environment
- `pyproject.toml`, `requirements.txt`, `manage.py` → Python project
- `package.json` → JS/TS project
- `README.md` and `frontend/`, `src/`, `tests/`, `alembic/` → web app / service project
- `Dockerfile`, `compose.yml`, `docker-compose.yml` → containerized project
- `vite.config.*`, `next.config.*`, `nuxt.config.*`, `svelte.config.*` → frontend app

## Typical windows to open

Choose the minimum useful set:

- **IDE**: VS Code or another editor on the project root
- **Terminal**: shell in the project root, usually `nix-shell`, `nix develop`, or the repo's dev command
- **Browser**: Firefox on the local app/docs page if the project has one
- **Second terminal**: only if tests, logs, or migrations are commonly needed

### Common defaults by repo type

- **Python web/service**: IDE + terminal with `nix-shell`/`nix develop` + Firefox
- **NixOS/Home Manager repo**: IDE + terminal with `nix-shell`/`nix develop` + optional Firefox for docs
- **Frontend app**: IDE + terminal with install/dev command + Firefox
- **Library/CLI project**: IDE + terminal; browser only if docs/demo is useful

## Launch strategy

1. Move to a fresh workspace.
2. Launch the selected windows in that workspace.
3. Start shells with the repo's expected command if known.
4. Open Firefox to the project's local URL or main page.
5. Verify all windows appeared.

Prefer `scrollmsg exec` so the compositor launches apps in the active workspace.

## Verification

After launching, inspect the tree and confirm the expected apps exist:

```bash
sleep 1
scrollmsg -t get_tree | jq '[.. | objects | select(.app_id? == "firefox" or .app_id? == "Code" or .app_id? == "Alacritty") | {app_id,name,visible}]'
```

If a required window is missing, launch it again.

## Notes

- Use the project README and shell file to decide the local URL and startup command.
- If the repo has a standard dev server, open Firefox to that local address.
- Do not claim success until the windows are confirmed in the Scroll tree.
