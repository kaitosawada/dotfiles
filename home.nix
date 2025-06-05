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
      deno
      git
      go
      ghq
      gnumake
      lazysql
      jq
      ripgrep
      sd
      docker
      docker-buildx
      nix-search-cli
      duckdb
      nixfmt-rfc-style
      todo-txt-cli
      redis
      imagemagick
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
      tree = "lsd --tree";
      grep = "rg";
      t = ''zellij attach "$(basename $(pwd))" --create'';
      unlock = "export BW_SESSION=$(bw unlock --raw)";
      gr = ''cd "$(git rev-parse --show-toplevel)"'';
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
