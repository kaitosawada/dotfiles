# AGENTS.md

Nix/Home Manager dotfiles using flakes. See also `CLAUDE.md` for additional conventions.

## Commands

```sh
# Build (validates config, no side effects) — always run after editing .nix files
make build

# Apply configuration
NIXPKGS_ALLOW_UNFREE=1 make switch

# Format all Nix files (also: nix fmt or treefmt)
make fmt

# Update flake inputs
make update

# Repo health check (scans all ghq repos for dirty state)
make check
```

## Mandatory workflow after editing .nix files

1. `make fmt`
2. `make build` (validates the config compiles)

Do NOT run `home-manager switch` — the user handles that manually.

## Architecture

- `flake.nix` — flake entry, declares inputs (home-manager, nixvim, sops-nix, nix-claude-code, etc.) and generates homeManagerConfigurations for `kaito`, `kaitosawada`, `ubuntu` across `x86_64-linux`, `aarch64-darwin`, `x86_64-darwin`
- `home.nix` — top-level home config: imports `programs/`, `claude.nix`, `skills/`; defines system packages, shell aliases, session variables
- `programs/default.nix` — aggregates per-tool modules (each in `programs/<tool>.nix`); also imports nixvim config
- `programs/nixvim/` — Neovim configuration via nixvim
- `claude.nix` — generates `~/.claude/settings.json` via sops template (Claude Code sandbox, permissions, env vars)
- `secrets/` — SOPS-encrypted secrets, decrypted at build time
- `scripts/` — utility scripts (switch-project.sh, tmux-session-name.sh, etc.)
- `lib/` — Nix helper functions (e.g., `skkeleton.nix` for SKK dictionary)

## Platform conventions

- Guard Darwin/Linux differences with `lib.mkIf isDarwin` where `isDarwin` is defined in `home.nix`
- Avoid platform-specific paths in shared modules; use `system`/`homeDirectory` from `extraSpecialArgs`

## Secrets

- Managed via sops-nix, encrypted with age key stored in Bitwarden
- Secrets file: `secrets/home.yaml`
- `.sops.yaml` defines the age key and path rules
- `mise.local.toml` is gitignored — contains environment secrets, never commit it

## Code style

- Format with `nixfmt` (rfc-style), configured via `treefmt.nix`
- Module files in `programs/` use kebab-case (e.g., `lazygit.nix`, `gh-dash.nix`)
- Alphabetize attribute sets when practical
- No trailing comments
- Keep modules small and focused; aggregate via `imports` in `programs/default.nix`

## Key conventions from CLAUDE.md

- Cross-platform targets: `x86_64-linux`, `aarch64-darwin`. Avoid platform-specific paths in shared modules.
- Git repos live under `~/ghq`; project switching via `scripts/switch-project.sh`
- Never commit tokens or keys
- Run `nixfmt` on changed Nix files after edits
