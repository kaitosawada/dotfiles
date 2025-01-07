{ pkgs, ... }:
{
  imports = [
    ./starship.nix
    # ./tmux.nix
    ./zellij.nix
    ./zsh.nix
  ];

  programs.bash = {
    enable = true;
    initExtra = ''
      ${builtins.readFile ../scripts/init-nix.sh}
      ${builtins.readFile ../scripts/switch-project.sh}
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
        src = ../themes;
        file = "nightfox.tmTheme";
      };
    };
  };

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ../.wezterm.lua;
  };

  programs.nixvim = import ../nixvim;
  # Let Home Manager install and manage itself.
  # programs.home-manager = {
  #   enable = true;
  # };
  programs.zoxide.enable = true;
  programs.direnv.enable = true;
  programs.awscli.enable = true;
}
