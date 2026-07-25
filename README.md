# surgio-rules-template

**填入你的机场订阅链接，一条命令生成按规则分流的 Clash / QuantumultX 配置。**

国内网站直连、国外网站走代理，YouTube / AI 平台 / 学术 / 苹果 / 微软各自分组，规则自动从社区仓库更新。底层是 [Surgio](https://surgio.js.org/)。

> ⚠️ 本模板不提供节点，你需要**自己已有一个机场订阅**。

---

## 🤖 用 AI Agent 一键配置（最省事）

现在最简单的用法：把**这个仓库的链接**丢给你的 AI 编程助手（Claude Code / Cursor / Codex / 豆包 等），说一句：

> 「帮我按这个仓库配好机场分流配置，我的订阅链接是 ______」

它会照着仓库里的 [`AGENTS.md`](./AGENTS.md) 自动帮你：**装依赖 → 填订阅 → 生成配置 → 告诉你怎么导入客户端**，遇到报错也会自己处理。你全程只需要提供订阅链接。

> 🔒 你的订阅链接是机密，只会被写进本地 `.env`（已 gitignore），不会上传到任何地方。

---

## 🖐 手动配置（想自己动手）

**前提**：装 [Node.js ≥ 18](https://nodejs.org/)。

```bash
git clone https://github.com/edison-land/surgio-rules-template.git
cd surgio-rules-template
npm install

cp .env.example .env      # 编辑 .env，填入你的机场订阅链接
npm run generate
```

生成结果在 `dist/`：

- `Clash.yaml` —— 给 mihomo 内核客户端（Clash Verge Rev / Mihomo Party / FlClash）
- `QuantumultX.conf` —— 给 QuantumultX

> `npm run generate` 默认带 DNS 兜底，多数国内网络能直接拉到规则；仍失败见 [生成失败排查](#生成失败排查)。

---

## 导入客户端

把生成的文件放到设备能访问的位置（本地导入 / iCloud / 私有 gist），再在客户端里导入：

- **Clash 系（mihomo 内核，推荐）**：Mihomo Party / Clash Verge Rev / FlClash → Profiles → 导入 `Clash.yaml`。
- **QuantumultX**：设置 → 配置 → 从 URL 引用，填 `QuantumultX.conf` 的地址。
- **Shadowrocket**：见下方「关于节点协议」。

---

## 关于节点协议（anytls 等）

本模板用 Surgio **v3**，能解析并输出 **anytls / hysteria2 / tuic** 等新协议——机场的 anytls 好线路会正常进入 `Clash.yaml`。但「配置里有」不等于「客户端用得了」：

| 客户端 | anytls |
|---|---|
| mihomo 系（Clash Verge Rev / Mihomo Party / FlClash） | ✅ 用 `Clash.yaml` 即可 |
| sing-box / Karing | ✅ iOS 首选 |
| Shadowrocket | ⚠️ 2.2.65+ 支持但目前会断流；且读 Surge 格式，不建议用本 `Clash.yaml` |
| QuantumultX | ❌ App 不支持 anytls |

> **内核版本注意**：anytls 需要 **mihomo 内核 ≥ 1.19**。若客户端报 `unsupport proxy type: anytls`，去客户端设置里把 mihomo 内核更新到最新（或更新客户端本体）即可。
>
> **QuantumultX 注意**：`QuantumultX.conf` 里会写入 anytls 节点，但 QX App 用不了它们（ss/vmess/trojan 正常）。想在手机上用 anytls，用 mihomo 系 / sing-box / Karing。

---

## 自定义分流规则

改 `surgio.conf.js` 里的 `customParams`：

```js
customParams: {
  proxySuffixes: ['要强制走代理的域名.com'],
  directSuffixes: ['公司内网.com', '学校.edu.cn'],
  directIPs:      ['1.2.3.4'],
},
```

改完重新 `npm run generate`。要调分组或规则来源，编辑 `template/*.tpl` 和 `surgio.conf.js` 里的 `remoteSnippets`。

---

## 生成失败排查

**拉远程规则失败**（`raw.githubusercontent.com` 证书/超时）：`npm run generate` 默认已带 DNS 兜底。仍失败就开代理跑 `npm run generate:nofix`，或把 `remoteSnippets` 换成 jsDelivr 镜像 `https://cdn.jsdelivr.net/gh/blackmatrix7/ios_rule_script@master/...`。

**订阅 403 Forbidden**：机场拒绝拉订阅。① 拉太频繁被限流，等一会再试（别频繁重跑）；② 到机场后台刷新订阅链接并更新 `.env`；③ UA 被拦——`provider/airport.js` 已默认带客户端 UA，可换成 `'clash'` / `'mihomo'`。

---

## 用 GitHub Actions 自动生成（可选）

1. Fork 本仓库；
2. Settings → Secrets and variables → Actions 新建 `AIRPORT_SUBSCRIPTION_URL`；
3. Actions 页跑 `Generate configs`，在 Artifacts 里下载 `dist`。

> 该流程只产**私有构件**，不公开发布。

---

## 安全须知

- 订阅链接 = 机场密码：只放 `.env` / GitHub Secret，别提交别截图。
- `dist/` 里的配置含真实节点，等同你的账号，已默认 gitignore；分享给别人请分享**本模板**而不是生成好的配置。

## 致谢 & License

规则来自 [blackmatrix7/ios_rule_script](https://github.com/blackmatrix7/ios_rule_script)，引擎是 [Surgio](https://surgio.js.org/)。[MIT](./LICENSE)。
