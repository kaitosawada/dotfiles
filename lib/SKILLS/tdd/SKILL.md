---
name: tdd-twada
description: >
  t.wada流テスト駆動開発（TypeScript/JavaScript・Vitest）。Red-Green-Refactorサイクルで機能を実装。トリガー:
  「TDDで実装して」「テスト駆動で」「テストファーストで」「TDD」「Red-Green-Refactor」。Vitest / @testing-library 前提。
  Python向けTDDにはプロジェクトローカルのtdd-wada-styleスキルを使用。

---

# t.wada流 TDD（テスト駆動開発）

## Overview

和田卓人氏（t.wada）のTDD哲学に基づき、テストファーストで機能を実装するスキル。TypeScript / JavaScript と **Vitest** を前提とする。

> 「テストとは、動くことを証明するものではない。間違いを見つけるためのものだ。」
> — t.wada

## Core Philosophy（中核思想）

### 3つの原則

1. **テストは設計行為**
   テストを書くことで、使いやすいAPIを設計する。テストが書きにくい = 設計が悪い兆候。

2. **テストは仕様書**
   テストコードが最も正確なドキュメントである。コードの振る舞いを表現する。

3. **小さく回す**
   Red → Green → Refactor を短いサイクル（数分単位）で繰り返す。

## When to Use This Skill

Use this skill when:
- Implementing new features with TDD approach
- Writing tests before implementation code
- Applying Red-Green-Refactor cycle
- Designing APIs through tests
- Ensuring test coverage and quality
- User explicitly requests TDD or test-first development

## TDD Cycle: Red-Green-Refactor

```
┌─────────────────────────────────────────┐
│                                         │
│    🔴 RED        → 失敗するテストを書く │
│      ↓                                  │
│    🟢 GREEN      → 最小限のコードで通す │
│      ↓                                  │
│    🔵 REFACTOR   → 設計を改善する       │
│      ↓                                  │
│    （繰り返し）                          │
│                                         │
└─────────────────────────────────────────┘
```

### 🔴 Red（失敗するテスト）

**目的**: 次に実装する振る舞いを明確にする

- 失敗することを**必ず確認**してから次へ進む（Red を見ずに Green へ行かない）
- テスト名は「何をテストするか」を日本語で明確に
- Arrange-Act-Assert（AAA）パターンで構造化

**例**:
```ts
import { describe, expect, it } from "vitest";
import { sortNumbers } from "./sort";

describe("sortNumbers", () => {
  it("空のリストを渡すと空のリストを返す", () => {
    // Arrange（準備）
    const input: number[] = [];

    // Act（実行）
    const result = sortNumbers(input);

    // Assert（検証）
    expect(result).toEqual([]);
  });
});
```

### 🟢 Green（最小実装）

**目的**: テストを通す

- テストを通す**最小限**のコードを書く
- 「汚くてもいい、動けばいい」段階
- 過度な一般化はしない（YAGNI）

**例**:
```ts
// 最初は仮実装でもOK
export function sortNumbers(numbers: number[]): number[] {
  return []; // まずこれでテストを通す
}
```

### 🔵 Refactor（リファクタリング）

**目的**: 設計を改善する

- テストが**グリーンを維持**しながら改善
- 重複の除去、命名の改善、責務の分離
- 小さなステップで変更

**ルール**:
- テストは常にパスする状態を保つ
- 振る舞いは変えない（内部構造のみ変更）

## Implementation Workflow

### Step 1: 要件分析（5分）

1. 実装したい機能を**振る舞い**の単位で分解
2. 「〜したとき、〜となる」形式でテストケースをリストアップ
3. 最も単純なケースから始める

**テストケースリストの例**:
```
□ 空のリストを渡すと空のリストを返す
□ 1要素のリストはそのまま返す
□ 複数要素は昇順でソートされる
□ 重複要素があっても正しくソートされる
□ 負の数を含んでも正しくソートされる
```

**Use the todo/task tool to track test cases.**

### Step 2: TDDサイクルの実行

各テストケースに対して Red → Green → Refactor を実行:

1. **🔴 Red**: 失敗するテストを書く
   - `vitest` を実行して失敗を確認（例: `npx vitest run -t "空のリスト"`）
   - 失敗理由が「未実装」であること（アサーションの取り違えで落ちていないこと）を確認
   - テスト名から振る舞いが理解できることを確認

2. **🟢 Green**: 最小実装
   - テストを通す最小限のコードを書く
   - `vitest` を実行してパスを確認

3. **🔵 Refactor**: 改善
   - テストをグリーンに保ちながらリファクタリング
   - 各変更後に `vitest` を実行

4. 次のテストケースへ

### Step 3: 完了確認

