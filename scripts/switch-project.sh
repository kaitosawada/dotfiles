# Apply ~/.config/herdr/layouts/default.json to a herdr tab via socket API.
function herdr-apply-layout() {
  local tab_id="$1"
  local cwd="$2"
  local session="$3"
  local layout_file="${HERDR_LAYOUT:-$HOME/.config/herdr/layouts/default.json}"
  [ -f "$layout_file" ] || return 0

  local root
  root="$(
    jq -c --arg cwd "$cwd" --arg session "$session" '
      def inject:
        if type != "object" then .
        elif .type == "pane" then
          .cwd = $cwd
          | if (.command | type) == "array" then
              .command |= map(gsub("__SESSION__"; $session))
            else .
            end
        elif .type == "split" then
          .first |= inject | .second |= inject
        else .
        end;
      inject
    ' "$layout_file"
  )" || return 1

  jq -nc --arg tab_id "$tab_id" --argjson root "$root" \
    '{id:"layout-apply",method:"layout.apply",params:{tab_id:$tab_id,focus:true,root:$root}}' \
    | python3 -c '
import json, os, socket, sys

req = json.load(sys.stdin)
sock_path = os.environ.get("HERDR_SOCKET_PATH") or os.path.expanduser(
    "~/.config/herdr/herdr.sock"
)
s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
s.connect(sock_path)
s.sendall((json.dumps(req) + "\n").encode())
buf = b""
while True:
    chunk = s.recv(65536)
    if not chunk:
        break
    buf += chunk
    if b"\n" in buf:
        break
s.close()
resp = json.loads(buf.decode().split("\n", 1)[0])
if "error" in resp:
    raise SystemExit(resp["error"].get("message", "layout.apply failed"))
'
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
      local created tab_id
      created="$(herdr workspace create --cwd "$dir_real" --label "$session_name" --focus)"
      tab_id="$(echo "$created" | jq -r '.result.tab.tab_id // empty')"
      if [ -n "$tab_id" ]; then
        herdr-apply-layout "$tab_id" "$dir_real" "$session_name"
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
