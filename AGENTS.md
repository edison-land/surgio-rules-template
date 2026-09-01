# AGENTS.md — 给 AI Agent 的执行指引

本仓库是一个 [Surgio](https://surgio.js.org/) 模板：输入用户的机场订阅链接，生成按规则分流的
**Clash / QuantumultX** 配置。当用户把本仓库链接丢给你、让你"帮我配好"时，按下面的 runbook 执行。

## 先判断走哪条路（重要）
用户如果**只是想要分流 + 去广告**，不需要自定义分组/规则，**别让他装 Node.js 跑 Surgio**：
直接用 `oneclick/QuantumultX.conf` 或 `oneclick/Clash.yaml` —— 那是两份完整配置，
把里面唯一一处占位符换成用户的订阅链接就能导入，不需要本仓库的任何构建步骤。
只有当用户明确要改分组、加自定义规则、合并多个机场订阅、按协议过滤节点时，才走下面的 Surgio 流程。

## 你的目标（Surgio 流程）
在用户机器上生成 `dist/Clash.yaml` 和 `dist/QuantumultX.conf`，并告诉用户如何导入客户端。

## 需要向用户索取的唯一输入
- **机场的 Clash 订阅链接**（形如 `https://xxx/link/xxxx?clash=1` 或 `.../subscribe?token=xxxx`）。
- ⚠️ 这是机密，等同账号密码。只写入本地 `.env`，**绝不要**提交到 git、打印进日志、或发送到任何外部服务。

## 前置检查
- Node.js ≥ 18：跑 `node -v`。版本不够就引导用户去 <https://nodejs.org> 安装后再继续。

## 执行步骤（在仓库根目录）
1. 装依赖：`npm install`
2. 准备配置：`cp .env.example .env`
3. 把用户给的订阅链接写进 `.env` 里的 `AIRPORT_SUBSCRIPTION_URL=`（只改这一行；不要把整行内容回显到对话）。
4. 生成：`npm run generate`
5. 成功判据：`dist/Clash.yaml` 与 `dist/QuantumultX.conf` 都已生成。

## 报错时的自处理
- **`403 Forbidden` / 获取 airport 节点失败**：机场对订阅接口限流，或链接过期。
  → 让用户去机场后台**刷新订阅链接**并更新 `.env`；或等 10~30 分钟再试。**不要**短时间反复重跑（会加重限流）。
- **拉远程规则失败（`raw.githubusercontent.com` 证书 / 超时）**：`npm run generate` 默认已带 DNS 兜底；
  仍失败就让用户**开启代理**后改用 `npm run generate:nofix`。
- **客户端加载报 `unsupport proxy type: anytls`**：客户端的 mihomo 内核太旧。
  → 让用户在客户端设置里把 mihomo 内核更新到 **≥ 1.19**（或更新客户端本体）。这不是本仓库能修的。
- **用户反馈某个 App 开了配置后打不开 / 登录失败**：大概率是该 App 做了证书固定又被 MITM 了。
  → 把该 App 的域名加进 `surgio.conf.js` 的 `customParams.adBlock.mitmExclude`（只写域名，不用写 `-`），重新 `npm run generate`。
  → 想快速验证，让用户先在 QX 里关掉 MITM 总开关看是否恢复。
- **用户说开屏广告还在**：先确认证书的「信任」开关真的打开了，再让他清一次该 App 的缓存或重装。

## 完成后要告诉用户
- 文件在 `dist/`：`Clash.yaml`（给 mihomo 系：Clash Verge Rev / Mihomo Party / FlClash）、`QuantumultX.conf`（给 QuantumultX）。
- 怎么导入：把文件导入对应客户端（本地文件，或放到设备可访问的地址再引用）。
- anytls 提醒：机场新协议的好线路需要 mihomo 内核 ≥ 1.19；QuantumultX 用不了 anytls。
- **去广告已默认开启**，但用 QuantumultX 的用户还差一步，必须明确告诉他们（否则开屏广告不会消失）：
  1. QX → 设置 → MITM → 生成证书 → 安装；
  2. iOS 设置 → 通用 → 关于本机 → **证书信任设置 → 打开信任**（最常被漏掉的一步）；
  3. 对目标 App 清缓存或重装一次（开屏素材是提前缓存在本地的）。
  同时提醒：银行 / 支付类 App 因证书固定可能被 MITM 搞崩，模板已默认排除主流几家，
  遇到别的 App 打不开就把它的域名加进 `surgio.conf.js` 的 `customParams.adBlock.mitmExclude` 再重新生成。
- Clash 那份**没有**开屏广告拦截，只有域名级去广告——mihomo 没有 MITM 能力，这是客户端限制，不是配置问题。

## 红线（务必遵守）
- 不要 `git add` / 提交 `.env` 或 `dist/`（已在 `.gitignore`）。
- 不要把订阅链接、或生成出的节点内容，发送到任何外部服务。
- 不要把 `dist/` 发布到公开位置（含用户真实节点，等于泄露账号）。
