'use strict';

// 从 .env 读取（见项目根目录的 .env.example）。
// 密码、域名这类东西**只**放在 .env 里，.env 已被 .gitignore 忽略，不会进 git。
require('dotenv').config();

const { TROJAN_HOST, TROJAN_PORT, TROJAN_PASSWORD, TROJAN_SNI, TROJAN_NODE_NAME } =
  process.env;

if (!TROJAN_HOST || !TROJAN_PASSWORD) {
  // 这个 Provider 是可选的：没配就不该被引用到。
  // surgio.conf.js 里会先判断环境变量存在与否，再决定要不要生成 *-Tr 产物。
  throw new Error(
    '\n[surgio] 自建 Trojan 节点没配全。请在 .env 里填 TROJAN_HOST 和 TROJAN_PASSWORD（见 .env.example）。\n',
  );
}

/**
 * 自建 Trojan VPS。
 * type: 'custom' = 节点直接写在这里，不走订阅链接。
 * 字段文档：https://surgio.js.org/guide/custom-provider.html
 */
module.exports = {
  type: 'custom',
  addFlag: true, // 节点名前加国旗 emoji
  nodeList: [
    {
      type: 'trojan',
      nodeName: TROJAN_NODE_NAME || 'US Trojan VPS',
      hostname: TROJAN_HOST,
      port: Number(TROJAN_PORT || 443),
      password: TROJAN_PASSWORD,
      sni: TROJAN_SNI || TROJAN_HOST,
      udpRelay: true,
    },
  ],
};
