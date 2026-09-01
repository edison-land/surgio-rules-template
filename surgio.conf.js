'use strict';

// 读取 .env 里的订阅链接等环境变量（见 .env.example）
require('dotenv').config();

if (!process.env.AIRPORT_SUBSCRIPTION_URL) {
  throw new Error(
    '\n[surgio] 还没有填订阅链接。请把 .env.example 复制成 .env，' +
      '并在里面填上你的机场订阅链接 AIRPORT_SUBSCRIPTION_URL。\n',
  );
}

/**
 * Surgio 配置文档：https://surgio.js.org/
 *
 * 三个概念：
 *  - Provider（provider/ 目录）：节点从哪来，这里是你的机场订阅链接
 *  - Template（template/ 目录）：怎么把节点渲染成客户端能读的配置
 *  - Artifact（下方 artifacts）：最终生成到 dist/ 的产物
 *
 * 本模板用 Surgio v3：支持 anytls / hysteria2 / tuic 等新协议，Clash 与 QuantumultX 都能输出。
 */
module.exports = {
  /**
   * 远程规则片段：从 blackmatrix7/ios_rule_script 拉取分流规则。
   * 若拉取失败（raw.githubusercontent.com 被墙），见 README「远程规则拉取失败」一节。
   */
  remoteSnippets: [
    {
      name: 'china',
      url: 'https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/China/China_Domain.list',
    },
    {
      name: 'china_ip',
      url: 'https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/refs/heads/master/rule/Clash/ChinaIPs/ChinaIPs.list',
    },
    {
      name: 'apple',
      url: 'https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Apple/Apple_All.list',
    },
    {
      name: 'Microsoft',
      url: 'https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Microsoft/Microsoft.list',
    },
    {
      name: 'onedrive',
      url: 'https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/OneDrive/OneDrive.list',
    },
    {
      name: 'scholar',
      url: 'https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/GlobalScholar/GlobalScholar.list',
    },
    {
      name: 'youtube_music',
      url: 'https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/YouTubeMusic/YouTubeMusic.list',
    },
    {
      name: 'youtube',
      url: 'https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/YouTube/YouTube.list',
    },
    {
      name: 'OpenAI',
      url: 'https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/OpenAI/OpenAI.list',
    },
    {
      name: 'Gemini',
      url: 'https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Gemini/Gemini.list',
    },
    {
      name: 'Claude',
      url: 'https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/refs/heads/master/rule/Clash/Claude/Claude.list',
    },
    {
      name: 'Docker',
      url: 'https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/refs/heads/master/rule/Clash/Docker/Docker.list',
    },
  ],

  /**
   * 自定义分流参数——把你自己的域名/IP 塞进这三个数组即可，模板会自动生成规则。
   * 默认留空，按需填写；下面是示例格式（已注释）。
   */
  customParams: {
    // 强制走代理的域名后缀
    // proxySuffixes: ['example-blocked-site.com'],
    proxySuffixes: [],
    // 强制直连的域名后缀（公司内网、国内业务域名等）
    // directSuffixes: ['your-company.com', 'your-school.edu.cn'],
    directSuffixes: [],
    // 强制直连的 IP（自建服务器等）
    // directIPs: ['1.2.3.4'],
    directIPs: [],

    /**
     * 去广告 / App 开屏广告拦截。详见 README「去广告与开屏广告拦截」。
     *
     * 两层，作用完全不同：
     *  - filter（域名级）：把广告 SDK 的域名整个拒掉。Clash 和 QuantumultX 都支持，零风险，不用装证书。
     *    但它拦不掉开屏广告——开屏广告的接口通常挂在 App 自己的主域名上，整域拒掉 App 就废了。
     *  - splash（改写级）：只拦截「下发开屏广告」的那几个 URL，把响应换成空 JSON。
     *    这需要解密 HTTPS（MITM），所以**只有 QuantumultX 能做，且必须安装并信任 QX 的 CA 证书**。
     *    mihomo / Clash 没有 MITM 能力，Clash.yaml 里做不了这件事。
     *
     * 规则本身不由本仓库维护：下面的开关只决定往配置里写哪几行远程订阅，
     * 规则内容由 QuantumultX 自己按 update-interval 每天从上游拉取更新。
     */
    adBlock: {
      // 域名级去广告（Clash + QuantumultX 都生效）
      filter: true,
      // 开屏广告改写（仅 QuantumultX；需要 MITM + 信任证书）
      splash: true,
      // App 净化合集：去掉一些冗余模块/浮窗。上游作者标注「遇到异常时关闭」，故默认关
      cleanup: false,
      // blackmatrix7 的改写规则，和上面的开屏规则有重叠，需要更大覆盖面时再打开
      extraSplash: false,
      // 脚本类改写。**能补上 B站开屏**（主力规则集没覆盖 B站），代价见 template/quantumultx.tpl 里的说明。默认关
      scriptSplash: false,
      /**
       * MITM 排除名单：这些域名永远不解密。
       * 银行 / 支付 / 券商类 App 普遍做了证书固定（SSL Pinning），一旦被解密会直接登录失败或打不开，
       * 所以默认全部排除——代价是这些 App 的广告也拦不掉。
       * 想拿回某个 App 的去广告，就把对应行删掉；反过来，遇到某个 App 开了 MITM 就崩，
       * 把它的域名加进来即可（不用写 `-`，模板会自动加）。
       */
      mitmExclude: [
        // 支付 / 银联
        '*.alipay.com',
        '*.alipayobjects.com',
        '*.tenpay.com',
        '*.unionpay.com',
        '*.95516.com',
        // 银行（按需增删）
        '*.icbc.com.cn',
        '*.ccb.com',
        '*.abchina.com',
        '*.boc.cn',
        '*.bankcomm.com',
        '*.cmbchina.com',
        '*.psbc.com',
        // Apple / 系统服务
        '*.apple.com',
        '*.icloud.com',
        '*.mzstatic.com',
      ],
    },
  },

  /**
   * 生成产物：一份订阅同时产出 Clash 和 QuantumultX 两个配置。
   * name 是 dist/ 里的文件名，template 对应 template/ 里的模板，provider 对应 provider/ 里的文件名。
   */
  artifacts: [
    {
      name: 'Clash.yaml',
      template: 'clash',
      provider: 'airport',
    },
    {
      name: 'QuantumultX.conf',
      template: 'quantumultx',
      provider: 'airport',
    },
  ],

  /**
   * 订阅地址前缀，仅用于在文件头部生成一条注释（# {{ downloadUrl }}）。
   * 如果你要把 dist 托管到某个地址，可改成那个地址；不用可保持默认。
   */
  urlBase: 'https://example.com/',

  // 关闭 Surgio 的匿名错误上报
  analytics: false,
};
