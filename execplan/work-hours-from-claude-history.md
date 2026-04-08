# Claude Code履歴から勤務時間を算出するスクリプト

## What & Why
Claude Codeの利用履歴（`~/.claude/history.jsonl`）から日ごとの勤務時間を算出するNode.jsスクリプト。将来的にfreee人事労務APIへの連携を見据えるが、まずは取得・表示のみ。

## Decisions Made
- データソース: `~/.claude/history.jsonl`（timestamp + project）
- 出勤 = その日の最初の操作、退勤 = 最後の操作（時間帯フィルタなし）
- 全プロジェクト合算
- 休憩は固定1時間を引く
- 日付の区切りは5:00（深夜作業は前日の退勤扱い）
- 月指定でテーブル表示（デフォルト今月）
- 配置: `scripts/work-hours.mjs`
- 外部依存なし（Node.js標準のみ）

## Implementation Steps
1. `scripts/work-hours.mjs` を作成
   - `~/.claude/history.jsonl` を行ごとに読み込み
   - timestampをJSTに変換、5時区切りで日付グルーピング
   - 日ごとに最初・最後のtimestampを取得
   - 差分 - 1時間 = 勤務時間
   - CLIテーブルで出力（日付、出勤、退勤、勤務時間）+ 月合計
   - `--month 2026-03` 引数対応（デフォルト今月）

## Validation
- `node scripts/work-hours.mjs` で今月分が表示される
- `node scripts/work-hours.mjs --month 2026-03` で3月分が表示される
- 深夜作業が前日扱いになっていることを確認
