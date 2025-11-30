# AGENTS.md

This repository is a Nix/Home Manager dotfiles setup using flakes. Use these notes when automating tasks here.

Build/Lint/Test
- Home Manager apply (validates config):
  - export NIXPKGS_ALLOW_UNFREE=1
  - home-manager switch --flake ".#$(whoami)-$(uname -m)-$(uname | tr '[:upper:]' '[:lower:]')" --impure && exec $SHELL -l
- Dry-run check without applying:
  - home-manager build --flake ".#$(whoami)-$(uname -m)-$(uname | tr '[:upper:]' '[:lower:]')"
- Format Nix files:
  - nixfmt-rfc-style <file.nix>
- Update flake inputs:
  - nix flake update
- Repo health script (custom):
  - ./check.sh
- Tests: There is no traditional test suite; validation occurs via home-manager build/switch.

Common dev aliases and scripts
- reload: Runs the full switch (see CLAUDE.md) and re-inits shell plus `mise i`
- scripts/: switch-project.sh (alias g), tmux-session-name.sh, lazygit-neovim-integration.sh

Code style guidelines
- Language: Nix (modules in programs/, nixvim/, flake.nix, home.nix). Follow modular patterns seen in programs/* and nixvim/plugins/*.
- Formatting: Always run nixfmt-rfc-style. Keep attribute sets alphabetized when practical; avoid trailing comments.
- Imports/modules: Prefer small modules in programs/<tool>.nix; aggregate with imports in programs/default.nix and home.nix. Don’t introduce new frameworks without checking flake inputs.
- Types: Use explicit types in options where applicable; prefer booleans/strings/lists over attrset merging magic. Keep options consistent across platforms.
- Naming: kebab-case filenames (e.g., yazi.nix), lowerCamelCase for Nix attributes unless upstream expects another style. Keep module option names consistent with upstream home-manager/nixpkgs.
- Secrets: Never commit tokens/keys. Do not print or log secrets. Use environment variables or external files managed outside the repo.
- Error handling: Validate changes with home-manager build before switch. For failing evaluations, minimize scope by toggling modules via imports. Avoid impure fetches unless necessary; pin with flakes when possible.
- PR hygiene: Run build, then format. Ensure flake.lock updates are intentional and reviewed.

Editor/AI rules
- No Cursor or Copilot rules found in the repo. If added later (e.g., .cursor/rules or .github/copilot-instructions.md), mirror key constraints here.

Notes
- Cross-platform: configs target x86_64-linux and aarch64-darwin; avoid platform-specific paths in shared modules.
- Git layout: Repos under ~/ghq; project switching via scripts/switch-project.sh.
