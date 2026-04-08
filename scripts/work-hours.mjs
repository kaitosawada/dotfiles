#!/usr/bin/env node

import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import { createInterface } from "node:readline";

const HISTORY_PATH = join(homedir(), ".claude", "history.jsonl");
const TOKEN_PATH = join(homedir(), ".claude", "freee-token.json");
const JST_OFFSET = 9 * 60 * 60 * 1000;
const DAY_BOUNDARY_HOUR = 5;
const BREAK_HOURS = 1;
const FIXED_START_HOUR = 10;
const FIXED_START_MIN = 0;

const FREEE_CLIENT_ID = process.env.FREEE_CLIENT_ID;
const FREEE_CLIENT_SECRET = process.env.FREEE_CLIENT_SECRET;
const FREEE_REDIRECT_URI = "urn:ietf:wg:oauth:2.0:oob";
const FREEE_AUTH_URL = "https://accounts.secure.freee.co.jp/public_api/authorize";
const FREEE_TOKEN_URL = "https://accounts.secure.freee.co.jp/public_api/token";
const FREEE_API_BASE = "https://api.freee.co.jp/hr";

// 日本の祝日 (2025-2027)
const HOLIDAYS = new Set([
  "2025-01-01","2025-01-13","2025-02-11","2025-02-23","2025-02-24",
  "2025-03-20","2025-04-29","2025-05-03","2025-05-04","2025-05-05",
  "2025-05-06","2025-07-21","2025-08-11","2025-09-15","2025-09-23",
  "2025-10-13","2025-11-03","2025-11-23","2025-11-24",
  "2026-01-01","2026-01-12","2026-02-11","2026-02-23","2026-03-20",
  "2026-04-29","2026-05-03","2026-05-04","2026-05-05","2026-05-06",
  "2026-07-20","2026-08-11","2026-09-21","2026-09-22","2026-09-23",
  "2026-10-12","2026-11-03","2026-11-23",
  "2027-01-01","2027-01-11","2027-02-11","2027-02-23","2027-03-21",
  "2027-03-22","2027-04-29","2027-05-03","2027-05-04","2027-05-05",
  "2027-07-19","2027-08-11","2027-09-20","2027-09-23","2027-10-11",
  "2027-11-03","2027-11-23",
]);

function isWeekendOrHoliday(dateStr) {
  if (HOLIDAYS.has(dateStr)) return true;
  const [y, m, d] = dateStr.split("-").map(Number);
  const dow = new Date(Date.UTC(y, m - 1, d)).getUTCDay();
  return dow === 0 || dow === 6;
}

function parseArgs() {
  const args = process.argv.slice(2);
  let month = null;
  let mode = "show";
  for (let i = 0; i < args.length; i++) {
    if (args[i] === "--month" && args[i + 1]) month = args[i + 1];
    if (args[i] === "--auth") mode = "auth";
    if (args[i] === "--sync") mode = "sync";
  }
  if (!month) {
    const now = new Date(Date.now() + JST_OFFSET);
    month = `${now.getUTCFullYear()}-${String(now.getUTCMonth() + 1).padStart(2, "0")}`;
  }
  return { month, mode };
}

function toJST(timestamp) {
  return new Date(timestamp + JST_OFFSET);
}

function getWorkDate(timestamp) {
  const jst = toJST(timestamp);
  const hour = jst.getUTCHours();
  if (hour < DAY_BOUNDARY_HOUR) {
    const prev = new Date(jst.getTime() - 24 * 60 * 60 * 1000);
    return `${prev.getUTCFullYear()}-${String(prev.getUTCMonth() + 1).padStart(2, "0")}-${String(prev.getUTCDate()).padStart(2, "0")}`;
  }
  return `${jst.getUTCFullYear()}-${String(jst.getUTCMonth() + 1).padStart(2, "0")}-${String(jst.getUTCDate()).padStart(2, "0")}`;
}

function formatTime(timestamp) {
  const jst = toJST(timestamp);
  return `${String(jst.getUTCHours()).padStart(2, "0")}:${String(jst.getUTCMinutes()).padStart(2, "0")}`;
}

function formatDuration(ms) {
  const totalMinutes = Math.round(ms / 60000);
  const h = Math.floor(totalMinutes / 60);
  const m = totalMinutes % 60;
  return `${h}h${String(m).padStart(2, "0")}m`;
}

function prompt(question) {
  const rl = createInterface({ input: process.stdin, output: process.stdout });
  return new Promise((resolve) => rl.question(question, (ans) => { rl.close(); resolve(ans.trim()); }));
}

// --- Work record calculation ---

