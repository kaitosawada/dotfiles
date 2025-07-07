{
  system,
  username,
  homeDirectory,
  pkgs,
  ...
}:
{
  imports = [
    ./programs
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
        "npm:playwright" = "latest";
        "npm:@playwright/mcp" = "latest";

        # Python
        python = "3.12";
        uv = "latest";
      };
    };
  };

  home = {
    username = username;
    homeDirectory = homeDirectory;
    stateVersion = "24.11";

    packages = with pkgs; [
      # git
      git
      ghq

      # languages
      deno
      go

      # nix
      nix-search-cli
      nixfmt-rfc-style

      # tools
      gnumake
      jq
      ripgrep
      sd
      imagemagick
      libreoffice-bin

      # docker
      docker
      docker-buildx

      # rust
      rustc
      cargo
      rustfmt
      clippy

      # neovim
      neovim-remote
    ];

    sessionVariables = {
      EDITOR = "nvim";
      LANG = "ja_JP.UTF-8";
      NIXPKGS_ALLOW_UNFREE = "1";
    };

    shellAliases = {
      n = "nvim";
      lg = "lazygit";
      load = "exec $SHELL -l";
      reload = ''export NIXPKGS_ALLOW_UNFREE=1 && home-manager switch --flake "$(ghq root)/github.com/kaitosawada/dotfiles#${username}-${system}" --impure && exec $SHELL -l && mise i'';
      t = ''zellij attach "$(basename $(pwd))" --create'';
      o = "cd ~/obsidian/kaitosawada && nvim .";
      todo = "nvim ~/obsidian/kaitosawada/tasks.md";
    };
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
