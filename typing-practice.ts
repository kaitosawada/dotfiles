#!/usr/bin/env -S deno run --allow-read

const chars = ["う", "き", "は", "か", "と", "た"];

function generateRandomText(length: number): string {
  let result = "";
  for (let i = 0; i < length; i++) {
    const randomIndex = Math.floor(Math.random() * chars.length);
    result += chars[randomIndex];
  }
  return result;
}

async function readLine(): Promise<string> {
  const buf = new Uint8Array(1024);
  const n = await Deno.stdin.read(buf);
  if (n === null) {
    Deno.exit(0);
  }
  return new TextDecoder().decode(buf.subarray(0, n)).trim();
}

console.log("独自日本語配列タイピング練習");
console.log("対象文字: うきはかとた");
console.log("Ctrl+C で終了\n");

let correctCount = 0;
let totalCount = 0;

while (true) {
  const target = generateRandomText(4);
  console.log(`\n問題: ${target}`);

  const input = await readLine();

  totalCount++;

  if (input === target) {
    console.log("✓ 正解!");
    correctCount++;
  } else {
    console.log(`✗ 不正解 (正解: ${target})`);
  }

  const accuracy = ((correctCount / totalCount) * 100).toFixed(1);
  console.log(`正解率: ${correctCount}/${totalCount} (${accuracy}%)`);
}
