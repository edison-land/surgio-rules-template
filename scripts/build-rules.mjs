#!/usr/bin/env node
/**
 * 构建「不依赖节点信息」的 QuantumultX 规则文件，输出到 rules/。
 *
 * 为什么要合并：上游规则文件里每行末尾写的是它自己的分组名（例如 `HOST,x,AdvertisingLite`），
 * 直接引用的话，用户在 QX 里添加时必须手动选一次策略。这里把策略**写死**成 QX 的内置策略
 * （direct / proxy / reject），用户添加时什么都不用选，粘 URL 就完事。
 *
 * 产物只含规则，不含任何节点、订阅、账号信息，可以公开托管、随便转发。
 *
 * 用法：node scripts/build-rules.mjs
 * 自动更新：见 .github/workflows/build-rules.yml（每天重建一次）
 */

import { writeFile, mkdir } from 'node:fs/promises';

const BM = 'https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/QuantumultX';
const FMZ = 'https://raw.githubusercontent.com/fmz200/wool_scripts/main/QuantumultX';

/** 每个产物 = 若干「上游文件 → 目标策略」。policy 为 null 表示保留上游自带的策略。 */
const TARGETS = {
  'routing.list': {
    title: '分流规则（国内直连 / 指定服务走代理）',
    desc: '策略已写死为 QX 内置的 direct / proxy，添加时不需要选择策略偏好。',
    sources: [
      { url: `${BM}/OpenAI/OpenAI.list`, policy: 'proxy', name: 'OpenAI' },
      { url: `${BM}/Claude/Claude.list`, policy: 'proxy', name: 'Claude' },
      { url: `${BM}/Gemini/Gemini.list`, policy: 'proxy', name: 'Gemini' },
      { url: `${BM}/YouTube/YouTube.list`, policy: 'proxy', name: 'YouTube' },
      { url: `${BM}/YouTubeMusic/YouTubeMusic.list`, policy: 'proxy', name: 'YouTube Music' },
      { url: `${BM}/GlobalScholar/GlobalScholar.list`, policy: 'proxy', name: '学术网站' },
      { url: `${BM}/Docker/Docker.list`, policy: 'proxy', name: 'Docker' },
      // 国内规则放最后：QX 从上往下匹配，先命中上面的服务规则才不会被大陆域名表抢走
      { url: `${BM}/China/China.list`, policy: 'direct', name: '大陆域名' },
      { url: `${BM}/ChinaIPs/ChinaIPs.list`, policy: 'direct', name: '大陆 IP' },
    ],
  },
  'adblock.list': {
    title: '去广告规则（域名级）',
    desc: '不需要 MITM、不需要装证书。开屏广告拦截是另一个文件，见 README。',
    sources: [
      // 上游每行自带 reject / reject-dict / reject-img 等不同策略，语义不同，原样保留
      { url: `${FMZ}/filter/filter.list`, policy: null, name: '广告拦截合集@奶思' },
      { url: `${BM}/AdvertisingLite/AdvertisingLite.list`, policy: 'reject', name: 'AdvertisingLite@bm7' },
    ],
  },
};

/** QX 原生的规则类型（第一段）。只有这些开头的才是规则，其余按注释/空行处理。 */
const RULE_TYPES = new Set([
  'host', 'host-suffix', 'host-keyword', 'host-wildcard',
  'ip-cidr', 'ip6-cidr', 'geoip', 'ip-asn', 'user-agent',
]);

/**
 * 上游偶尔混入 Surge / Clash 的写法（例如 fmz200 的表里有 7 条 `DOMAIN,`）。
 * QX 用的是 host 系列，这里统一换掉，免得那几条被静默忽略。
 */
const TYPE_ALIASES = {
  domain: 'host',
  'domain-suffix': 'host-suffix',
  'domain-keyword': 'host-keyword',
};

/**
 * 把一行规则的策略字段替换成目标策略。
 * QX 规则形如 `HOST,example.com,PolicyName`，也可能带 `no-resolve` 之类的尾参。
 * 返回 null 表示这行不是规则（注释/空行），应当丢弃。
 */
function retarget(line, policy) {
  const trimmed = line.trim();
  if (!trimmed || trimmed.startsWith('#') || trimmed.startsWith(';')) return null;

  const parts = trimmed.split(',').map((p) => p.trim());
  if (parts.length < 2) return null;

  const rawType = parts[0].toLowerCase();
  const type = TYPE_ALIASES[rawType] ?? rawType;
  if (!RULE_TYPES.has(type)) return null;
  parts[0] = type;

  if (policy === null) return parts.join(', ');

  // 保留末尾的修饰参数（no-resolve / force-remote-dns 等），只换策略那一段
  const tail = parts.slice(2).filter((p) => p.includes('-') && !p.includes('.'));
  const modifiers = tail.filter((t) =>
    ['no-resolve', 'force-remote-dns', 'force-cellular', 'multi-interface'].includes(t.toLowerCase()),
  );
  return [parts[0], parts[1], policy, ...modifiers].join(', ');
}

async function fetchText(url) {
  const res = await fetch(url, { headers: { 'user-agent': 'surgio-rules-template/build' } });
  if (!res.ok) throw new Error(`${res.status} ${res.statusText} ← ${url}`);
  return res.text();
}

async function build(filename, spec) {
  const chunks = [];
  let total = 0;

  for (const src of spec.sources) {
    const text = await fetchText(src.url);
    const rules = text
      .split('\n')
      .map((l) => retarget(l, src.policy))
      .filter(Boolean);

    if (rules.length === 0) throw new Error(`${src.name} 解析出 0 条规则，上游格式可能变了：${src.url}`);

    chunks.push(`# ---------- ${src.name} (${rules.length} 条 → ${src.policy ?? '保留上游策略'}) ----------`);
    chunks.push(...rules);
    chunks.push('');
    total += rules.length;
    console.log(`  ${src.name.padEnd(22)} ${String(rules.length).padStart(7)} 条 → ${src.policy ?? '(保留上游)'}`);
  }

  const header = [
    `# ${spec.title}`,
    `# ${spec.desc}`,
    '#',
    '# 本文件由 scripts/build-rules.mjs 自动生成，请勿手工编辑。',
    '# 规则来自 blackmatrix7/ios_rule_script 与 fmz200/wool_scripts，版权归原作者。',
    `# 生成时间：${new Date().toISOString().replace('T', ' ').slice(0, 19)} UTC`,
    `# 规则总数：${total}`,
    '#',
    '# 用法：QuantumultX → 设置 → 过滤器 → 添加远程过滤器 → 粘贴本文件的 URL。',
    '#       策略已写死在每一行里，添加时【不要】设置策略偏好。',
    '',
  ].join('\n');

  await mkdir('rules', { recursive: true });
  await writeFile(`rules/${filename}`, header + chunks.join('\n') + '\n');
  console.log(`✅ rules/${filename}  共 ${total} 条\n`);
  return total;
}

for (const [filename, spec] of Object.entries(TARGETS)) {
  console.log(`构建 rules/${filename} …`);
  await build(filename, spec);
}
