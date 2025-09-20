Nix tooling helper (WSL-friendly)
=================================

This directory keeps a lightweight toolchain for maintaining Nix-based projects on Windows + WSL. It pairs with the shared automation scripts that now live in `~/Documents/dev/shared/scripts/`.

What is included
----------------
- `flake.nix` / `flake.lock`: dev shell with alejandra, nixfmt, statix, deadnix, treefmt, nil, git, just.
- `justfile`: simple `fmt`, `lint`, `fix`, and optional `pre-commit` recipes that do not rely on repo-local shell scripts.
- `install-standalone.sh`: downloads standalone binaries for alejandra/statix/deadnix/treefmt into `tools/bin` when Nix is unavailable.
- `snapshot.sh`: helper to capture current flake inputs.
- `wsl/`: bootstrap scripts + first-run notes for Debian WSL.
- `logs/`: scratch area for tooling output (safe to delete).

Usage
-----
1. `nix develop` inside `tools/` (or `direnv allow` if you wire it up) to enter the dev shell.
2. Run `just fmt` / `just lint` / `just fix` for common maintenance.
3. Optionally `just pre-commit` to execute local hooks.
4. For cross-repo cleanup/audit scripts use the shared copies under `~/Documents/dev/shared/scripts/`.

Notes
-----
- The dev shell expects the repo-level `treefmt.toml` and related config that already live at the root of `nixos-config`.
- Standalone installs are idempotent; re-run when upstream releases change.
- Keep this directory under source control so every machine inherits the same toolchain.
