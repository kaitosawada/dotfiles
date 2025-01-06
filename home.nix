{ config, pkgs, ... }:

let
  isDarwin = builtins.currentSystem == "x86_64-darwin" || builtins.currentSystem == "aarch64-darwin";
  username = builtins.getEnv "USER";
  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
  nixvim = import (builtins.fetchGit { url = "https://github.com/nix-community/nixvim"; });
in
{
  imports = [
    nixvim.homeManagerModules.nixvim
    ./programs
  ];

  nixpkgs.config.allowUnfree = true;
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    git
    go
    ghq
    gnumake
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
    # nodejs_22
    # (nodePackages."@antfu/ni".override {
    #   nodejs = nodejs_22;
    # })
    # pnpm
    duckdb
    nixfmt-rfc-style
    todo-txt-cli
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "ja_JP.UTF-8";
  };

  home.shellAliases = {
    n = "nvim";
    lg = "lazygit";
    load = "exec $SHELL -l";
    reload = ''home-manager switch -f "$(ghq root)/github.com/kaitosawada/dotfiles/home.nix" && exec $SHELL -l && tmux source-file ~/.config/tmux/tmux.conf'';
    config = ''cd "$(ghq root)/github.com/kaitosawada/dotfiles && nvim'';
    tree = "lsd --tree";
    grep = "rg";
    sed = "sd";
    cd = "z";
    t = "tmux";
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    completionInit = "autoload -Uz compinit && compinit -i"; # https://qiita.com/mkiken/items/8dcefc38857d82949164
    autosuggestion = {
      enable = true;
      highlight = "fg=#AAAAAA";
    };
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      extended = true;
    };
    profileExtra = ''
      bindkey -M viins 'jj' vi-cmd-mode
      ${builtins.readFile ./scripts/init-nix.sh}
      ${builtins.readFile ./scripts/switch-project.sh}
    '';
  };

  programs.bash = {
    enable = true;
    profileExtra = ''
      ${builtins.readFile ./scripts/init-nix.sh}
      ${builtins.readFile ./scripts/switch-project.sh}
    '';
  };


  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      max-jobs = auto
      cores = 0
      experimental-features = nix-command flakes
    '';
  };

  programs.git = {
    enable = true;
    userName = "kaitosawada";
    userEmail = "kaito.sawada@proton.me";
    extraConfig = {
      pull.rebase = false;
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    };
  };

  programs.gh = {
    enable = true;
    extensions = [ pkgs.gh-copilot ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  programs.bat = {
    enable = true;
    config.theme = "nightfox";
    themes = {
      nightfox = {
        src = ./themes;
        file = "nightfox.tmTheme";
      };
    };
  };

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./.wezterm.lua;
  };

  programs.nixvim = import ./nixvim;
  # Let Home Manager install and manage itself.
  # programs.home-manager = {
  #   enable = true;
  # };
  programs.zoxide.enable = true;
  programs.direnv.enable = true;
  programs.awscli.enable = true;
}
