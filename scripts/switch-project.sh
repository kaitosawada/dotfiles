function switch-project() {
  local repo
  local candidates
  candidates="$(ghq list)"

  # ~/obsidian が存在すれば、その中のディレクトリも候補に追加
  if [ -d "$HOME/obsidian" ]; then
    local obsidian_dirs
    obsidian_dirs="$(ls -1 "$HOME/obsidian" 2>/dev/null | sed 's|^|obsidian/|')"
    [ -n "$obsidian_dirs" ] && candidates="$candidates"$'\n'"$obsidian_dirs"
  fi

  repo="$(echo "$candidates" | fzf --reverse)"
  [ -z "$repo" ] && return 1

  local dir
  if [[ "$repo" == obsidian/* ]]; then
    dir="$HOME/${repo}"
  else
    dir="$(ghq root)/$repo"
  fi
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
