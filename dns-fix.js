// 可选的 DNS 兜底（仅在拉取远程规则失败时用）。
//
// 背景：Surgio 会从 raw.githubusercontent.com 下载分流规则片段。
// 在国内网络下这个域名经常被污染/被墙，导致 generate 报 TLS 或超时错误。
// 本文件把该域名强制解析到可用的 Fastly 锚点 IP，不改动任何系统文件。
//
// 默认已生效：`npm run generate` 通过 NODE_OPTIONS 预加载本文件。
// 若下面的 IP 全部失效，可到 https://www.itdog.cn/tcping/ 等工具查
// raw.githubusercontent.com 的可用 IP 后替换。
//
// 不需要兜底（本机/代理已能正常访问 GitHub）时，用 `npm run generate:nofix`。
const dns = require('dns');

const HOST = 'raw.githubusercontent.com';
const IPS = ['185.199.108.133', '185.199.109.133', '185.199.110.133', '185.199.111.133'];

const origLookup = dns.lookup;
dns.lookup = function (hostname, options, callback) {
  if (hostname === HOST) {
    if (typeof options === 'function') {
      callback = options;
      options = {};
    }
    const all = options && options.all;
    if (all) {
      return process.nextTick(
        callback,
        null,
        IPS.map((address) => ({ address, family: 4 })),
      );
    }
    return process.nextTick(callback, null, IPS[0], 4);
  }
  return origLookup.call(this, hostname, options, callback);
};

if (dns.promises && dns.promises.lookup) {
  const origP = dns.promises.lookup;
  dns.promises.lookup = function (hostname, options) {
    if (hostname === HOST) {
      const all = options && options.all;
      return Promise.resolve(
        all ? IPS.map((address) => ({ address, family: 4 })) : { address: IPS[0], family: 4 },
      );
    }
    return origP.call(this, hostname, options);
  };
}
