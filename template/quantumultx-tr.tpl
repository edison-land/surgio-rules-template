# https://github.com/crossutility/Quantumult-X/blob/master/sample.conf
#
# 自建节点版（白名单模式）：国内域名 / 国内 IP / 微信 → 直连，其余走 🚀代理。
# 不按服务分流，但域名级去广告与开屏广告拦截都跟机场版一样有，
# 开关同为 surgio.conf.js 里的 customParams.adBlock。开屏那层需要装并信任 QX 证书，见 README。

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
static=📢广告链接,reject,direct

[filter_remote]
# 广告拦截合集@奶思：中文 App / 小程序的广告域名。规则行自带 reject 策略，所以不能设 force-policy。
https://raw.githubusercontent.com/fmz200/wool_scripts/main/QuantumultX/filter/filter.list, tag=去广告-域名@奶思, update-interval=86400, opt-parser=false, enabled={{ customParams.adBlock.filter | default(false) }}
# AdvertisingLite@blackmatrix7：通用广告域名黑名单，统一交给 📢广告链接（可在 QX 里一键切成 direct 放行）。
https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/QuantumultX/AdvertisingLite/AdvertisingLite.list, tag=去广告-域名@bm7, force-policy=📢广告链接, update-interval=86400, opt-parser=false, enabled={{ customParams.adBlock.filter | default(false) }}

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
# 正向 hostname 不用手写：下面 [rewrite_remote] 的规则文件自带 hostname 行，QX 会自动合并进来。
# 这里只写「排除」项（前缀 -），列出的域名永不解密。
{% if customParams.adBlock.mitmExclude %}
hostname = {% for h in customParams.adBlock.mitmExclude %}-{{ h }}{% if not loop.last %}, {% endif %}{% endfor %}
{% endif %}

[rewrite_local]
# 自己抓包写的改写规则放这里，不会被远程更新覆盖。

[rewrite_remote]
# 广告拦截合集-重写@奶思：约 730 款 App / 小程序，其中 100+ 处是开屏广告。
# 需要 MITM：QX 里生成并安装证书 → iOS 设置里打开信任 → 清 App 缓存，缺一步都不生效。
https://raw.githubusercontent.com/fmz200/wool_scripts/main/QuantumultX/rewrite/rewrite.snippet, tag=开屏广告拦截@奶思, update-interval=86400, opt-parser=false, enabled={{ customParams.adBlock.splash | default(false) }}
# App & 小程序净化合集@奶思：去掉冗余模块/浮窗。上游标注「遇到异常时关闭此配置」，默认关。
https://raw.githubusercontent.com/fmz200/wool_scripts/main/QuantumultX/rewrite/cleanup.snippet, tag=App净化@奶思, update-interval=86400, opt-parser=false, enabled={{ customParams.adBlock.cleanup | default(false) }}
