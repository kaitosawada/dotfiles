{
  system,
  username,
  homeDirectory,
  pkgs,
  ...
}:
let
  isDarwin = system == "aarch64-darwin" || system == "x86_64-darwin";
  skkLib = import ./lib/skkeleton.nix { inherit pkgs; };
in
{
  imports = [
    ./programs
    ./claude.nix
  ];

  # claude-codeはnpm -gでインストールされます
  programs.mise = {
    enable = true;
    globalConfig = {
      tools = {
        # Node.js
        node = "24";
        "npm:yarn" = "latest";
        "npm:pnpm" = "latest";
        "npm:@antfu/ni" = "latest";
        "npm:@bitwarden/cli" = "latest";

        # Python
        python = "3.13";
        uv = "latest";
        pipx = "latest";

        # MCP Servers
        # "npm:playwright" = "latest";
        # "npm:@playwright/mcp" = "latest";
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
      imagemagick
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

      # # llm
      # llama-cpp

      # claude
      claude-code
    ];

    sessionVariables = {
      EDITOR = "nvim";
      LANG = "ja_JP.UTF-8";
      NIXPKGS_ALLOW_UNFREE = "1";
      DOCKER_HOST = "unix://$HOME/.colima/default/docker.sock";
    };

    shellAliases = {
      n = ''nvim --listen "/tmp/nvim-$$.pipe"'';
      lg = "lazygit";
      load = "exec $SHELL -l";
      reload = ''export NIXPKGS_ALLOW_UNFREE=1 && home-manager switch --flake "$(ghq root)/github.com/kaitosawada/dotfiles#${username}-${system}" --impure && exec $SHELL -l && mise i'';
      upgrade = "mise upgrade && nix flake update && nix store gc";
      t = ''zellij attach "$(basename $(pwd))" --create'';
      todo = "(cd $HOME/obsidian/kaitosawada && claude)";
      tl = "(cd $HOME/obsidian/kaitosawada && claude -p 'todo list')";
    };

    file =
      {
        "Library/LaunchAgents/com.kaitosawada.colima.start.plist" = {
          source = ./scripts/launchd/com.kaitosawada.colima.start.plist;
        };
        # "Library/LaunchAgents/com.kaitosawada.llama.server.plist" = {
        #   source = ./scripts/launchd/com.kaitosawada.llama.server.plist;
        # };
        ".config/nvim/lua/overseer/template" = {
          source = ./overseer-template;
          recursive = true;
        };
      }
      // (
        if isDarwin then
          {
            "Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/SKK-JISYO.L" = {
              source = "${skkLib.skkDict}/SKK-JISYO.L";
              force = true;
            };
          }
        else
          { }
      );
  };

  home.activation.enableLaunchAgents = {
    after = [ "writeBoundary" ];
    before = [ ];
    data = ''
      if command -v launchctl >/dev/null 2>&1; then
        launchctl unload -wF "$HOME/Library/LaunchAgents/com.kaitosawada.llama.server.plist" 2>/dev/null || true
        launchctl unload -wF "$HOME/Library/LaunchAgents/com.kaitosawada.colima.start.plist" 2>/dev/null || true
        launchctl load -w "$HOME/Library/LaunchAgents/com.kaitosawada.colima.start.plist" || true
        # launchctl load -w "$HOME/Library/LaunchAgents/com.kaitosawada.llama.server.plist" || true
      fi
    '';
  };

  nix = {
    package = pkgs.nix;
    settings = {
      "experimental-features" = [ "nix-command" "flakes" ];
      cores = 8;
      "max-jobs" = 8;
    };
  };
}
