{
  system,
  username,
  homeDirectory,
  pkgs,
  aipkgs,
  ...
}:
{
  imports = [
    ./programs
    ./claude.nix
  ];

  programs.mise = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    globalConfig = {
      tools = {
        # Node.js
        node = "24";
        "npm:yarn" = "latest";
        "npm:pnpm" = "latest";
        "npm:@anthropic-ai/claude-code" = "latest";
        "npm:@openai/codex" = "latest";
        "npm:@antfu/ni" = "latest";
        "npm:@bitwarden/cli" = "latest";

        # Python
        python = "3.12";
        uv = "latest";
        pipx = "latest";

        # MCP Servers
        "npm:playwright" = "latest";
        "npm:@playwright/mcp" = "latest";
        "pipx:markitdown-mcp" = "latest"; # ffmpeg is required for this
      };
    };
  };

  home = {
    username = username;
    homeDirectory = homeDirectory;
    stateVersion = "24.11";

    packages = with pkgs; [
      wget

      # git
      git
      ghq

      # languages
      deno
      go
      biome

      # nix
      nix-search-cli
      nixfmt-rfc-style

      # tools
      gnumake
      jq
      ripgrep
      sd
      tree-sitter
      imagemagick
      libreoffice-bin
      ffmpeg # for markitdown-mcp
      tree-sitter # for nixvim swift grammar

      # docker
      colima
      docker
      docker-compose
      docker-buildx
      docker-credential-helpers

      # rust
      rustc
      cargo

      # llm
      llama-cpp
      aipkgs.crush
    ];

    sessionVariables = {
      EDITOR = "nvim";
      LANG = "ja_JP.UTF-8";
      NIXPKGS_ALLOW_UNFREE = "1";
      DOCKER_HOST = "unix:///Users/kaitosawada/.colima/default/docker.sock";
    };

    shellAliases = {
      n = "nvim";
      lg = "lazygit";
      load = "exec $SHELL -l";
      reload = ''export NIXPKGS_ALLOW_UNFREE=1 && home-manager switch --flake "$(ghq root)/github.com/kaitosawada/dotfiles#${username}-${system}" --impure && exec $SHELL -l && mise i'';
      upgrade = "mise upgrade && nix flake update && nix store gc";
      t = ''zellij attach "$(basename $(pwd))" --create'';
      o = "cd ~/obsidian/kaitosawada && nvim .";
      todo = "nvim ~/obsidian/kaitosawada/tasks.md";
    };

    file = {
      "Library/LaunchAgents/com.kaitosawada.colima.start.plist" = {
        source = ./scripts/launchd/com.kaitosawada.colima.start.plist;
      };
      "Library/LaunchAgents/com.kaitosawada.llama.server.plist" = {
        source = ./scripts/launchd/com.kaitosawada.llama.server.plist;
      };
    };
  };

  home.activation.enableLaunchAgents = {
    after = [ "writeBoundary" ];
    before = [ ];
    data = ''
      if command -v launchctl >/dev/null 2>&1; then
        launchctl unload -wF "$HOME/Library/LaunchAgents/com.kaitosawada.llama.server.plist" 2>/dev/null || true
        launchctl unload -wF "$HOME/Library/LaunchAgents/com.kaitosawada.colima.start.plist" 2>/dev/null || true
        launchctl load -w "$HOME/Library/LaunchAgents/com.kaitosawada.colima.start.plist" || true
        launchctl load -w "$HOME/Library/LaunchAgents/com.kaitosawada.llama.server.plist" || true
      fi
    '';
  };

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      max-jobs = 8 
      cores = 8
      experimental-features = nix-command flakes
      trusted-users = root kaitosawada kaito ubuntu
    '';
  };
}