function calcWorkRecords(month) {
  const lines = readFileSync(HISTORY_PATH, "utf-8").trim().split("\n");
  const dayMap = new Map();

  for (const line of lines) {
    let entry;
    try { entry = JSON.parse(line); } catch { continue; }
    if (!entry.timestamp) continue;
    const workDate = getWorkDate(entry.timestamp);
    if (!workDate.startsWith(month)) continue;
    if (!dayMap.has(workDate)) {
      dayMap.set(workDate, { first: entry.timestamp, last: entry.timestamp });
    } else {
      const day = dayMap.get(workDate);
      if (entry.timestamp < day.first) day.first = entry.timestamp;
      if (entry.timestamp > day.last) day.last = entry.timestamp;
    }
  }

  return [...dayMap.entries()]
    .filter(([date]) => !isWeekendOrHoliday(date))
    .sort((a, b) => a[0].localeCompare(b[0]))
    .map(([date, { first, last }]) => {
      const [y, m, d] = date.split("-").map(Number);
      const fixedStartMs = Date.UTC(y, m - 1, d, FIXED_START_HOUR - 9, FIXED_START_MIN);
      const effectiveStart = Math.min(first, fixedStartMs);
      return { date, effectiveStart, last };
    });
}

function printRecords(month, records) {
  if (records.length === 0) {
    console.log(`${month} のデータがありません`);
    return;
  }

  console.log(`\n  ${month} 勤務時間（Claude Code履歴より）\n`);
  console.log(
    "  " + "日付".padEnd(12) + "出勤".padEnd(8) + "退勤".padEnd(8) + "実働".padEnd(10) + "備考"
  );
  console.log("  " + "─".repeat(50));

  let totalWorkMs = 0;
  for (const { date, effectiveStart, last } of records) {
    const rawDuration = last - effectiveStart;
    const workDuration = Math.max(rawDuration - BREAK_HOURS * 3600000, 0);
    totalWorkMs += workDuration;
    const lastJstHour = toJST(last).getUTCHours();
    const notes = [];
    if (lastJstHour < 19 && lastJstHour >= DAY_BOUNDARY_HOUR) notes.push(`退勤${lastJstHour}時`);
    if (lastJstHour >= 0 && lastJstHour < DAY_BOUNDARY_HOUR) notes.push(`深夜${lastJstHour}時`);
    console.log(
      "  " + date.padEnd(12) + formatTime(effectiveStart).padEnd(8) + formatTime(last).padEnd(8) +
      formatDuration(workDuration).padEnd(10) + (notes.length > 0 ? `⚠ ${notes.join(", ")}` : "")
    );
  }
  console.log("  " + "─".repeat(50));
  console.log(`  合計: ${records.length}日  ${formatDuration(totalWorkMs)}  (平均 ${formatDuration(totalWorkMs / records.length)}/日)\n`);
}

// --- freee OAuth ---

async function authFlow() {
  if (!FREEE_CLIENT_ID || !FREEE_CLIENT_SECRET) {
    console.error("FREEE_CLIENT_ID と FREEE_CLIENT_SECRET を環境変数に設定してください");
    process.exit(1);
  }

  const authUrl = `${FREEE_AUTH_URL}?response_type=code&client_id=${FREEE_CLIENT_ID}&redirect_uri=${encodeURIComponent(FREEE_REDIRECT_URI)}&prompt=select_company`;
  console.log("\n以下のURLをブラウザで開いて認可してください:\n");
  console.log(`  ${authUrl}\n`);

  const code = await prompt("認可コードを入力: ");

  const res = await fetch(FREEE_TOKEN_URL, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      grant_type: "authorization_code",
      client_id: FREEE_CLIENT_ID,
      client_secret: FREEE_CLIENT_SECRET,
      code,
      redirect_uri: FREEE_REDIRECT_URI,
    }),
  });

  if (!res.ok) {
    console.error("トークン取得失敗:", await res.text());
    process.exit(1);
  }

  const token = await res.json();
  token.obtained_at = Date.now();
  writeFileSync(TOKEN_PATH, JSON.stringify(token, null, 2));
  console.log(`\nトークンを保存しました: ${TOKEN_PATH}`);
  console.log(`company_id: ${token.company_id}`);
  console.log("次に --sync で勤怠を登録できます\n");
}

