#!/usr/bin/env node
'use strict';

/**
 * `npm run generate` 的启动器。解决的是同一个老问题：
 * Surgio 要从 raw.githubusercontent.com 拉分流规则，而这个域名在国内经常被 RST，
 * 表现就是 `Client network socket disconnected before secure TLS connection was established`。
 *
 * 两条路，自动选：
 *  1. 本机有 Clash / QuantumultX / Surge 之类的**本地 HTTP 代理端口**开着 → 让 Node 走它。
 *     用 Node 24.5+ 内置的 NODE_USE_ENV_PROXY，不需要给 surgio 打补丁。这条路最稳。
 *  2. 没有代理（或 Node 太老）→ 退回 dns-fix.js：把域名钉到可用的 Fastly IP。
 *     能不能成看当时的网络，失败就多跑几次（成功下载的片段会缓存 12 小时，重跑只补没拿到的）。
 *
 * 注意：客户端开了「系统代理」也不够——macOS 的系统代理设置只对 GUI 应用生效，
 * 命令行里的 Node 不读它，所以这里要显式把代理地址传进去。
 *
 * 想指定代理：LOCAL_PROXY=http://127.0.0.1:1080 npm run generate
 * 想强制不用代理：NO_LOCAL_PROXY=1 npm run generate
 */

const net = require('node:net');
const path = require('node:path');
const { spawn } = require('node:child_process');

// 常见的本地混合/HTTP 代理端口：mihomo 系默认 7890，Clash Verge Rev 7897，旧版 Surge/QX 1087
const CANDIDATE_PORTS = [7890, 7897, 1087];
const ROOT = path.resolve(__dirname, '..');

/** Node 24.5 起 http/https 请求可以直接读 HTTPS_PROXY 环境变量，不需要改 surgio 的代码 */
function supportsEnvProxy() {
  const [major, minor] = process.versions.node.split('.').map(Number);
  return major > 24 || (major === 24 && minor >= 5);
}

function probe(port, timeout = 300) {
  return new Promise((resolve) => {
    const socket = net.connect({ host: '127.0.0.1', port });
    const done = (ok) => {
      socket.destroy();
      resolve(ok);
    };
    socket.setTimeout(timeout);
    socket.once('connect', () => done(true));
    socket.once('timeout', () => done(false));
    socket.once('error', () => done(false));
  });
}

async function findProxy() {
  if (process.env.NO_LOCAL_PROXY) return null;
  if (process.env.LOCAL_PROXY) return process.env.LOCAL_PROXY;
  for (const port of CANDIDATE_PORTS) {
    if (await probe(port)) return `http://127.0.0.1:${port}`;
  }
  return null;
}

async function main() {
  const env = {
    ...process.env,
    // surgio 默认 5 秒超时，规则表有 1~3MB，网络稍慢就整个失败
    SURGIO_NETWORK_TIMEOUT: process.env.SURGIO_NETWORK_TIMEOUT || '30000',
    SURGIO_NETWORK_RETRY: process.env.SURGIO_NETWORK_RETRY || '2',
  };

  const proxy = await findProxy();

  if (proxy && supportsEnvProxy()) {
    env.NODE_USE_ENV_PROXY = '1';
    env.HTTPS_PROXY = proxy;
    env.HTTP_PROXY = proxy;
    console.log(`[surgio] 走本地代理拉规则：${proxy}`);
  } else {
    env.NODE_OPTIONS = `--require ${path.join(ROOT, 'dns-fix.js')} ${process.env.NODE_OPTIONS || ''}`.trim();
    if (proxy) {
      console.log(
        `[surgio] 检测到本地代理 ${proxy}，但 Node ${process.versions.node} 不支持 NODE_USE_ENV_PROXY（需 24.5+），改用 DNS 兜底。`,
      );
    } else {
      console.log('[surgio] 没检测到本地代理，用 dns-fix.js 的 IP 兜底拉规则。');
      console.log('[surgio] 若报 TLS/socket 错误，把梯子打开再跑一次即可（本脚本会自动识别）。');
    }
  }

  const bin = path.join(ROOT, 'node_modules', '.bin', 'surgio');
  const child = spawn(bin, ['generate', ...process.argv.slice(2)], { stdio: 'inherit', env });
  child.on('exit', (code) => process.exit(code ?? 1));
}

main();
