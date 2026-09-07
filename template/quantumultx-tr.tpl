# https://github.com/crossutility/Quantumult-X/blob/master/sample.conf
#
# 自建节点版（白名单模式）：国内域名 / 国内 IP / 微信 → 直连，其余走 🚀代理。
# 不按服务分流、不接去广告与开屏广告改写——要那些用机场版的 QuantumultX.conf。

[general]
server_check_url=http://cp.cloudflare.com/generate_204

[dns]
server=223.5.5.5
server=223.6.6.6

[server_local]
{{ getQuantumultXNodes(nodeList) }}

[server_remote]

[policy]
static=🚀代理,{{ getNodeNames(nodeList) }},direct

[filter_remote]

[filter_local]
DOMAIN-SUFFIX,local,DIRECT
{% include "_wechat-direct-quantumultx.tpl" %}
{% if customParams.proxySuffixes %}
{% for suffix in customParams.proxySuffixes %}
DOMAIN-SUFFIX,{{ suffix }},🚀代理
{% endfor %}
{% endif %}
{% if customParams.directSuffixes %}
{% for suffix in customParams.directSuffixes %}
DOMAIN-SUFFIX,{{ suffix }},DIRECT
{% endfor %}
{% endif %}
IP-CIDR,127.0.0.0/8,DIRECT
IP-CIDR,172.16.0.0/12,DIRECT
IP-CIDR,192.168.0.0/16,DIRECT
IP-CIDR,10.0.0.0/8,DIRECT
IP-CIDR,100.64.0.0/10,DIRECT
{% if remoteSnippets.china %}
{{ remoteSnippets.china.main('DIRECT') | quantumultx }}
{% endif %}
{% if remoteSnippets.china_ip %}
{{ remoteSnippets.china_ip.main('DIRECT') | quantumultx }}
{% endif %}
GEOIP,CN,DIRECT

# Final
FINAL,🚀代理

[mitm]

[rewrite_local]

[rewrite_remote]
