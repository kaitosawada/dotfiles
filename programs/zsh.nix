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

    initContent = ''
      bindkey -M viins 'jj' vi-cmd-mode
      ${builtins.readFile ../scripts/init-nix.sh}
      ${builtins.readFile ../scripts/switch-project.sh}

      function f6-null() { :; }  # 何もしない関数
      zle -N f6-null
      bindkey "^[[17~" f6-null
      bindkey "^[[15~" f6-null

      if [ -d "$HOME/google-cloud-sdk/bin" ]; then
        export PATH="$HOME/google-cloud-sdk/bin:$PATH"
      fi

      if [ -d "$HOME/.tiup/bin" ]; then
        export PATH="$HOME/.tiup/bin:$PATH"
      fi
    '';
  };
}
