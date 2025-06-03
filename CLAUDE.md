# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Nix-based dotfiles repository using Home Manager and Nix Flakes for declarative system configuration management. The configuration supports multiple users (kaito, kaitosawada, ubuntu) and systems (x86_64-linux, aarch64-darwin).

## Essential Commands

### Configuration Management
```bash
# Reload configuration (alias: reload)
export NIXPKGS_ALLOW_UNFREE=1 && home-manager switch --flake "$(ghq root)/github.com/kaitosawada/dotfiles#${username}-${system}" --impure && exec $SHELL -l && mise i

# Format Nix files
nixfmt-rfc-style <file.nix>

# Update flake inputs
nix flake update

# Check configuration without applying
home-manager build --flake ".#$(whoami)-$(uname -m)-$(uname | tr '[:upper:]' '[:lower:]')"
```

### Development Commands
```bash
# No specific test or lint commands for Nix files
# Configuration validation happens during home-manager switch/build
```

## Architecture

### Configuration Structure
- **flake.nix**: Entry point defining home configurations for different users/systems
- **home.nix**: Base home configuration importing all program modules
- **programs/**: Modular program configurations
  - **nixvim/**: Complete Neovim configuration in Nix
    - Plugin configurations in `plugins/`
    - Lua scripts in `lua/`
    - Keymappings and theme separated
  - Individual program configs (zsh, starship, wezterm, zellij, etc.)

### Key Design Patterns
1. **Modular Configuration**: Each program has its own `.nix` file in `programs/`
2. **Cross-Platform Support**: Configurations work on both Linux and macOS through system-specific flake outputs
3. **Shell Integration**: Custom scripts loaded via `initContent` in shell configs
4. **Tool Management**: Uses `mise` for runtime versions (Node.js, Python) and global npm packages

### Important Context
- Shell aliases defined in `home.nix` (reload, n, lg, t, g, gr)
- Project switching handled by custom `switch-project.sh` script (alias: g)
- Git repositories organized with `ghq` under `~/ghq/`
- Terminal multiplexer integration with zellij (preferred) or tmux
- Japanese input support in Neovim via skkeleton plugin