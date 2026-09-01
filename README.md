# surgio-rules-template

**填入你的机场订阅链接，一条命令生成按规则分流的 Clash / QuantumultX 配置。**

国内网站直连、国外网站走代理，YouTube / AI 平台 / 学术 / 苹果 / 微软各自分组，规则自动从社区仓库更新。
默认还带上了去广告——包括 **QuantumultX 上的 App 开屏广告拦截**（见[下文](#去广告与开屏广告拦截)）。底层是 [Surgio](https://surgio.js.org/)。

> ⚠️ 本模板不提供节点，你需要**自己已有一个机场订阅**。

---

## 选哪条路

| | 要装什么 | 你要做什么 | 得到什么 |
|---|---|---|---|
| **⚡ A. 一键去广告** | 什么都不用装 | **点一个链接**（+ 装证书 3 步） | 去广告 + 开屏广告，不动你现有配置 |
| **⚡ B. 零门槛完整配置** | 什么都不用装 | 复制全文，**改 1 行** | 分流 + 去广告 |
| 🤖 让 AI Agent 配 | Node.js | 把订阅链接给它 | 同上，但可自定义 |
| 🖐 自己跑 Surgio | Node.js | 按需改配置 | 改分组、加自己的规则、多机场合并 |

**A 可以直接转发给不懂技术的朋友**——点一下就装好了。
只有当你要改分组、加自定义规则、合并多个机场订阅、按协议过滤节点时，才需要走 Surgio。

---

## ⚡ 零门槛用法（不装任何东西）

**如果你已经在用 QuantumultX，你不需要换配置。** 机场给的配置里已经有节点和策略组了，
你缺的只是规则。粘三条链接进去就行——规则文件托管在本仓库，**不含任何节点和账号信息**。

### 🅰 加三条规则（推荐）

| 要什么 | 在 QX 里加到哪 | 粘这个链接 |
|---|---|---|
| **分流**<br><sub>国内直连 / AI·YouTube·学术走代理</sub> | 设置 → 过滤器 → 添加远程过滤器 | `https://raw.githubusercontent.com/edison-land/surgio-rules-template/main/rules/routing.list` |
| **去广告**<br><sub>域名级，不用装证书</sub> | 设置 → 过滤器 → 添加远程过滤器 | `https://raw.githubusercontent.com/edison-land/surgio-rules-template/main/rules/adblock.list` |
| **App 开屏广告**<br><sub>需要证书，见下</sub> | 设置 → 重写 → 添加远程重写 | `https://raw.githubusercontent.com/fmz200/wool_scripts/main/QuantumultX/rewrite/rewrite.snippet` |

> ⚠️ **添加时不要设置「策略偏好」**——策略（`direct` / `proxy` / `reject`）已经写死在每一行规则里了，
> 用的都是 QX 内置策略，所以塞进任何人的配置都能直接工作，不依赖你有没有某个策略组。

只做加法：你现有的节点、策略组、自己加过的规则，一个都不会动。不想要了就在 QX 里把这几条资源删掉。

**开屏广告拦截还差证书三步**，缺一步都不会有效果：

1. QX → 设置 → MITM → 生成证书 → 安装；
2. iOS 设置 → 通用 → 关于本机 → **证书信任设置 → 打开对该证书的信任**（最容易漏）；
3. 对想去广告的 App 清缓存或重装一次（开屏图是提前缓存在本地的）。

> 嫌一条条加麻烦？[`oneclick/quantumultx-oneclick-link.txt`](./oneclick/quantumultx-oneclick-link.txt)
> 里有一键链接，在 iPhone 上点一下会自动唤起 QX 全部装好（链接很长，但不用你手动操作）。

### 规则从哪来、怎么更新

`rules/` 下的文件由 [`scripts/build-rules.mjs`](./scripts/build-rules.mjs) 从上游合并生成，
**GitHub Actions 每天自动重建**（[build-rules.yml](./.github/workflows/build-rules.yml)），
你什么都不用做。合并这一步做的事是把上游各自的分组名统一改写成 QX 内置策略，
省掉「添加时要手动选策略」这一步。

| 文件 | 规则数 | 来源 |
|---|---|---|
| `rules/routing.list` | ~27,000 | blackmatrix7（OpenAI / Claude / Gemini / YouTube / 学术 / Docker / 大陆域名 / 大陆 IP） |
| `rules/adblock.list` | ~41,000 | fmz200 + blackmatrix7 |

想自己改（比如把 YouTube 也改成直连）：编辑 `scripts/build-rules.mjs` 里的 `TARGETS`，
跑 `npm run build:rules` 重新生成。这一步需要 Node.js，但**只有想改规则的人才需要**。

### 🅱 换整份配置（想要 🇭🇰🇺🇸 地区分组时）

上面加规则用的是 QX 内置策略，够用但没法按地区手动切节点。
想要 🇭🇰香港 / 🇺🇸美国 / 🇯🇵日本 这种分组，得换整份配置——因为策略组只能定义在配置文件里。

| 文件 | 客户端 | 分流 | 地区分组 | 去广告 | **开屏广告** |
|---|---|---|---|---|---|
| [`oneclick/QuantumultX.conf`](./oneclick/QuantumultX.conf) | QuantumultX | ✅ | ✅ | ✅ | ✅ |
| [`oneclick/Clash.yaml`](./oneclick/Clash.yaml) | Mihomo Party / Clash Verge Rev / FlClash / Stash | ✅ | ✅ | ✅ | ❌ 内核不支持 |

打开文件 → Raw → 全选复制 → **把唯一那行占位符换成你自己机场的订阅链接** → 应用它
（托管到能出直链的地方再在客户端填 URL，或直接粘进客户端自带的配置编辑器）。

配置里不含任何节点，客户端自己去拉你的订阅；地区分组靠节点名正则自动归类
（QX 用 `server-tag-regex`，Clash 用 `filter`），换机场也不用改。

> ⚠️ Clash / mihomo 内核没有 MITM 能力，做不了开屏广告拦截，这是客户端限制不是配置问题。
> 只用 Clash 的朋友只能拿到域名级去广告。

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

## 去广告与开屏广告拦截

模板默认已经开了去广告。要理解它，先分清**两层**——它们能干的事完全不同：

| | 域名级（filter） | 改写级（rewrite） |
|---|---|---|
| 做什么 | 把广告 SDK 的域名整个拒掉 | 只拦「下发开屏广告」的那几个 URL，把响应换成空 JSON |
| 能拦开屏广告吗 | **不能** | **能，这是唯一的办法** |
| 需要解密 HTTPS(MITM) | 不需要 | **需要，得装并信任证书** |
| 支持的客户端 | Clash / mihomo + QuantumultX | **只有 QuantumultX** |

为什么开屏广告只能靠第二层：开屏广告的接口通常挂在 App 自己的主域名上（形如 `api.某app.com/…/splash`），
和登录、刷新用的是同一个域名。整域拒掉，App 就直接废了。只能解密 HTTPS，精确匹配那几个 URL 再替换响应。

Clash / mihomo 没有 MITM 能力，所以 `Clash.yaml` 里**只有域名级**那一层（用 [anti-AD](https://anti-ad.net/) 域名表）。
**开屏广告拦截只在 `QuantumultX.conf` 里。**

### 在 QuantumultX 上启用开屏广告拦截

生成的 `QuantumultX.conf` 已经把规则订阅写好了，但**光导入配置不会生效**，还差证书这一步：

1. 导入 `QuantumultX.conf`；
2. QX → 设置 → **MITM** → 生成证书 → 安装（会跳到系统「描述文件」里安装）；
3. **iOS 设置 → 通用 → 关于本机 → 证书信任设置 → 打开对该证书的信任**
   —— 这一步最容易漏，漏了 MITM 完全不工作，开屏广告照旧；
4. 对着要去广告的 App **清除缓存或卸载重装一次**。开屏素材是 App 提前缓存在本地的，
   不重装的话你看到的还是昨天下发的那张广告图。

规则内容由 QuantumultX 自己每天从上游拉取更新（`update-interval=86400`），改了规则不需要重新 `npm run generate`。

### 开关

在 `surgio.conf.js` 的 `customParams.adBlock` 里：

```js
adBlock: {
  filter: true,       // 域名级去广告（Clash + QX 都生效，零风险）
  splash: true,       // 开屏广告改写（仅 QX，需 MITM）
  cleanup: false,     // App 净化合集，上游标注「遇到异常时关闭」，默认关
  extraSplash: false, // blackmatrix7 的改写规则，要更大覆盖面时打开
  mitmExclude: [...], // 这些域名永不解密，见下
},
```

规则来自 [fmz200/wool_scripts](https://github.com/fmz200/wool_scripts)（约 730 款 App / 小程序，其中 100+ 处是开屏广告）、
[blackmatrix7/ios_rule_script](https://github.com/blackmatrix7/ios_rule_script) 和 [anti-AD](https://github.com/privacy-protection-tools/anti-AD)。
本仓库只负责把这些订阅写进配置，不维护规则本身。

### MITM 的代价，和出问题怎么办

解密 HTTPS 不是免费的，装之前先知道这几件事：

- **银行 / 支付 / 券商类 App 会崩。** 它们普遍做了证书固定（SSL Pinning），一旦流量被解密就直接登录失败或打不开。
  模板默认已经把支付宝、微信支付、银联、几家主要银行和 Apple 的域名放进 `mitmExclude` 排除掉了
  —— 代价是这些 App 的广告也拦不掉。
- **某个 App 突然打不开、转圈、登录失败**：多半就是它被 MITM 了。把它的域名加进 `mitmExclude` 重新生成即可
  （只写域名，不用写 `-`，模板会自动加前缀）。想快速确认，直接在 QX 里关掉 MITM 总开关试一下。
- **开屏广告还在**：先确认证书那一步的「信任」开关真的打开了，再清一次 App 缓存。
- **耗电 / 变慢**：MITM 只对规则里声明的 hostname 生效，不是全量解密，影响有限；但确实比不开要费电。
  完全不想要就把 `splash` 设成 `false`，只留域名级那层。

> 这些规则只作用于你自己设备上的流量。请自行确认符合你所用 App 的服务条款；对开发者的支持可以换个方式表达。

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

分流规则来自 [blackmatrix7/ios_rule_script](https://github.com/blackmatrix7/ios_rule_script)；
去广告规则来自 [fmz200/wool_scripts](https://github.com/fmz200/wool_scripts)、[blackmatrix7/ios_rule_script](https://github.com/blackmatrix7/ios_rule_script) 和 [anti-AD](https://github.com/privacy-protection-tools/anti-AD)；
引擎是 [Surgio](https://surgio.js.org/)。[MIT](./LICENSE)。
