{ pkgs, config, ... }:
{
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
    initExtra = ''
      bindkey -M viins 'jj' vi-cmd-mode
      ${builtins.readFile ../scripts/init-nix.sh}
      ${builtins.readFile ../scripts/switch-project.sh}
      if [ -x "${pkgs.zellij}/bin/zellij" ]; then
        eval "$(${pkgs.zellij}/bin/zellij setup --generate-auto-start zsh)"
      else
        echo "zellij is not available" >&2
      fi
    '';

  };
}
