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
      bindkey -e  # Use emacs keybindings
      ${builtins.readFile ../scripts/init-nix.sh}
      ${builtins.readFile ../scripts/switch-project.sh}

      # Move latest downloaded file to current directory (or specified path)
      mvl() {
        local latest=$(ls -t ~/Downloads | head -1)
        if [[ -z "$latest" ]]; then
          echo "Downloadsにファイルがありません"
          return 1
        fi
        echo "移動: $latest → ''${1:-.}"
        mv ~/Downloads/"$latest" "''${1:-.}"
      }

      # SSH via Cloudflare Access tunnel
      sshcf() {
        ssh -o ProxyCommand="cloudflared access ssh --hostname %h" "$@"
      }
    '';
  };
}
