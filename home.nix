{ config, pkgs, ... }:

let
  isDarwin = builtins.currentSystem == "x86_64-darwin" || builtins.currentSystem == "aarch64-darwin";
  username = builtins.getEnv "USER";
  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  nixpkgs.config.allowUnfree = true;
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    git
    go
    ghq
    gnumake
    neovim
    lazygit
    lazysql
    jq
    kubectx
    ripgrep
    podman
    gvproxy
    google-cloud-sdk
    nix-search-cli
    go-task
    nodejs_22
    (nodePackages."@antfu/ni".override {
      nodejs = nodejs_22;
    })
    pnpm
  ];

  home.file = {
    ".config/nvim".source = ./nvim;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "ja_JP.UTF-8";
    LC_ALL = "ja_JP.UTF-8";
    LIBGL_ALWAYS_INDIRECT = 1;
    DOCKER_HOST = "unix:///var/folders/kd/swzymx0s67j00xyc3p49gwq40000gn/T/podman/podman-machine-default-api.sock";
    CDK_DOCKER = "podman";
  };

  home.shellAliases = {
    g = "cd $(ghq root)/$(ghq list | fzf --reverse) && wezterm cli set-tab-title $(basename \"$PWD\")";
    n = "nvim";
    lg = "lazygit";
    reload = "home-manager switch -f \"$(ghq root)/github.com/kaitosawada/dotfiles/home.nix\" && exec $SHELL -l";
    conf = "nvim \"$(ghq root)/github.com/kaitosawada/dotfiles/home.nix\"";
    config = "nvim \"$(ghq root)/github.com/kaitosawada/dotfiles/home.nix\"";
    ai = "gh copilot suggest";
    ae = "gh copilot explain";
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
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
    #   # theme = "robbyrussell";
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
    };
  };

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
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
    extensions = [
      pkgs.gh-copilot
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.zoxide.enable = true;
  programs.direnv.enable = true;
  programs.wezterm.enable = true;
  programs.awscli.enable = true;
}
