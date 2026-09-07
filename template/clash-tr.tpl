# {{ downloadUrl }}
#
# 自建节点版（白名单模式）。
#   国内域名 / 国内 IP / 微信 → 直连，其余全部走 🚀代理。
#   不按服务分策略组，也不接去广告规则——自建节点通常只有一两个，
#   没有「这个服务该用哪个地区的节点」这种选择题。
#   要按服务分流、要去广告，用机场版的 Clash.yaml。

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
- name: 🚀代理
  type: select
  # 节点在前，DIRECT 垫底：默认就是走节点（select 组取第一项为默认值），
  # 需要临时全局直连时在客户端里切一下即可。
  proxies: {{ getClashNodeNames(nodeList).concat(['DIRECT']) | json }}

rules:
- DOMAIN-SUFFIX,local,DIRECT
{% include "_wechat-direct-clash.tpl" %}
# 视频号的视频流：finder*.video.qq.com
- DOMAIN-SUFFIX,video.qq.com,DIRECT
{% if customParams.proxySuffixes %}
{% for suffix in customParams.proxySuffixes %}
- DOMAIN-SUFFIX,{{ suffix }},🚀代理
{% endfor %}
{% endif %}
{% if customParams.directSuffixes %}
{% for suffix in customParams.directSuffixes %}
- DOMAIN-SUFFIX,{{ suffix }},DIRECT
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
{{ remoteSnippets.china.main('DIRECT') | clash }}
{% endif %}
{% if remoteSnippets.china_ip %}
{{ remoteSnippets.china_ip.main('DIRECT') | clash }}
{% endif %}
- GEOIP,CN,DIRECT


# Final
- MATCH,🚀代理
