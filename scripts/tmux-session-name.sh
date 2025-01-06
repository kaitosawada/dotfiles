#!/bin/bash

# 現在のディレクトリを取得
current_dir=$(pwd)

# セッション名を決定
if [ -d "$current_dir/.git" ]; then
    # Gitリポジトリの場合はリポジトリ名を取得
    session_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
else
    # Gitリポジトリでない場合はフォルダ名を使用
    session_name=$(basename "$current_dir")
fi

# tmuxセッションを開始（すでに存在する場合は接続）
tmux has-session -t "$session_name" 2>/dev/null
if [ $? != 0 ]; then
    tmux new-session -d -s "$session_name"
fi

tmux attach-session -t "$session_name"
