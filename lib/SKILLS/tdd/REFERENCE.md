# t.wada流 TDD - Reference Guide（TypeScript / Vitest）

テストデザインパターン、Vitest コマンド、モック、テンプレートの詳細リファレンス。

## Table of Contents

- [Test Design Patterns](#test-design-patterns)
- [Test Structure Template](#test-structure-template)
- [Mocking](#mocking)
- [React コンポーネント](#react-コンポーネント)
- [Hono ルートハンドラ](#hono-ルートハンドラ)
- [Commands](#commands)
- [Vitest Configuration](#vitest-configuration)
- [Additional Resources](#additional-resources)

---

## Test Design Patterns

### 境界値分析（Boundary Value Analysis）

境界値とその前後をテストすることで、エッジケースを見つける手法。

```ts
import { describe, expect, it } from "vitest";
import { validateAge } from "./validate-age";

describe("validateAge", () => {
  it("最小値(0)は有効", () => expect(validateAge(0)).toBe(true));
  it("最小値の1つ下(-1)は無効", () => expect(validateAge(-1)).toBe(false));
  it("最大値(120)は有効", () => expect(validateAge(120)).toBe(true));
  it("最大値の1つ上(121)は無効", () => expect(validateAge(121)).toBe(false));
});
```

#### 配列の境界

```ts
it("空の配列", () => expect(process([])).toEqual([]));
it("1要素の配列", () => expect(process([1])).toEqual([1]));
it("2要素の配列", () => expect(process([1, 2])).toEqual([1, 2]));
```

#### 文字列の境界

```ts
it("空文字", () => expect(process("")).toBe(""));
it("1文字", () => expect(process("a")).toBe("a"));
it("最大長", () => expect(process("a".repeat(100))).toHaveLength(100));
it("最大長+1で例外", () => expect(() => process("a".repeat(101))).toThrow());
```

### 等価クラス分割（Equivalence Partitioning）

入力空間を等価クラスに分割し、各クラスから代表値を選んでテスト。

```ts
// 有効な年齢の代表値
it("有効な年齢_子供", () => expect(validateAge(10)).toBe(true)); // 0-17 の代表値
it("有効な年齢_大人", () => expect(validateAge(30)).toBe(true)); // 18-120 の代表値

// 無効な年齢の代表値
it("無効な年齢_負の数", () => expect(validateAge(-5)).toBe(false));
it("無効な年齢_超過", () => expect(validateAge(150)).toBe(false));
```

### テーブル駆動テスト（`it.each`）

同じ振る舞いを複数の入力で確かめるときは `it.each` を使う（重複を避け、追加が容易）。

```ts
import { describe, expect, it } from "vitest";

describe("square", () => {
  it.each([
    [0, 0],
    [1, 1],
    [2, 4],
    [3, 9],
    [-2, 4],
  ])("square(%i) は %i", (input, expected) => {
    expect(square(input)).toBe(expected);
  });
});

// 名前付きケース
it.each([
  { label: "最小値", age: 0, expected: true },
  { label: "中間値", age: 50, expected: true },
  { label: "最大値", age: 120, expected: true },
  { label: "負の数", age: -1, expected: false },
  { label: "超過", age: 121, expected: false },
])("年齢検証: $label", ({ age, expected }) => {
  expect(validateAge(age)).toBe(expected);
});
```

### 状態遷移テスト

状態を持つオブジェクトの遷移をテスト。

```ts
import { describe, expect, it } from "vitest";
import { Order, InvalidStateTransitionError } from "./order";

describe("Order", () => {
  it("初期状態は pending", () => {
    expect(new Order().status).toBe("pending");
  });

  it("confirm で confirmed になる", () => {
    const order = new Order();
    order.confirm();
    expect(order.status).toBe("confirmed");
  });

  it("confirm せずに ship はできない", () => {
    const order = new Order();
    expect(() => order.ship()).toThrow(InvalidStateTransitionError);
  });
});
```

### 例外のテスト

```ts
// 基本パターン
it("不正な入力で例外", () => {
  expect(() => parseDate("invalid")).toThrow();
});

// 例外メッセージの検証
it("不正な入力で例外_メッセージ確認", () => {
  expect(() => parseDate("invalid")).toThrow("日付形式が不正");
});

// 特定の例外クラス
it("ファイルが存在しない", () => {
  expect(() => readFile("nonexistent.txt")).toThrow(FileNotFoundError);
});
```

### 非同期のテスト

```ts
// 成功
it("ユーザーを取得できる", async () => {
  await expect(fetchUser("123")).resolves.toEqual({ id: "123" });
});

// 失敗（rejects）
it("存在しないユーザーで例外", async () => {
  await expect(fetchUser("missing")).rejects.toThrow("not found");
});

// タイマー
it("3秒後にタイムアウトする", async () => {
  vi.useFakeTimers();
  const promise = withTimeout(task, 3000);
  vi.advanceTimersByTime(3000);
  await expect(promise).rejects.toThrow("timeout");
  vi.useRealTimers();
});
```

> 非同期のアサーションは `expect(promise).resolves/rejects` を使う。`await` を忘れるとテストが常にパスするので注意。

---

## Test Structure Template

### 基本テンプレート

```ts
import { describe, expect, it } from "vitest";
import { TargetClass } from "./target-class";

describe("TargetClass", () => {
  // ========== 正常系 ==========

  it("基本的な使用方法", () => {
    // Arrange
    const target = new TargetClass();

    // Act
    const result = target.doSomething("input");

    // Assert
    expect(result).toBe("expected");
  });

  // ========== 境界値 ==========

  it("空入力", () => {
    const target = new TargetClass();
    expect(target.doSomething("")).toBe("");
  });

  it("最大長入力", () => {
    const target = new TargetClass();
    expect(target.doSomething("a".repeat(1000))).toHaveLength(1000);
  });

  // ========== 異常系 ==========

  it("不正入力で例外", () => {
    const target = new TargetClass();
    expect(() => target.doSomething(undefined)).toThrow();
  });
});
```

### セットアップと後始末（`beforeEach` / `afterEach`）

```ts
import { afterEach, beforeEach, describe, expect, it } from "vitest";

describe("UserRepository", () => {
  let repo: UserRepository;

  beforeEach(() => {
    repo = new UserRepository({ inMemory: true });
  });

  afterEach(() => {
    repo.cleanup();
  });

  it("保存して取得できる", () => {
    const user = { id: "test-123", name: "Test User" };
    repo.save(user);
    expect(repo.get(user.id)).toEqual(user);
  });

  it("存在しないユーザーは undefined", () => {
    expect(repo.get("nonexistent-id")).toBeUndefined();
  });
});
```

### テストデータのファクトリ（ヘルパー）

テストごとに必要な最小データだけを渡せるようにする。オブジェクトリテラルの散在を防ぐ。

```ts
type Row = { id: string; category: string; subcategory: string };

const row = (id: string, category = "A", subcategory = "a1"): Row => ({
  id,
  category,
  subcategory,
});

const ids = (rows: Row[]) => rows.map((r) => r.id);

it("下へ動かすと移動先の位置に入る", () => {
  const rows = [row("1"), row("2"), row("3")];
  expect(ids(moveItem(rows, (r) => r.id, "1", "2"))).toEqual(["2", "1", "3"]);
});
```

---

## Mocking

Vitest のモック API。**外部I/Oだけをモックする**のが原則。

### `vi.fn`（モック関数）

```ts
import { expect, it, vi } from "vitest";

it("コールバックが呼ばれる", () => {
  const onSave = vi.fn();
  save({ name: "Alice" }, onSave);
  expect(onSave).toHaveBeenCalledOnce();
  expect(onSave).toHaveBeenCalledWith({ name: "Alice" });
});
```

### `vi.mock`（モジュールのモック）

リポジトリや外部サービスのモジュールを差し替える。

```ts
import { beforeEach, describe, expect, it, vi } from "vitest";

const { homepageMock } = vi.hoisted(() => ({
  homepageMock: {
    findById: vi.fn(),
    renameQuestionCategories: vi.fn(),
  },
}));

vi.mock("../../lib/repositories/homepage", () => ({
  homepageRepository: homepageMock,
}));

describe("PATCH /categories", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    homepageMock.findById.mockResolvedValue({ id: 7, organizationId: 4 });
  });

  it("from と to を渡すと一括リネームする", async () => {
    // ...
    expect(homepageMock.renameQuestionCategories).toHaveBeenCalledWith(7, [
      { from: "A", to: "B" },
    ]);
  });
});
```

> `vi.mock` は巻き上げ（hoist）されるため、ファクトリが参照する変数は `vi.hoisted` で定義する。

### `vi.spyOn`（既存オブジェクトの一部だけ差し替え）

```ts
import { afterEach, expect, it, vi } from "vitest";

afterEach(() => vi.restoreAllMocks());

it("送信に失敗したらログを出す", async () => {
  const spy = vi.spyOn(mailer, "send").mockRejectedValue(new Error("boom"));
  await sendNotification();
  expect(spy).toHaveBeenCalled();
});
```

### モックの境界（判断基準）

| 対象 | 方針 |
| ---- | ---- |
| 純関数・計算・整形 | モックしない（実物を呼ぶ） |
| DB / リポジトリ | モックする |
| 外部API（メール・AI・ストレージ） | モックする |
| 時刻・乱数 | `vi.useFakeTimers()` / `vi.setSystemTime()` |

- `toHaveBeenCalledWith` は**下位への契約**を確かめるときだけ使う。内部の呼び出し順・回数はリファクタで壊れやすいので目的化しない。
- モックが増えすぎたら、テストではなく設計（依存の持ち方・関数の分割）を見直す。

---

## React コンポーネント

`@testing-library/react` で「ユーザーから見た振る舞い」をテストする。実装（state 変数名・内部関数）ではなく、表示と操作を検証する。

```ts
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it, vi } from "vitest";
import { SaveButton } from "./save-button";

describe("SaveButton", () => {
  it("クリックすると onSave が呼ばれる", async () => {
    const onSave = vi.fn();
    const user = userEvent.setup();

    render(<SaveButton onSave={onSave} />);

    await user.click(screen.getByRole("button", { name: "保存" }));

    expect(onSave).toHaveBeenCalledOnce();
  });

  it("保存中は非活性になる", () => {
    render(<SaveButton onSave={vi.fn()} disabled />);
    expect(screen.getByRole("button", { name: "保存" })).toBeDisabled();
  });
});
```

- クエリは `getByRole` / `getByLabelText` を優先（実装に依存しにくい）。
- `userEvent` を使う（`fireEvent` より実際の操作に近い）。
- 実装詳細を確かめたいときだけ `container` や `data-testid` を使う。

---

## Hono ルートハンドラ

ハンドラを直接呼ばず、**実ルーターに HTTP リクエストを通す**。リポジトリなど外部I/Oだけモックする。

```ts
import { Hono } from "hono";
import { beforeEach, describe, expect, it, vi } from "vitest";

const { orgMock } = vi.hoisted(() => ({
  orgMock: { findById: vi.fn(), update: vi.fn() },
}));
vi.mock("../../lib/repositories/organization", () => ({
  organizationRepository: orgMock,
}));

const { default: router } = await import("./organizations");

const app = new Hono();
app.route("/organizations", router);

describe("PUT /organizations/:id", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    orgMock.findById.mockResolvedValue({ id: 4, displayName: "サンプル健保" });
  });

  it("有効な insurerNumber を保存する", async () => {
    const res = await app.request("/organizations/4", {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ displayName: "サンプル健保", insurerNumber: "12345678" }),
    });

    expect(res.status).toBe(200);
    expect(orgMock.update).toHaveBeenCalledWith(4, expect.objectContaining({
      insurerNumber: "12345678",
    }));
  });

  it("不正な insurerNumber は 400", async () => {
    const res = await app.request("/organizations/4", {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ displayName: "サンプル健保", insurerNumber: "123456789" }),
    });

    expect(res.status).toBe(400);
    expect(orgMock.update).not.toHaveBeenCalled();
  });
});
```

> ステータスコードとレスポンス本文で「外から見た振る舞い」を確かめる。リポジトリへの引数検証は契約の範囲にとどめる。

---

## Commands

### 基本的なテスト実行

```bash
# すべてのテストを実行（1回）
npx vitest run

# 特定ファイル
npx vitest run src/lib/sort.test.ts

# 名前でフィルタ（部分一致）
npx vitest run -t "空のリスト"

# Watch モード
npx vitest

# Vite+ モノレポ
vp test
vp test --root admin-hono
vp test --root admin-hono -t "空のリスト"
```

### 失敗への対応

```bash
# 失敗したテストで停止
npx vitest run --bail=1

# 最後に失敗したテストだけ再実行
npx vitest run --changed
```

### カバレッジ

```bash
# カバレッジ付き
npx vitest run --coverage

# HTML レポート
npx vitest run --coverage --coverage.reporter=html
```

### デバッグ

```bash
# 詳細レポート（ファイル単位）
npx vitest run --reporter=verbose

# 対象ファイルだけ watch
npx vitest src/lib/sort.test.ts
```

---

## Vitest Configuration

### vite.config.ts（test ブロック）

```ts
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    environment: "node", // React をテストする場合は "jsdom"
    globals: false, // describe/it/expect を import する場合は false
    clearMocks: true, // 各テスト前にモックをクリア
    include: ["src/**/*.{test,spec}.{ts,tsx}"],
    coverage: {
      provider: "v8",
      reporter: ["text", "html"],
      include: ["src/**"],
      exclude: ["src/**/*.test.{ts,tsx}", "src/**/*.d.ts"],
      thresholds: { lines: 80, functions: 80, branches: 70 },
    },
  },
});
```

### React をテストする場合

```ts
test: {
  environment: "jsdom",
  setupFiles: ["./src/test/setup.ts"],
}
```

```ts
// src/test/setup.ts
import "@testing-library/jest-dom/vitest";
```

---

## Additional Resources

- [Vitest 公式ドキュメント](https://vitest.dev/)
- [Vitest: Mocking](https://vitest.dev/guide/mocking)
- [Testing Library](https://testing-library.com/docs/react-testing-library/intro/)
- [Hono: Testing](https://hono.dev/docs/guides/testing)
- [t.wadaのTDD講演資料](https://t-wada.hatenablog.jp/)
