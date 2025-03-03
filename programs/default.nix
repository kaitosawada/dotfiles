{ pkgs, ... }:
{
  imports = [
    ./lazygit.nix
    ./starship.nix
    ./wezterm
    ./zellij
    ./zsh.nix
  ];

  programs.bash = {
    enable = true;
    bashrcExtra = ''
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

  programs.nixvim = import ./nixvim;
  programs.zoxide.enable = true;

  # https://github.com/nix-community/home-manager/blob/master/modules/programs/direnv.nix
  programs.direnv = {
    enable = true;
  };
  programs.awscli.enable = true;
}
