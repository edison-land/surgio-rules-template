# {{ downloadUrl }}

external-controller: 127.0.0.1:9090
port: 7890
socks-port: 7891
redir-port: 7892

dns:
  enable: true
  nameserver:
    - https://223.5.5.5/dns-query
    - https://223.6.6.6/dns-query

tun:
  enable: true
  auto-route: true
  route-exclude-address:
    - 10.0.0.0/8
    - 172.16.0.0/12
    - 192.168.0.0/16
    - 127.0.0.0/8
    - 100.64.0.0/10

proxies: {{ getClashNodes(nodeList) | json }}

proxy-groups:
- name: 🎯全球直连
  type: select
  proxies:
    - DIRECT
- name: 🛑全球拦截
  type: select
  proxies:
    - REJECT
- name: ♻️自动选择
  type: url-test
  url: http://www.gstatic.com/generate_204
  interval: 300
  proxies: {{ getClashNodeNames(nodeList) | json }}
- name: 🔰节点选择
  type: select
  proxies: {{ getClashNodeNames(nodeList, null, ['🎯全球直连','🛑全球拦截','♻️自动选择']) | json }}
- name: 🇭🇰香港节点
  type: select
  proxies: {{ getClashNodeNames(nodeList, hkFilter) | json }}
- name: 🇺🇸美国节点
  type: select
  proxies: {{ getClashNodeNames(nodeList, usFilter) | json }}
- name: 🇹🇼台湾节点
  type: url-test
  url: http://www.gstatic.com/generate_204
  interval: 300
  proxies: {{ getClashNodeNames(nodeList, taiwanFilter) | json }}
- name: 🇯🇵日本节点
  type: url-test
  url: http://www.gstatic.com/generate_204
  interval: 300
  proxies: {{ getClashNodeNames(nodeList, japanFilter) | json }}
- name: 🇸🇬新加坡节点
  type: url-test
  url: http://www.gstatic.com/generate_204
  interval: 300
  proxies: {{ getClashNodeNames(nodeList, singaporeFilter) | json }}
- name: 🇨🇳大陆网站
  type: select
  proxies: ['🎯全球直连']
- name: 📢广告链接
  type: select
  # 拦截在前：Clash 的 select 组默认取第一项，写反了去广告就是空转。与 QX 侧保持一致。
  # 误伤某个站点时在客户端里把这个组切成 🎯全球直连 即可临时放行。
  proxies: ['🛑全球拦截','🎯全球直连']
- name: 🤖AIPlatforms
  type: select
  proxies: ['🇺🇸美国节点','🇹🇼台湾节点','🇯🇵日本节点','🇸🇬新加坡节点','🔰节点选择']
- name: 👨‍🔬学术网站
  type: select
  proxies: ['🔰节点选择','🇭🇰香港节点','🇺🇸美国节点','🇹🇼台湾节点','🇯🇵日本节点','🇸🇬新加坡节点','🎯全球直连','🛑全球拦截']
- name: 🟦Microsoft服务
  type: select
  proxies: ['🎯全球直连','🔰节点选择','🇭🇰香港节点','🇺🇸美国节点','🇹🇼台湾节点','🇯🇵日本节点','🇸🇬新加坡节点','🛑全球拦截']
- name: 📺YouTube视频
  type: select
  proxies: ['🔰节点选择','🇭🇰香港节点','🇺🇸美国节点','🇹🇼台湾节点','🇯🇵日本节点','🇸🇬新加坡节点','🎯全球直连','🛑全球拦截']
- name: 🍎Apple服务
  type: select
  proxies: ['🎯全球直连','🔰节点选择','🇭🇰香港节点','🇺🇸美国节点','🇹🇼台湾节点','🇯🇵日本节点','🇸🇬新加坡节点','🛑全球拦截']
- name: 🐟无匹配规则
  type: select
  proxies: ['🔰节点选择','🎯全球直连','🛑全球拦截','🇭🇰香港节点','🇺🇸美国节点','🇹🇼台湾节点','🇯🇵日本节点','🇸🇬新加坡节点']

{% if customParams.adBlock.filter | default(false) %}
# 去广告（域名级）。anti-AD 是中文区命中率最高的广告域名表，每天更新，由 mihomo 自己拉取。
# 注意：Clash / mihomo 没有 MITM 能力，**做不了 App 开屏广告拦截**——开屏广告的接口挂在 App 自己
# 的主域名上，只能靠解密 HTTPS 后精确改写那几个 URL。那部分只在 QuantumultX.conf 里。
rule-providers:
  anti-ad:
    type: http
    behavior: domain
    format: yaml
    url: https://anti-ad.net/clash.yaml
    path: ./ruleset/anti-ad.yaml
    interval: 86400

{% endif %}
{% include "_rules-clash.tpl" %}
