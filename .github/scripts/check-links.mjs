// 检查 Markdown 相对链接是否可解析；跳过代码块、锚点与外链。
import fs from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const skip = new Set(['.git', 'node_modules']);
const problems = [];

function strip(text) {
  const kept = [];
  let fence = false;
  for (const line of text.split('\n')) {
    if (line.trimStart().startsWith('```')) { fence = !fence; continue; }
    if (!fence) kept.push(line);
  }
  return kept.join('\n');
}

function check(file) {
  const text = strip(fs.readFileSync(file, 'utf8'));
  for (const m of text.matchAll(/\]\(([^)]+)\)/g)) {
    let t = m[1].trim();
    if (/^(https?:|mailto:|#|data:)/i.test(t)) continue;
    t = t.split('#')[0];
    if (!t) continue;
    if (t.startsWith('<') && t.endsWith('>')) t = t.slice(1, -1);
    try { t = decodeURIComponent(t); } catch {}
    const cands = [path.resolve(path.dirname(file), t), path.resolve(root, t)];
    if (cands.some((c) => fs.existsSync(c))) continue;
    problems.push(path.relative(root, file) + ' -> ' + m[1].trim());
  }
}

function walk(dir) {
  for (const item of fs.readdirSync(dir, { withFileTypes: true })) {
    if (skip.has(item.name)) continue;
    const p = path.join(dir, item.name);
    if (item.isDirectory()) walk(p);
    else if (item.name.endsWith('.md')) check(p);
  }
}

walk(root);
if (problems.length) {
  console.error('链接检查未通过：' + problems.length + ' 项');
  for (const p of problems) console.error('  - ' + p);
  process.exit(1);
}
console.log('链接检查通过');
