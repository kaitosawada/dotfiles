#!/usr/bin/env sh
# Open a file (optionally at a line) in the nvim instance that launched lazygit.
# Falls back to a per-zellij-session nvim server, then to a plain nvim.
set -eu

file="$1"
line="${2:-}"

server=""
if [ -n "${NVIM:-}" ]; then
  server="$NVIM"
elif [ -n "${ZELLIJ_SESSION_NAME:-}" ] && [ -S "/tmp/nvim-$ZELLIJ_SESSION_NAME.pipe" ]; then
  server="/tmp/nvim-$ZELLIJ_SESSION_NAME.pipe"
fi

if [ -n "$server" ]; then
  nvim --server "$server" --remote-tab "$file"
  if [ -n "$line" ]; then
    nvim --server "$server" --remote-send ":$line<CR>"
  fi
  exit 0
fi

if [ -n "$line" ]; then
  exec nvim "+$line" "$file"
fi
exec nvim "$file"
