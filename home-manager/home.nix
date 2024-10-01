{ config, pkgs, ... }:

let
  isDarwin = builtins.currentSystem == "x86_64-darwin" || builtins.currentSystem == "aarch64-darwin";
  username = builtins.getEnv "USER";
  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    git
    gh
    go
    ghq
    gnumake
    direnv
    neovim
    fzf
    lazygit
    # asdf-vm
    awscli2
    podman
    tmux
    zoxide
  ];

  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      add_newline = true;

      # character = {
      #   success_symbol = "[➜](bold green)";
      #   error_symbol = "[➜](bold red)";
      # };

      # package.disabled = true;
    };
  };

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs.git = {
    enable = true;
    userName = "kaitosawada";
    userEmail = "kaito.sawada@proton.me";
    extraConfig.pull.rebase = false;
  };

  home.sessionVariables = {
    EDITOR = "vim";
    LANG = "ja_JP.UTF-8";
    # LC_ALL = "ja_JP.UTF-8";
  };

  home.shellAliases = {
    g = "cd $(ghq root)/$(ghq list | fzf --reverse) && wezterm cli set-tab-title $(basename \"$PWD\")";
    n = "nvim";
    reload = "home-manager switch && exec $SHELL -l";
    conf = "nvim \"$(ghq root)/github.com/kaitosawada/dotfiles/home-manager/home.nix\"";
    config = "nvim \"$(ghq root)/github.com/kaitosawada/dotfiles/home-manager/home.nix\"";
    ".." = "cd ..";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    profileExtra = ''
      export XDG_DATA_DIRS=$HOME/.nix-profile/share''${XDG_DATA_DIRS:+:}$XDG_DATA_DIRS
      export LIBGL_ALWAYS_INDIRECT=1
      export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
          . $HOME/.nix-profile/etc/profile.d/nix.sh;
      fi
      . "$HOME/.nix-profile/share/asdf-vm/asdf.sh"
      . "$HOME/.nix-profile/share/bash-completion/completions/asdf.bash"
      eval "$(direnv hook zsh)"
    '';
  };
  programs.bash = {
    enable = true;
    profileExtra = ''
      export XDG_DATA_DIRS=$HOME/.nix-profile/share''${XDG_DATA_DIRS:+:}$XDG_DATA_DIRS
      export LIBGL_ALWAYS_INDIRECT=1
      export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
          . $HOME/.nix-profile/etc/profile.d/nix.sh;
      fi
      . "$HOME/.nix-profile/share/asdf-vm/asdf.sh"
      . "$HOME/.nix-profile/share/bash-completion/completions/asdf.bash"
      eval "$(direnv hook bash)"
    '';
  };
}
