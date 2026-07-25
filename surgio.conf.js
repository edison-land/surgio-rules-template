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
