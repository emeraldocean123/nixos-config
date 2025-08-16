# Contributing

This repo uses Nix flakes with local checks to keep code clean and consistent. GitHub Actions is not used to avoid costs.

For detailed contributing guidelines, see [NIXOS-FLAKE-CONTRIBUTING.md](https://github.com/emeraldocean123/docs/blob/main/NIXOS-FLAKE-CONTRIBUTING.md) in the docs repository.

## Formatting & linting

- Formatter: `nix fmt` (nixpkgs-fmt)
- Dev shell (provides nixpkgs-fmt and statix):
  - `nix develop`
  - `nixpkgs-fmt .`
  - `statix check`
  - Optional: `statix fix` (review changes before committing)

Run locally before pushing:
`nix fmt`, `nix run nixpkgs#statix -- check`, and optionally `nix flake check`.

## Local Git hooks (optional)

This repo includes a pre-commit hook under `.githooks/pre-commit`.

Enable it in this clone:

```
git config core.hooksPath .githooks
```

Note: On Windows, Git will run the hook via your shell if available; in WSL or Linux it runs as a Bash script. If Nix is not installed locally, the hook will skip.

## Commit messages

- Use short, present-tense subject lines (max ~72 chars)
- Scope prefix is helpful (e.g., `msi/services: drop docker`, `readme: note formatter`)

## Nix header comment convention

Each Nix file starts with a short, human-friendly header:

```
# <area> <purpose> (<hardware|year|notes if helpful>)
# Optional one-liner with key details.
```

Examples:
- `# MSI GE75 Raider services (gaming/performance oriented)`
- `# HP dv9500 LXQt desktop (LightDM + xautolock workaround)`

Avoid path-style headers like `# /modules/foo.nix`.

## PR checklist

- Run `nix fmt` and ensure no diffs
- Run `statix check` and address issues
- Keep host-specific settings in `modules/<host>/...`
- Avoid duplicate Home Manager file entries if `modules/shared/dotfiles.nix` already links them
- For the MSI host, keep NVIDIA-specific settings in `modules/msi-.../nvidia.nix`
