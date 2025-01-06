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
    sd
    # podman
    # podman-desktop
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
    # DOCKER_HOST="unix:///var/folders/86/v6ttpl1d4mn5skbhmm2vthp80000gn/T/podman/podman-machine-default-api.sock";
    # LIBGL_ALWAYS_INDIRECT = 1;
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
      git_branch.disabled = true;
      git_status.disabled = true;
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

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./.wezterm.lua;
  };

  programs.tmux = {
    enable = true;
    prefix = "C-f";
    keyMode = "vi";
    terminal = "tmux-256color";
    plugins = [
      {
        plugin = pkgs.tmuxPlugins.tokyo-night-tmux;
        extraConfig = '' 
          set -g @tokyo-night-tmux_theme storm    # storm | day | default to 'night'
          set -g @tokyo-night-tmux_transparent 0  # 1 or 0
          set -g @tokyo-night-tmux_show_datetime 0
          set -g @tokyo-night-tmux_date_format MYD
          set -g @tokyo-night-tmux_time_format 12H
        '';
      }
      # {
      #   plugin = pkgs.tmuxPlugins.catppuccin;
      #   extraConfig = '' 
      #     set -g @catppuccin_flavour 'frappe'
      #     set -g @catppuccin_window_tabs_enabled on
      #     set -g @catppuccin_date_time "%H:%M"
      #   '';
      # }
    ];
    extraConfig = ''
      set -g status-left "#S "

      bind -n C-t new-window -c "#{pane_current_path}"
      bind -n C-q confirm-before 'kill-window'

      bind -n C-h previous-window
      bind -n C-l next-window

      bind -n C-- split-window -vc "#{pane_current_path}"
      bind -n C-| split-window -hc "#{pane_current_path}"

      bind -n C-k select-pane -t :.-
      bind -n C-j select-pane -t :.+
      bind -n C-w kill-pane
      bind -n C-y copy-mode
    '';
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
