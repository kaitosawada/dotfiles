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

    # history = {
    #   size = 10000;
    #   extended = true;
    # };
    initExtra = ''
      bindkey -M viins 'jj' vi-cmd-mode
      ${builtins.readFile ../scripts/init-nix.sh}
      ${builtins.readFile ../scripts/switch-project.sh}

      if [ -z "$ZELLIJ" ]; then
        eval "$(direnv hook zsh)"
      fi

      # # https://zenn.dev/entaku/articles/8464d0c109b936
      # # ディレクトリごとの履歴ファイルを保存するディレクトリを作成
      # HISTDIR="$HOME/.zsh_history.d"
      # [[ ! -d "$HISTDIR" ]] && mkdir -p "$HISTDIR"
      #
      # # カレントディレクトリが変更されたときに呼ばれる関数
      # function chpwd() {
      #     local history_file="$HISTDIR/$(pwd | sed -e "s|/|_|g").history"
      #     # 履歴ファイルが存在しない場合は作成
      #     [[ ! -f "$history_file" ]] && touch "$history_file"
      #     # HISTFILE変数を更新
      #     HISTFILE="$history_file"
      # }
      #
      # # 履歴の保存件数を設定
      # HISTSIZE=1000
      # SAVEHIST=1000
      #
      # # 履歴を共有
      # setopt share_history
      # # 重複を記録しない
      # setopt hist_ignore_dups
      # # スペースで始まるコマンドは履歴に追加しない
      # setopt hist_ignore_space
      #
      # # 初期設定
      # chpwd
    '';
  };
}
