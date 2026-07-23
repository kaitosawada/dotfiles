# Build the default herdr layout via sequential pane splits.
# Prefer this over layout.apply: apply spawns PTYs at full client size, so nvim
# keeps &columns/&lines of the whole terminal. Splits resize the PTY correctly.
#
# Layout (same as sessionizer/config.toml and layouts/default.json):
#   left cursor-agent (40%) | right nvim (70% height) over two term panes (30%)
# herdr --ratio is the share the *source* pane keeps (not the new pane).
function herdr-apply-layout() {
  local root_pane="$1"
  local cwd="$2"

  herdr pane rename "$root_pane" claude >/dev/null || true
  herdr pane run "$root_pane" cursor-agent >/dev/null || true

  local nvim_pane term1_pane term2_pane
  nvim_pane="$(
    herdr pane split "$root_pane" --direction right --ratio 0.4 --cwd "$cwd" --focus \
      | jq -r '.result.pane.pane_id // empty'
  )"
  [ -n "$nvim_pane" ] || return 1
  herdr pane rename "$nvim_pane" nvim >/dev/null || true
  herdr pane run "$nvim_pane" nvim >/dev/null || true

  term1_pane="$(
    herdr pane split "$nvim_pane" --direction down --ratio 0.7 --cwd "$cwd" --no-focus \
      | jq -r '.result.pane.pane_id // empty'
  )"
  [ -n "$term1_pane" ] || return 1
  herdr pane rename "$term1_pane" term >/dev/null || true

  term2_pane="$(
    herdr pane split "$term1_pane" --direction right --ratio 0.5 --cwd "$cwd" --no-focus \
      | jq -r '.result.pane.pane_id // empty'
  )"
  [ -n "$term2_pane" ] || return 1
  herdr pane rename "$term2_pane" term >/dev/null || true
}

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

  # herdr: 既存 workspace（同 cwd）へ focus、なければ create + default layout
  if command -v herdr >/dev/null 2>&1 && herdr workspace list >/dev/null 2>&1; then
    local dir_real
    dir_real="$(cd "$dir" && pwd -P)" || return

    local wid
    wid="$(
      herdr pane list 2>/dev/null | jq -r --arg dir "$dir_real" '
        def norm: gsub("^/private"; "");
        .result.panes[]?
        | ((.cwd // .foreground_cwd // "") | norm) as $c
        | select($c == ($dir | norm))
        | .workspace_id
      ' | head -n 1
    )"

    if [ -n "$wid" ]; then
      herdr workspace focus "$wid" >/dev/null
    else
      local created root_pane
      created="$(herdr workspace create --cwd "$dir_real" --label "$session_name" --focus)"
      root_pane="$(echo "$created" | jq -r '.result.root_pane.pane_id // empty')"
      if [ -n "$root_pane" ]; then
        herdr-apply-layout "$root_pane" "$dir_real"
      fi
    fi
    return
  fi

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
