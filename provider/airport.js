'use strict';

// 从 .env 读取环境变量（见项目根目录的 .env.example）
require('dotenv').config();

const SUB_URL = process.env.AIRPORT_SUBSCRIPTION_URL;

if (!SUB_URL) {
  throw new Error(
    '\n[surgio] 还没有填订阅链接。请把 .env.example 复制成 .env，' +
      '并在里面填上你的机场订阅链接 AIRPORT_SUBSCRIPTION_URL。\n',
  );
}

/**
 * 机场订阅 Provider。
 * type 常用取值：
 *   - 'clash'  : 机场给的 Clash 订阅链接（最常见，推荐）
 *   - 'trojan' / 'shadowsocks_subscribe' / 'shadowsocksr_subscribe' : 对应协议的订阅
 *   - 'custom' : 自己手写节点列表（见 provider/README）
 * 文档：https://surgio.js.org/guide/custom-provider.html
 */
module.exports = {
  type: 'clash',
  url: SUB_URL,
  udpRelay: true, // 开启 UDP（游戏 / 语音需要）
  addFlag: true, // 节点名前加国旗 emoji
  // 伪装成 mihomo 客户端拉订阅。很多机场会拦「非客户端」UA 直接返回 403，
  // 带上这个能避开大多数 UA 拦截。若某机场对 UA 挑剔，可改成 'clash' / 'mihomo' 等。
  requestUserAgent: 'clash.meta',
};
