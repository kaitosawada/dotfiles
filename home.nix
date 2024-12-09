{ config, pkgs, ... }:

let
  isDarwin = builtins.currentSystem == "x86_64-darwin" || builtins.currentSystem == "aarch64-darwin";
  username = builtins.getEnv "USER";
  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
  nixvim = import (builtins.fetchGit { url = "https://github.com/nix-community/nixvim"; });
in
{
  imports = [ nixvim.homeManagerModules.nixvim ];

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
    # podman
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
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "ja_JP.UTF-8";
    # LIBGL_ALWAYS_INDIRECT = 1;
  };

  home.shellAliases = {
    g = ''cd $(ghq root)/$(ghq list | fzf --reverse) && wezterm cli set-tab-title $(basename "$PWD")'';
    n = "nvim";
    lg = "lazygit";
    load = "exec $SHELL -l";
    reload = ''home-manager switch -f "$(ghq root)/github.com/kaitosawada/dotfiles/home.nix" && exec $SHELL -l'';
    config = ''nvim "$(ghq root)/github.com/kaitosawada/dotfiles/home.nix"'';
    tree = "lsd --tree";
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
    };
    profileExtra = ''
      bindkey -M viins 'jj' vi-cmd-mode
    '';
    # oh-my-zsh = {
    #   enable = true;
    #   # plugins = [ "git" "sudo" ];
    #   theme = "robbyrussell";
    # };
  };
  programs.bash = {
    enable = true;
    profileExtra = ''
      export XDG_DATA_DIRS=$HOME/.nix-profile/share''${XDG_DATA_DIRS:+:}$XDG_DATA_DIRS
      export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
          . $HOME/.nix-profile/etc/profile.d/nix.sh;
      fi
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      character = {
        success_symbol = "[\\$](bold green)";
        error_symbol = "[\\$](bold red)";
      };

      aws.disabled = true;
      gcloud.disabled = true;
      package.disabled = true;
      nix_shell.format = "[$symbol $state]($style) ";
      nix_shell.symbol = "❄️";
      direnv = {
        format = "[$symbol$loaded/$allowed]($style) ";
        disabled = false;
        allowed_msg = "✅";
        not_allowed_msg = "🚫";
        loaded_msg = "🚚";
        unloaded_msg = "🛻";
      };
    };
  };

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      max-jobs = auto
      cores = 0
      experimental-features = nix-command flakes
      # binary-caches = s3://test-bucket-sawada?scheme=https&endpoint=a861edcf31e50df89b431c5ebe6a3019.r2.cloudflarestorage.com&trusted=1&profile=cloudflare-r2 https://cache.nixos.org/
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

  programs.nixvim = import ./nixvim;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.zoxide.enable = true;
  programs.direnv.enable = true;
  programs.wezterm.enable = true;
  programs.awscli.enable = true;
}
