{
  inputs,
  username,
  homeDirectory,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./programs
  ];

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
      glow
      lazygit
      lazysql
      jq
      kubectx
      ripgrep
      sd
      docker
      docker-buildx
      gvproxy
      google-cloud-sdk
      nix-search-cli
      go-task
      nodejs_22
      (nodePackages."@antfu/ni".override {
        nodejs = nodejs_22;
      })
      pnpm
      yarn
      duckdb
      nixfmt-rfc-style
      todo-txt-cli
      redis
    ];

    sessionVariables = {
      EDITOR = "nvim";
      LANG = "ja_JP.UTF-8";
    };

    shellAliases = {
      n = "nvim";
      lg = "lazygit";
      load = "exec $SHELL -l";
      reload = ''home-manager switch --flake "$(ghq root)/github.com/kaitosawada/dotfiles#$(whoami)-$(uname -m)-$(uname -s)" && exec $SHELL -l'';
      config = ''cd "$(ghq root)/github.com/kaitosawada/dotfiles && nvim'';
      tree = "lsd --tree";
      grep = "rg";
      cd = "z";
      t = ''zellij attach "$(basename $(pwd))" --create'';
    };
  };

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      max-jobs = 8 
      cores = 8
      experimental-features = nix-command flakes
    '';
  };
}