- [ ] すべてのテストがパス
- [ ] 各テストが独立して実行可能
- [ ] テスト名から振る舞いが理解できる
- [ ] Arrange-Act-Assert構造が明確
- [ ] 境界値・異常系がカバーされている

## Best Practices

### Do's ✅

1. **1テスト1振る舞い**: 1つの `it` で1つの振る舞いのみ検証
2. **AAA構造**: Arrange-Act-Assert を明確に分離
3. **日本語テスト名**: `it("空のリストを渡すと空のリストを返す", ...)`
4. **独立性**: 各テストが他のテストに依存しない（`beforeEach` で状態をリセット）
5. **小さなステップ**: Red-Green-Refactor を短いサイクルで
6. **型を活かす**: テストデータは対象の型に合わせ、`as const` / `satisfies` で補強する

### Don'ts ❌

1. **実装詳細をテストしない**: 振る舞いをテスト（private な内部状態・呼び出し回数そのものが目的化していないか）
2. **テスト間の依存を作らない**: 各テストが独立
3. **過度なモックは避ける**: 外部I/Oのみモック化
4. **巨大なテストは避ける**: 1テスト1振る舞い
5. **テストを通すためだけのモックを増やさない**: モックが増えたら設計（依存の持ち方）を見直す

詳細は [EXAMPLES.md](EXAMPLES.md#anti-patterns) を参照。

## Test Design Techniques

### 境界値分析

境界値とその前後をテスト:
- 0, 1, -1
- 空配列・空文字、最小、最大
- `null` / `undefined`

### 等価クラス分割

代表値でテスト（全パターンは不要）:
- 有効範囲の代表値
- 無効範囲の代表値

詳細は [REFERENCE.md](REFERENCE.md#test-design-patterns) を参照。

## モックの境界（重要）

「どこまでモックするか」がテストの寿命を決める。原則は **外部I/Oだけモックし、純粋なロジックはモックしない**。

| 対象 | 方針 | 例 |
| ---- | ---- | ---- |
| 純関数・計算・整形 | モックしない | `reorder`, `formatSummary`, `buildQuickAccessItems` |
| DB / リポジトリ | モックする | `vi.mock("../repositories/homepage")` |
| 外部API（メール・AI・ストレージ） | モックする | `vi.mock("@kenpo-web/mail")` |
| HTTPルート | 実ルーターを通す | Hono の `app.request(...)` |
| React コンポーネント | 実物を描画 | `@testing-library/react` |

- **`toHaveBeenCalledWith` は「契約」のときだけ**。下位のリポジトリへ渡す引数が対外契約なら検証してよい。内部の呼び出し順・回数の検証はリファクタで壊れやすいので避ける。
- モックが 5 つを超えたら、テストではなく**設計**を疑う。

詳細は [REFERENCE.md](REFERENCE.md#mocking) を参照。

## Commands

Vite+ のモノレポでは `vp test`、素の Vitest では `npx vitest`。

```bash
# 全テスト実行（1回）
npx vitest run
vp test                       # Vite+ モノレポ

# パッケージを指定（Vite+）
vp test --root admin-hono

# 特定のテストだけ（TDDのRed確認に必須）
npx vitest run -t "空のリストを渡すと空のリストを返す"
vp test --root admin-hono -t "空のリスト"

# Watch mode（TDD向け・推奨）
npx vitest

# カバレッジ
npx vitest run --coverage
```

詳細なコマンドは [REFERENCE.md](REFERENCE.md#commands) を参照。

## Output Guidelines

When providing TDD guidance:

1. **要件を振る舞いで整理**: 「〜したとき、〜となる」形式
2. **テストケースリストを todo で管理**: 進捗を可視化
3. **Red-Green-Refactorを明示**: 各ステップで何をするか説明
4. **テストコードを先に書く**: 実装コードより前に
5. **Red を実際に確認**: 落ちることを確かめてから実装する
6. **リファクタリングを忘れない**: Greenで終わらない

## References

- [REFERENCE.md](REFERENCE.md) - テストパターン、Vitest コマンド、モック、テンプレート
- [EXAMPLES.md](EXAMPLES.md) - 実用例、アンチパターン、AAA構造、ルート/コンポーネントの例

## Success Criteria

TDD実践が成功したと言える基準:

- [ ] テストファーストで実装できた
- [ ] Red（失敗）を実際に確認した
- [ ] すべてのテストがパス
- [ ] 各テストが独立している
- [ ] テスト名から振る舞いが理解できる
- [ ] AAA構造が明確
- [ ] 境界値・異常系がカバーされている
- [ ] 実装詳細ではなく振る舞いをテスト
- [ ] モックは外部I/Oに限定されている
- [ ] リファクタリングで設計が改善された
