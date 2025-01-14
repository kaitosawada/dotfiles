function switch-project() {
  local repo
  repo="$(ghq list | fzf --reverse)"
  [ -z "$repo" ] && return 1

  local dir="$(ghq root)/$repo"
  local session_name="$(basename "$repo")"

  if command -v zellij >/dev/null 2>&1; then
    if [ -z "$ZELLIJ" ]; then
      echo "zellij --session $session_name"
      cd "$dir" && zellij attach "$session_name" --create
    else
      cd "$dir" || return
    fi
  elif command -v tmux >/dev/null 2>&1; then
    # 既にtmux内かどうかで挙動を分ける
    if [ -z "$TMUX" ]; then
      tmux new-session -A -s "$session_name" -c "$dir"
    else
      # 既に同名セッションがあるならそこへ切り替え、なければ作成する
      # tmux has-session -t "$session_name" 2>/dev/null \
      #   && tmux switch-client -t "$session_name" \
      #   || tmux new-session -s "$session_name" -c "$dir"
      tmux has-session -t "$session_name" 2>/dev/null && {
        tmux switch-client -t "$session_name"
      } || {
        tmux new-session -d -s "$session_name" -c "$dir"
        tmux switch-client -t "$session_name"
      }
    fi
  else # tmuxもzellijもない場合はcdだけ
    cd "$dir" || return
  fi
}
alias g=switch-project
