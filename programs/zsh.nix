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

    initExtra = ''
      bindkey -M viins 'jj' vi-cmd-mode
      ${builtins.readFile ../scripts/init-nix.sh}
      ${builtins.readFile ../scripts/switch-project.sh}

      if [ -d "$HOME/google-cloud-sdk/bin" ]; then
        export PATH="$HOME/google-cloud-sdk/bin:$PATH"
      fi

      if [ -d "$HOME/.tiup/bin" ]; then
        export PATH="$HOME/.tiup/bin:$PATH"
      fi
    '';
  };
}
