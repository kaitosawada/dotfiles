# t.wada流 TDD - Practical Examples（TypeScript / Vitest）

実用的なTDD例、AAA構造、アンチパターンの詳細。

## Table of Contents

- [Complete TDD Example](#complete-tdd-example)
- [AAA Pattern Examples](#aaa-pattern-examples)
- [Anti-Patterns](#anti-patterns)
- [Real-World Scenarios](#real-world-scenarios)

---

## Complete TDD Example

### シナリオ: 数値リストのソート関数

要件: 数値のリストを昇順でソートする関数を実装

#### Step 1: テストケースリスト作成

```
□ 空のリストを渡すと空のリストを返す
□ 1要素のリストはそのまま返す
□ 2要素の降順リストを昇順に並び替える
□ 複数要素をソートする
□ 重複要素を正しく処理する
□ 負の数を含んでもソートできる
```

#### Step 2: 🔴 Red - 最初のテスト

```ts
// src/sort.test.ts
import { describe, expect, it } from "vitest";
import { sortNumbers } from "./sort";

describe("sortNumbers", () => {
  it("空のリストを渡すと空のリストを返す", () => {
    // Arrange
    const input: number[] = [];

    // Act
    const result = sortNumbers(input);

    // Assert
    expect(result).toEqual([]);
  });
});
```

**実行**: `npx vitest run src/sort.test.ts`
```
FAIL  src/sort.test.ts > sortNumbers > 空のリストを渡すと空のリストを返す
Error: Failed to resolve import "./sort" ... does it exist?
```
✅ 失敗を確認！（未実装なので落ちている）

#### Step 3: 🟢 Green - 最小実装

```ts
// src/sort.ts
export function sortNumbers(numbers: number[]): number[] {
  return []; // 仮実装: 常に空配列を返す
}
```

**実行**: `npx vitest run src/sort.test.ts`
```
PASS  src/sort.test.ts (1 test)
```
✅ テスト通過！

#### Step 4: 🔵 Refactor

このステップでは特に改善点なし。次のテストへ。

---

#### Step 5: 🔴 Red - 2つ目のテスト

```ts
it("1要素のリストはそのまま返す", () => {
  // Arrange
  const input = [42];

  // Act
  const result = sortNumbers(input);

  // Assert
  expect(result).toEqual([42]);
});
```

**実行**: `npx vitest run`
```
FAIL  expected [] to deeply equal [ 42 ]
```
✅ 失敗を確認！

#### Step 6: 🟢 Green - 実装改善

```ts
export function sortNumbers(numbers: number[]): number[] {
  if (numbers.length === 0) return [];
  return numbers; // 1要素の場合はそのまま返す
}
```

**実行**: `npx vitest run`
```
PASS (2 tests)
```
✅ すべてのテスト通過！

---

#### Step 7: 🔴 Red - 3つ目のテスト

```ts
it("2要素の降順リストを昇順に並び替える", () => {
  // Arrange
  const input = [2, 1];

  // Act
  const result = sortNumbers(input);

  // Assert
  expect(result).toEqual([1, 2]);
});
```

**実行**: `npx vitest run`
```
FAIL  expected [ 2, 1 ] to deeply equal [ 1, 2 ]
```
✅ 失敗を確認！

#### Step 8: 🟢 Green - 本格実装

```ts
export function sortNumbers(numbers: number[]): number[] {
  return [...numbers].sort((a, b) => a - b);
}
```

**実行**: `npx vitest run`
```
PASS (3 tests)
```
✅ すべてのテスト通過！

> 元配列を破壊しないよう `[...numbers]` でコピーしている。破壊的かどうかも必要ならテストで固定する。

---

#### Step 9: 🔵 Refactor

残りのテストを追加（`it.each` でテーブル化してもよい）。

```ts
it("複数要素をソートする", () => {
  expect(sortNumbers([5, 2, 8, 1, 9])).toEqual([1, 2, 5, 8, 9]);
});

it("重複要素を正しく処理する", () => {
  expect(sortNumbers([3, 1, 2, 1, 3])).toEqual([1, 1, 2, 3, 3]);
});

it("負の数を含んでもソートできる", () => {
  expect(sortNumbers([-5, 3, -1, 0, 2])).toEqual([-5, -1, 0, 2, 3]);
});
```

**実行**: `npx vitest run`
```
PASS (6 tests)
```
✅ すべてのテスト通過！TDD完了！

---

## AAA Pattern Examples

### Arrange-Act-Assert（AAA）構造

#### Good Example ✅

```ts
it("ユーザー作成", async () => {
  // Arrange（準備）: テストデータとオブジェクトの準備
  const userData = { name: "Alice", email: "alice@example.com" };
  const userService = new UserService();

  // Act（実行）: テスト対象の操作を実行
  const user = await userService.createUser(userData);

  // Assert（検証）: 結果を検証
  expect(user.name).toBe("Alice");
  expect(user.email).toBe("alice@example.com");
  expect(user.id).toBeDefined();
});
```

**ポイント**:
- 各ブロックが明確に分離されている
- コメントで Arrange-Act-Assert を明示
- 1つの Act ブロックのみ

#### Bad Example ❌

```ts
it("ユーザー作成", async () => {
  // AAA構造が不明瞭
  const userService = new UserService();
  const user = await userService.createUser({ name: "Alice" });
  expect(user.name).toBe("Alice");
  const another = await userService.createUser({ name: "Bob" }); // 複数のAct
  expect(another.name).toBe("Bob");
});
```

**問題点**:
- AAA構造が不明瞭
- 複数の振る舞いをテスト（Actが2回）
- テストが何を検証したいのか不明確

---

### AAA with `beforeEach`

```ts
import { beforeEach, describe, expect, it } from "vitest";

describe("UserService", () => {
  let userService: UserService;
  let validUserData: { name: string; email: string };

  beforeEach(() => {
    // Arrange: 各テストで使う前提を準備
    userService = new UserService({ db: new InMemoryDB() });
    validUserData = { name: "Alice", email: "alice@example.com" };
  });

  it("ユーザー作成", async () => {
    // Act
    const user = await userService.createUser(validUserData);

    // Assert
    expect(user.name).toBe(validUserData.name);
    expect(user.email).toBe(validUserData.email);
  });
});
```

---

## Anti-Patterns

### ❌ Anti-Pattern 1: 実装詳細をテストする

#### Bad Example

```ts
class UserService {
  private cache = new Map<string, User>(); // 内部キャッシュ

  async getUser(userId: string): Promise<User> {
    if (this.cache.has(userId)) return this.cache.get(userId)!;
    const user = await this.fetchFromDb(userId);
    this.cache.set(userId, user);
    return user;
  }
}

// ❌ 悪い例: 内部実装に依存
it("キャッシュが更新される", async () => {
  const service = new UserService();
  await service.getUser("123");
  expect((service as any).cache.has("123")).toBe(true); // private に依存！
});
```

**問題点**: 内部実装（`cache`）に依存しているため、実装変更に脆弱。

#### Good Example ✅

```ts
// ✅ 良い例: 振る舞いをテスト
it("同じユーザーを2回取得しても同じ結果", async () => {
  // Arrange
  const service = new UserService();

  // Act
  const user1 = await service.getUser("123");
  const user2 = await service.getUser("123");

  // Assert
  expect(user1).toEqual(user2); // 振る舞いのみテスト
});
```

---

### ❌ Anti-Pattern 2: テスト間の依存

#### Bad Example

```ts
// ❌ 悪い例: モジュールスコープで状態を共有
let counter = 0;

it("カウンターを増やす", () => {
  counter += 1;
  expect(counter).toBe(1);
});

it("カウンターを2回増やす", () => {
  counter += 1; // 前のテストの後に実行される前提
  expect(counter).toBe(2); // 前のテストに依存！
});
```

**問題点**:
- テストの実行順序に依存
- 個別に実行できない（`-t` で片方だけ動かすと壊れる）
- デバッグが困難

#### Good Example ✅

```ts
// ✅ 良い例: 各テストが独立
it("カウンターを増やす", () => {
  const counter = new Counter();
  counter.increment();
  expect(counter.value).toBe(1);
});

it("カウンターを2回増やす", () => {
  const counter = new Counter();
  counter.increment();
  counter.increment();
  expect(counter.value).toBe(2);
});
```

---

### ❌ Anti-Pattern 3: 過度なモック

#### Bad Example

```ts
// ❌ 悪い例: 全てをモック化
it("ユーザー登録処理", async () => {
  const mockValidator = vi.fn();
  const mockHasher = vi.fn();
  const mockDb = vi.fn();
  const mockEmail = vi.fn();
  const mockLogger = vi.fn();

  // テストが実装の詳細に依存しすぎている
  const service = new UserService({
    validator: mockValidator,
    hasher: mockHasher,
    db: mockDb,
    email: mockEmail,
    logger: mockLogger,
  });

  // ...複雑なモック設定が続く...
});
```

**問題点**: モックが多すぎてテストの意図が不明確。リファクタリングに脆弱。

#### Good Example ✅

```ts
// ✅ 良い例: 外部依存のみモック化
it("ユーザー登録処理", async () => {
  // Arrange
  const emailService = { sendWelcomeEmail: vi.fn() }; // 外部サービスのみモック
  const service = new UserService({ emailService });
  const userData = { name: "Alice", email: "alice@example.com" };

  // Act
  const user = await service.register(userData);

  // Assert
  expect(user.name).toBe("Alice");
  expect(emailService.sendWelcomeEmail).toHaveBeenCalledOnce();
});
```

---

### ❌ Anti-Pattern 4: 巨大なテスト

#### Bad Example

```ts
// ❌ 悪い例: 1つのテストで複数の振る舞いを検証
it("ユーザー管理", async () => {
  const user = await createUser("Alice");
  expect(user.name).toBe("Alice");

  await updateUser(user.id, { name: "Bob" });
  const updated = await getUser(user.id);
  expect(updated.name).toBe("Bob");

  await deleteUser(user.id);
  expect(await getUser(user.id)).toBeUndefined();
});
```

**問題点**:
- 複数の振る舞いをテスト
- どこで失敗したか分かりにくい
- テスト名から意図が不明

#### Good Example ✅

```ts
// ✅ 良い例: 1テスト1振る舞い
it("ユーザーを作成できる", async () => {
  const user = await createUser({ name: "Alice" });
  expect(user.name).toBe("Alice");
});

it("ユーザー名を更新できる", async () => {
  const user = await createUser({ name: "Alice" });
  await updateUser(user.id, { name: "Bob" });
  expect((await getUser(user.id)).name).toBe("Bob");
});

it("ユーザーを削除できる", async () => {
  const user = await createUser({ name: "Alice" });
  await deleteUser(user.id);
  expect(await getUser(user.id)).toBeUndefined();
});
```

---

### ❌ Anti-Pattern 5: 文字列化した構造への依存

#### Bad Example

```ts
// ❌ 悪い例: JSON 文字列の部分一致に依存
it("スキーマに候補値が載る", () => {
  const json = JSON.stringify(toJsonSchema(schema));
  expect(json).toContain('"textfield"');
  expect(json).not.toContain('"properties":{}');
});
```

**問題点**: 構造そのものではなくシリアライズ結果に依存するため、無害な整形変更でも壊れる。回帰防止の意図は分かるが、可能なら**構造をたどって**検証する。

#### Good Example ✅

```ts
// ✅ 良い例: 構造をたどって検証
it("スキーマに候補値が載る", () => {
  const json = toJsonSchema(schema) as { properties?: Record<string, unknown> };
  expect(json.properties?.component).toBeDefined();
  expect(json.properties).toHaveProperty("options");
});
```

> 文字列一致でしか守れない回帰（外部ツールの出力形式など）は、コメントで理由を残す。

---

## Real-World Scenarios

### シナリオ1: 電卓クラスのTDD

```ts
// ========== Test 1: 🔴 Red ==========
it("足し算", () => {
  // Arrange
  const calc = new Calculator();

  // Act
  const result = calc.add(2, 3);

  // Assert
  expect(result).toBe(5);
});

// ========== 🟢 Green ==========
class Calculator {
  add(a: number, b: number): number {
    return a + b;
  }
}

// ========== Test 2: 🔴 Red ==========
it("引き算", () => {
  expect(new Calculator().subtract(5, 3)).toBe(2);
});

// ========== 🟢 Green ==========
class Calculator {
  add(a: number, b: number): number {
    return a + b;
  }
  subtract(a: number, b: number): number {
    return a - b;
  }
}

// ========== Test 3: 🔴 Red ==========
// JS の 5 / 0 は Infinity になるため、明示的に例外を投げる仕様にする
it("ゼロ除算で例外", () => {
  expect(() => new Calculator().divide(5, 0)).toThrow("ゼロで除算できません");
});

// ========== 🟢 Green ==========
class Calculator {
  add(a: number, b: number): number {
    return a + b;
  }
  subtract(a: number, b: number): number {
    return a - b;
  }
  divide(a: number, b: number): number {
    if (b === 0) throw new Error("ゼロで除算できません");
    return a / b;
  }
}
```

---

### シナリオ2: バリデーションのTDD

```ts
// ========== 要件 ==========
// メールアドレスのバリデーション関数
// - @ を含む
// - ドメインがある
// - 空文字はNG

// ========== Test 1: 🔴 Red ==========
it("有効なメールアドレス", () => {
  // Arrange
  const email = "user@example.com";

  // Act
  const result = validateEmail(email);

  // Assert
  expect(result).toBe(true);
});

// ========== 🟢 Green ==========
function validateEmail(email: string): boolean {
  return email.includes("@") && email.split("@")[1]!.includes(".");
}

// ========== Test 2: 🔴 Red ==========
it("アットマークなしは無効", () => {
  expect(validateEmail("userexample.com")).toBe(false);
});

// ========== Test 3: 🔴 Red ==========
it("ドメインなしは無効", () => {
  expect(validateEmail("user@")).toBe(false);
});

// ========== 🟢 Green（エラー処理追加） ==========
function validateEmail(email: string): boolean {
  if (!email.includes("@")) return false;
  const parts = email.split("@");
  if (parts.length !== 2) return false;
  return parts[1]!.includes(".");
}

// ========== Test 4: 🔴 Red ==========
it("空文字は無効", () => {
  expect(validateEmail("")).toBe(false);
});

// ========== 🟢 Green ==========
function validateEmail(email: string): boolean {
  if (!email || !email.includes("@")) return false;
  const parts = email.split("@");
  if (parts.length !== 2) return false;
  return parts[1]!.includes(".");
}

// ========== 🔵 Refactor ==========
function validateEmail(email: string): boolean {
  if (!email) return false;

  const [local, domain, ...rest] = email.split("@");
  if (rest.length > 0) return false;
  if (!local || !domain) return false;
  if (!domain.includes(".")) return false;

  return true;
}
```

---

### シナリオ3: 状態を持つオブジェクトのTDD

```ts
// ========== 要件 ==========
// ショッピングカート
// - 商品を追加できる
// - 商品を削除できる
// - 合計金額を計算できる

// ========== Test 1: 🔴 Red ==========
it("空のカートの合計は0", () => {
  // Arrange
  const cart = new ShoppingCart();

  // Act
  const total = cart.getTotal();

  // Assert
  expect(total).toBe(0);
});

// ========== 🟢 Green ==========
class ShoppingCart {
  private items: { name: string; price: number }[] = [];

  getTotal(): number {
    return 0;
  }
}

// ========== Test 2: 🔴 Red ==========
it("商品を追加すると合計に反映される", () => {
  const cart = new ShoppingCart();

  cart.addItem("Apple", 100);

  expect(cart.getTotal()).toBe(100);
});

// ========== 🟢 Green ==========
class ShoppingCart {
  private items: { name: string; price: number }[] = [];

  addItem(name: string, price: number): void {
    this.items.push({ name, price });
  }

  getTotal(): number {
    return this.items.reduce((sum, item) => sum + item.price, 0);
  }
}

// ========== Test 3: 🔴 Red ==========
it("複数商品の合計", () => {
  const cart = new ShoppingCart();
  cart.addItem("Apple", 100);
  cart.addItem("Banana", 50);
  expect(cart.getTotal()).toBe(150);
});

// ========== Test 4: 🔴 Red ==========
it("商品を削除すると合計が減る", () => {
  const cart = new ShoppingCart();
  cart.addItem("Apple", 100);
  cart.addItem("Banana", 50);

  cart.removeItem("Apple");

  expect(cart.getTotal()).toBe(50);
});

// ========== 🟢 Green ==========
class ShoppingCart {
  private items: { name: string; price: number }[] = [];

  addItem(name: string, price: number): void {
    this.items.push({ name, price });
  }

  removeItem(name: string): void {
    this.items = this.items.filter((item) => item.name !== name);
  }

  getTotal(): number {
    return this.items.reduce((sum, item) => sum + item.price, 0);
  }
}
```

---

### シナリオ4: ルートハンドラを TDD で（Hono）

「外から見た振る舞い（ステータスコード・本文）」を先に決めてから実装する。

```ts
// ========== Test 1: 🔴 Red ==========
// src/routes/categories.test.ts
const res = await app.request("/organizations/4/homepage/questions/categories", {
  method: "PATCH",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ categories: [{ from: "A", to: "B" }] }),
});

expect(res.status).toBe(200);
expect(homepageMock.renameQuestionCategories).toHaveBeenCalledWith(7, [
  { from: "A", to: "B" },
]);
```

```ts
// ========== 🟢 Green ==========
app.patch("/organizations/:id/homepage/questions/categories", async (c) => {
  const orgId = Number(c.req.param("id"));
  const homepage = await homepageRepository.findByOrganizationId(orgId);
  if (!homepage) return c.json({ error: "not found" }, 404);

  const body = await c.req.json();
  const categories = normalizeCategories(body.categories); // "" → null
  await homepageRepository.renameQuestionCategories(homepage.id, categories);
  await auditLogRepository.record(/* ... */);
  return c.json({ ok: true });
});
```

```ts
// ========== Test 2: 🔴 Red（異常系） ==========
const res = await app.request("/organizations/4/homepage/questions/categories", {
  method: "PATCH",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ categories: [{ from: "A", to: "B" }, { from: "A", to: "C" }] }),
});

expect(res.status).toBe(400);
expect(homepageMock.renameQuestionCategories).not.toHaveBeenCalled();
```

```ts
// ========== 🟢 Green（バリデーション追加） ==========
const froms = categories.map((c) => c.from);
if (new Set(froms).size !== froms.length) {
  return c.json({ error: "from が重複しています" }, 400);
}
```

> ルートのテストは「リクエスト → ステータス + レスポンス + 下位への契約」で書く。ハンドラ内部の分岐は、必要なら純関数として切り出して単体テストする。

---

This completes the practical examples! これらの例で t.wada流TDD の実践方法が理解できるはずだよぅ。
