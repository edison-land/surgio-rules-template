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
  proxies: ['🎯全球直连','🛑全球拦截']
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

rules:
- DOMAIN-SUFFIX,local,DIRECT
# 微信 / 腾讯 - 显式直连，避免 TUN + 代理双开时 CDN anycast 路由抖动
- DOMAIN-SUFFIX,qpic.cn,DIRECT
- DOMAIN-SUFFIX,weixin.qq.com,DIRECT
- DOMAIN-SUFFIX,wx.qq.com,DIRECT
- DOMAIN-SUFFIX,wechat.com,DIRECT
- DOMAIN-SUFFIX,mmfile.qq.com,DIRECT
- DOMAIN-SUFFIX,mmsns.qpic.cn,DIRECT
{% if customParams.proxySuffixes %}
{% for suffix in customParams.proxySuffixes %}
- DOMAIN-SUFFIX,{{ suffix }},🔰节点选择
{% endfor %}
{% endif %}
{% if customParams.directSuffixes %}
{% for suffix in customParams.directSuffixes %}
- DOMAIN-SUFFIX,{{ suffix }},🎯全球直连
{% endfor %}
{% endif %}
{% if customParams.directIPs %}
{% for ip in customParams.directIPs %}
- IP-CIDR,{{ ip }}/32,DIRECT,no-resolve
{% endfor %}
{% endif %}
- IP-CIDR,127.0.0.0/8,DIRECT,no-resolve
- IP-CIDR,172.16.0.0/12,DIRECT,no-resolve
- IP-CIDR,192.168.0.0/16,DIRECT,no-resolve
- IP-CIDR,10.0.0.0/8,DIRECT,no-resolve
- IP-CIDR,100.64.0.0/10,DIRECT,no-resolve
{% if remoteSnippets.china %}
{{ remoteSnippets.china.main('🇨🇳大陆网站') | clash }}
{% endif %}
{% if remoteSnippets.china_ip %}
{{ remoteSnippets.china_ip.main('🇨🇳大陆网站') | clash }}
{% endif %}
{% if remoteSnippets.apple %}
{{ remoteSnippets.apple.main('🍎Apple服务') | clash }}
{% endif %}
{% if remoteSnippets.Microsoft %}
{{ remoteSnippets.Microsoft.main('🟦Microsoft服务') | clash }}
{% endif %}
{% if remoteSnippets.onedrive %}
{{ remoteSnippets.onedrive.main('🟦Microsoft服务') | clash }}
{% endif %}
{% if remoteSnippets.scholar %}
{{ remoteSnippets.scholar.main('👨‍🔬学术网站') | clash }}
{% endif %}
{% if remoteSnippets.youtube_music %}
{{ remoteSnippets.youtube_music.main('📺YouTube视频') | clash }}
{% endif %}
{% if remoteSnippets.youtube %}
{{ remoteSnippets.youtube.main('📺YouTube视频') | clash }}
{% endif %}
{% if remoteSnippets.OpenAI %}
{{ remoteSnippets.OpenAI.main('🤖AIPlatforms') | clash }}
{% endif %}
{% if remoteSnippets.Gemini %}
{{ remoteSnippets.Gemini.main('🤖AIPlatforms') | clash }}
{% endif %}
{% if remoteSnippets.Claude %}
{{ remoteSnippets.Claude.main('🤖AIPlatforms') | clash }}
{% endif %}
{% if remoteSnippets.Docker %}
{{ remoteSnippets.Docker.main('👨‍🔬学术网站') | clash }}
{% endif %}
- GEOIP,CN,🇨🇳大陆网站


# Final
- MATCH,🐟无匹配规则
