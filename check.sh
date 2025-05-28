#!/bin/bash
# git-status-check.sh

echo "🔍 ghq管理下のリポジトリ状態チェック中..."
echo "================================================"

ghq list -p | while read repo_path; do
    if [ -d "$repo_path/.git" ]; then
        cd "$repo_path"
        
        # 基本情報
        repo_name=$(basename "$repo_path")
        current_branch=$(git branch --show-current 2>/dev/null || echo "HEAD detached")
        
        # 各種状態チェック
        untracked_count=$(git ls-files --others --exclude-standard | wc -l)
        modified_count=$(git diff --name-only | wc -l)
        staged_count=$(git diff --cached --name-only | wc -l)
        
        # リモートとの差分（プッシュしていないコミット）
        unpushed_count=0
        if git rev-parse @{u} >/dev/null 2>&1; then
            unpushed_count=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
        fi
        
        # 警告が必要かチェック
        has_issues=false
        issues=()
        
        if [ $untracked_count -gt 0 ]; then
            has_issues=true
            issues+=("未追跡: ${untracked_count}ファイル")
        fi
        
        if [ $modified_count -gt 0 ]; then
            has_issues=true
            issues+=("未ステージ: ${modified_count}ファイル")
        fi
        
        if [ $staged_count -gt 0 ]; then
            has_issues=true
            issues+=("未コミット: ${staged_count}ファイル")
        fi
        
        if [ $unpushed_count -gt 0 ]; then
            has_issues=true
            issues+=("未プッシュ: ${unpushed_count}コミット")
        fi
        
        # 結果表示
        if [ "$has_issues" = true ]; then
            echo "⚠️  $repo_name [$current_branch]"
            printf "   📍 %s\n" "$repo_path"
            for issue in "${issues[@]}"; do
                echo "   - $issue"
            done
            echo ""
        fi
    fi
done

echo "✅ チェック完了"
