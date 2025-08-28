Nix + local tooling template (WSL‑friendly)

What you get
- Nix dev shell exposing: alejandra, nixfmt, statix, deadnix, treefmt, nil (Nix LSP)
- treefmt.toml configured for Nix formatting
- pre-commit hooks to format and lint locally (no CI required)
- justfile with common tasks (fmt, lint, fix)
- deadnix-fix.sh wrapper that auto-detects the proper flag (fix/remove) for your deadnix version
- Optional AI fixer script placeholder (off by default)

Prerequisites
- WSL with Nix installed (https://nixos.org/download) or Nix on your Linux/macOS host.
- Optional: Python + pip for pre-commit, or run hooks via justfile only.

Quick start
1) Enter the dev shell (flakes):
   nix develop
   # or without flakes: nix-shell -p alejandra nixfmt statix deadnix treefmt nil

2) Copy the config into a repo:
   # from this folder
   cp treefmt.toml pre-commit-config.yaml justfile scripts/ai-fix.sh /path/to/repo/

3) Optional: enable pre-commit in that repo:
   cd /path/to/repo
   pip install --user pre-commit  # or python -m pip install --user pre-commit
   pre-commit install

4) Run locally:
  # Using just (preferred)
  just fmt     # run formatters
  just lint    # run statix, deadnix checks
  just fix     # run statix fix, deadnix (auto-detected), then treefmt

Batch run across repos (optional)
- From this folder (in `nix develop`):
  bash scripts/run-all.sh ../bmad-method ../bookmark-cleaner ../docs ../dotfiles ../nixos-config

VS Code tips
- Install: Nix IDE (nil or nixd), Treefmt extension optional.
- Settings: enable format on save for Nix files and use alejandra or nixfmt.

Notes
- All tools run locally — no GitHub Actions cost.
- Keep these tools; they improve dev quality. Removing them won’t change cost since CI is disabled already.