async function getAccessToken() {
  if (!existsSync(TOKEN_PATH)) {
    console.error("トークンがありません。先に --auth で認証してください");
    process.exit(1);
  }
  if (!FREEE_CLIENT_ID || !FREEE_CLIENT_SECRET) {
    console.error("FREEE_CLIENT_ID と FREEE_CLIENT_SECRET を環境変数に設定してください");
    process.exit(1);
  }

  const token = JSON.parse(readFileSync(TOKEN_PATH, "utf-8"));
  const expiresAt = token.obtained_at + token.expires_in * 1000;

  if (Date.now() < expiresAt - 300000) {
    return token;
  }

  console.log("トークンをリフレッシュ中...");
  const res = await fetch(FREEE_TOKEN_URL, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      grant_type: "refresh_token",
      client_id: FREEE_CLIENT_ID,
      client_secret: FREEE_CLIENT_SECRET,
      refresh_token: token.refresh_token,
    }),
  });

  if (!res.ok) {
    console.error("リフレッシュ失敗:", await res.text());
    console.error("--auth で再認証してください");
    process.exit(1);
  }

  const newToken = await res.json();
  newToken.obtained_at = Date.now();
  newToken.company_id = newToken.company_id || token.company_id;
  writeFileSync(TOKEN_PATH, JSON.stringify(newToken, null, 2));
  return newToken;
}

// --- freee API ---

async function freeeRequest(method, path, token, body) {
  const url = `${FREEE_API_BASE}${path}`;
  const opts = {
    method,
    headers: { Authorization: `Bearer ${token.access_token}` },
  };
  if (body) {
    opts.headers["Content-Type"] = "application/json";
    opts.body = JSON.stringify(body);
  }
  const res = await fetch(url, opts);
  const contentType = res.headers.get("content-type") || "";
  if (!res.ok) {
    const text = await res.text();
    throw new Error(`${method} ${path} failed: ${res.status} ${text.slice(0, 200)}`);
  }
  if (!contentType.includes("application/json")) {
    const text = await res.text();
    throw new Error(`${method} ${path}: expected JSON but got ${contentType}: ${text.slice(0, 200)}`);
  }
  return res.json();
}

async function freeeGet(path, token) {
  return freeeRequest("GET", path, token);
}

async function freeePut(path, body, token) {
  return freeeRequest("PUT", path, token, body);
}

async function getEmployeeId(token) {
  const data = await freeeGet("/api/v1/users/me", token);
  const companies = data.companies || [];
  const company = companies.find((c) => c.id === token.company_id);
  if (!company) {
    console.error("company_idに対応する従業員情報が見つかりません");
    console.error("利用可能な事業所:", companies.map((c) => `${c.id}: ${c.name}`).join(", "));
    process.exit(1);
  }
  return company.employee_id;
}

function toFreeeDateTime(timestamp) {
  const jst = toJST(timestamp);
  const y = jst.getUTCFullYear();
  const mo = String(jst.getUTCMonth() + 1).padStart(2, "0");
  const d = String(jst.getUTCDate()).padStart(2, "0");
  const h = String(jst.getUTCHours()).padStart(2, "0");
  const mi = String(jst.getUTCMinutes()).padStart(2, "0");
  return `${y}-${mo}-${d} ${h}:${mi}`;
}

async function syncToFreee(month, records) {
  const token = await getAccessToken();
  const employeeId = await getEmployeeId(token);
  const companyId = token.company_id;

  console.log(`\nemployee_id: ${employeeId}, company_id: ${companyId}`);

  printRecords(month, records);

  const answer = await prompt("上記の勤怠をfreeeに登録しますか？ (y/N): ");
  if (answer.toLowerCase() !== "y") {
    console.log("キャンセルしました");
    return;
  }

  let success = 0;
  let failed = 0;
  for (const { date, effectiveStart, last } of records) {
    const clockIn = toFreeeDateTime(effectiveStart);
    const clockOut = toFreeeDateTime(last);

    // 休憩: 出勤から3時間後に1時間
    const breakStartMs = effectiveStart + 3 * 3600000;
    const breakEndMs = breakStartMs + BREAK_HOURS * 3600000;
    const breakIn = toFreeeDateTime(breakStartMs);
    const breakOut = toFreeeDateTime(breakEndMs);

    const body = {
      company_id: companyId,
      clock_in_at: clockIn,
      clock_out_at: clockOut,
      break_records: [
        { clock_in_at: breakIn, clock_out_at: breakOut },
      ],
    };

    try {
      await freeePut(`/api/v1/employees/${employeeId}/work_records/${date}`, body, token);
      console.log(`  ✓ ${date}  ${formatTime(effectiveStart)} - ${formatTime(last)}`);
      success++;
    } catch (e) {
      console.error(`  ✗ ${date}  ${e.message}`);
      failed++;
    }
  }

  console.log(`\n完了: ${success}件成功, ${failed}件失敗\n`);
}

// --- main ---

async function main() {
  const { month, mode } = parseArgs();

  if (mode === "auth") {
    await authFlow();
    return;
  }

  const records = calcWorkRecords(month);

  if (mode === "sync") {
    await syncToFreee(month, records);
  } else {
    printRecords(month, records);
  }
}

main();
