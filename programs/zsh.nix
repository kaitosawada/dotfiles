{
  system,
  homeDirectory,
  lib,
  ...
}:
let
  isDarwin = system == "aarch64-darwin" || system == "x86_64-darwin";
  bitwardenAgentSocket =
    if isDarwin then
      "${homeDirectory}/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
    else
      "${homeDirectory}/.bitwarden-ssh-agent.sock";
in
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
      # SSH経由で接続した場合はforwardされたagentを使い、ローカルの場合のみbitwardenを使う
      if [[ -z "$SSH_CONNECTION" ]]; then
        export SSH_AUTH_SOCK="${bitwardenAgentSocket}"
      fi

      bindkey -e  # Use emacs keybindings

      # Suppress function key escape sequences in zsh line editor
      bindkey -s $'\e[15~' ""  # F5
      bindkey -s $'\e[17~' ""  # F6
      bindkey -s $'\e[18~' ""  # F7
      bindkey -s $'\e[19~' ""  # F8
      bindkey -s $'\e[20~' ""  # F9
      bindkey -s $'\e[21~' ""  # F10
      bindkey -s $'\e[23~' ""  # F11
      bindkey -s $'\e[24~' ""  # F12
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
    '';
  };
}
