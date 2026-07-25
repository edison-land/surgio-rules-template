# provider/ —— 节点从哪来

这个目录里每个 `.js` 文件是一个「Provider」，告诉 Surgio 到哪拿节点。
文件名（去掉 `.js`）就是 `surgio.conf.js` 里 `artifacts[].provider` 引用的名字。

## 默认：一个机场订阅（airport.js）

`airport.js` 从 `.env` 里读订阅链接（`AIRPORT_SUBSCRIPTION_URL`），不写死在代码里，
所以可以放心开源。你只要填好 `.env` 就行，通常不用改这个文件。

## 加第二个机场

1. 复制 `airport.js` 为 `airport2.js`，把里面的环境变量名改成 `AIRPORT2_SUBSCRIPTION_URL`；
2. 在 `.env` 里加一行 `AIRPORT2_SUBSCRIPTION_URL=...`；
3. 在 `surgio.conf.js` 的 `artifacts` 里加一条用 `provider: 'airport2'` 的产物，
   或用 Surgio 的多 Provider 合并能力（见官方文档）。

## 不同订阅类型

`airport.js` 里的 `type` 按你机场给的订阅格式改：

| 机场给的东西 | type |
|---|---|
| Clash 订阅链接（最常见） | `'clash'` |
| Trojan 订阅 | `'trojan'` |
| SS 订阅 | `'shadowsocks_subscribe'` |
| SSR 订阅 | `'shadowsocksr_subscribe'` |
| 自己手写节点 | `'custom'`（用 `nodeList`，见官方文档） |

Provider 完整文档：https://surgio.js.org/guide/custom-provider.html
