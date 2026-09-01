# https://github.com/crossutility/Quantumult-X/blob/master/sample.conf

[general]
server_check_url=http://cp.cloudflare.com/generate_204

[dns]
server=223.5.5.5
server=223.6.6.6

[server_local]
{{ getQuantumultXNodes(nodeList) }}

[server_remote]

[policy]
static=🎯全球直连,DIRECT
static=🛑全球拦截,REJECT
available=♻️自动选择,{{ getNodeNames(nodeList) }}
static=🔰节点选择,🎯全球直连,🛑全球拦截,♻️自动选择,{{ getNodeNames(nodeList) }}
available=🇭🇰香港节点,{{ getNodeNames(nodeList, hkFilter) }}
static=🇺🇸美国节点,{{ getNodeNames(nodeList, usFilter) }}
available=🇹🇼台湾节点,{{ getNodeNames(nodeList, taiwanFilter) }}
available=🇯🇵日本节点,{{ getNodeNames(nodeList, japanFilter) }}
available=🇸🇬新加坡节点,{{ getNodeNames(nodeList, singaporeFilter) }}
static=🇨🇳大陆网站,🎯全球直连
static=📢广告链接,🛑全球拦截
static=🤖AIPlatforms,🇺🇸美国节点,🇹🇼台湾节点,🇯🇵日本节点,🇸🇬新加坡节点,🔰节点选择
static=👨‍🔬学术网站,🔰节点选择,🇭🇰香港节点,🇺🇸美国节点,🇹🇼台湾节点,🇯🇵日本节点,🇸🇬新加坡节点,🎯全球直连,🛑全球拦截
static=🟦Microsoft服务,🎯全球直连,🔰节点选择,🇭🇰香港节点,🇺🇸美国节点,🇹🇼台湾节点,🇯🇵日本节点,🇸🇬新加坡节点,🛑全球拦截
static=📺YouTube视频,🔰节点选择,🇭🇰香港节点,🇺🇸美国节点,🇹🇼台湾节点,🇯🇵日本节点,🇸🇬新加坡节点,🎯全球直连,🛑全球拦截
static=🍎Apple服务,🎯全球直连,🔰节点选择,🇭🇰香港节点,🇺🇸美国节点,🇹🇼台湾节点,🇯🇵日本节点,🇸🇬新加坡节点,🛑全球拦截
static=🐟无匹配规则,🔰节点选择,🎯全球直连,🛑全球拦截,🇭🇰香港节点,🇺🇸美国节点,🇹🇼台湾节点,🇯🇵日本节点,🇸🇬新加坡节点

[filter_remote]
# ------------------------------------------------------------
#  去广告 · 第一层：域名级（不需要 MITM，也不用装证书）
#  把广告 SDK 的域名整个拒掉。开关在 surgio.conf.js 的 customParams.adBlock.filter。
#  规则由 QuantumultX 自己每天从上游拉取更新，不需要重新 npm run generate。
# ------------------------------------------------------------
# 广告拦截合集@奶思：中文 App / 小程序的广告域名。规则行自带 reject 策略，所以不能设 force-policy。
https://raw.githubusercontent.com/fmz200/wool_scripts/main/QuantumultX/filter/filter.list, tag=去广告-域名@奶思, update-interval=86400, opt-parser=false, enabled={{ customParams.adBlock.filter | default(false) }}
# AdvertisingLite@blackmatrix7：通用广告域名黑名单，统一交给 📢广告链接 策略组（可在 QX 里一键切成直连来临时放行）。
https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/QuantumultX/AdvertisingLite/AdvertisingLite.list, tag=去广告-域名@bm7, force-policy=📢广告链接, update-interval=86400, opt-parser=false, enabled={{ customParams.adBlock.filter | default(false) }}

[filter_local]
DOMAIN-SUFFIX,local,DIRECT
{% if customParams.proxySuffixes %}
{% for suffix in customParams.proxySuffixes %}
DOMAIN-SUFFIX,{{ suffix }},🔰节点选择
{% endfor %}
{% endif %}
{% if customParams.directSuffixes %}
{% for suffix in customParams.directSuffixes %}
DOMAIN-SUFFIX,{{ suffix }},🎯全球直连
{% endfor %}
{% endif %}
IP-CIDR,127.0.0.0/8,DIRECT
IP-CIDR,172.16.0.0/12,DIRECT
IP-CIDR,192.168.0.0/16,DIRECT
IP-CIDR,10.0.0.0/8,DIRECT
IP-CIDR,100.64.0.0/10,DIRECT
{% if remoteSnippets.china %}
{{ remoteSnippets.china.main('🇨🇳大陆网站') | quantumultx }}
{% endif %}
{% if remoteSnippets.china_ip %}
{{ remoteSnippets.china_ip.main('🇨🇳大陆网站') | quantumultx }}
{% endif %}
{% if remoteSnippets.apple %}
{{ remoteSnippets.apple.main('🍎Apple服务') | quantumultx }}
{% endif %}
{% if remoteSnippets.Microsoft %}
{{ remoteSnippets.Microsoft.main('🟦Microsoft服务') | quantumultx }}
{% endif %}
{% if remoteSnippets.onedrive %}
{{ remoteSnippets.onedrive.main('🟦Microsoft服务') | quantumultx }}
{% endif %}
{% if remoteSnippets.scholar %}
{{ remoteSnippets.scholar.main('👨‍🔬学术网站') | quantumultx }}
{% endif %}
{% if remoteSnippets.youtube_music %}
{{ remoteSnippets.youtube_music.main('📺YouTube视频') | quantumultx }}
{% endif %}
{% if remoteSnippets.youtube %}
{{ remoteSnippets.youtube.main('📺YouTube视频') | quantumultx }}
{% endif %}
{% if remoteSnippets.OpenAI %}
{{ remoteSnippets.OpenAI.main('🤖AIPlatforms') | quantumultx }}
{% endif %}
{% if remoteSnippets.Gemini %}
{{ remoteSnippets.Gemini.main('🤖AIPlatforms') | quantumultx }}
{% endif %}
{% if remoteSnippets.Claude %}
{{ remoteSnippets.Claude.main('🤖AIPlatforms') | quantumultx }}
{% endif %}
{% if remoteSnippets.Docker %}
{{ remoteSnippets.Docker.main('👨‍🔬学术网站') | quantumultx }}
{% endif %}
GEOIP,CN,🇨🇳大陆网站

# Final
FINAL,🐟无匹配规则

# ============================================================
#  去广告 · 第二层：改写级（开屏广告靠这一层）
#
#  开屏广告的接口一般挂在 App 自己的主域名上（例如 api.某app.com/xxx/splash），
#  整域拒掉 App 就废了，所以只能解密 HTTPS、精确匹配那几个 URL、把响应换成空 JSON。
#  解密 = MITM，因此**必须**在 QuantumultX 里生成 CA 证书、安装、并在
#  iOS「设置 → 通用 → 关于本机 → 证书信任设置」里打开信任开关（这一步最容易漏）。
#
#  开关在 surgio.conf.js 的 customParams.adBlock。详见 README「去广告与开屏广告拦截」。
# ============================================================
[mitm]
# 正向 hostname 不用手写：下面 [rewrite_remote] 的规则文件自带 hostname 行，QX 会自动合并进来。
# 这里只写「排除」项（前缀 -），列出的域名永不解密。
{% if customParams.adBlock.mitmExclude %}
hostname = {% for h in customParams.adBlock.mitmExclude %}-{{ h }}{% if not loop.last %}, {% endif %}{% endfor %}
{% endif %}
# 上游服务器证书异常时仍继续连接。默认关闭（更安全）；若开了 MITM 后某些站点连不上再考虑打开。
# skip_validating_cert = true

[rewrite_local]
# 本地改写规则写这里。远程规则够用的话不用动；自己抓包写的规则放这里不会被远程更新覆盖。

[rewrite_remote]
# 广告拦截合集-重写@奶思：约 730 款 App / 小程序，其中 100+ 处是开屏广告。上游每周更新。
https://raw.githubusercontent.com/fmz200/wool_scripts/main/QuantumultX/rewrite/rewrite.snippet, tag=开屏广告拦截@奶思, update-interval=86400, opt-parser=false, enabled={{ customParams.adBlock.splash | default(false) }}
# App & 小程序净化合集@奶思：去掉冗余模块/浮窗。上游标注「遇到异常时关闭此配置」，默认关。
https://raw.githubusercontent.com/fmz200/wool_scripts/main/QuantumultX/rewrite/cleanup.snippet, tag=App净化@奶思, update-interval=86400, opt-parser=false, enabled={{ customParams.adBlock.cleanup | default(false) }}
# AdvertisingLite 改写@blackmatrix7：与上面的开屏规则有重叠，需要更大覆盖面时再开。
https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rewrite/QuantumultX/AdvertisingLite/AdvertisingLite.conf, tag=去广告-改写@bm7, update-interval=86400, opt-parser=false, enabled={{ customParams.adBlock.extraSplash | default(false) }}
# AdvertisingScript@blackmatrix7：脚本类改写。开它的唯一理由是**补上 B站开屏**（上面的主力规则集没覆盖 B站），
# 顺带覆盖什么值得买。但它同时会用一份 2025 年的第三方 gist 脚本重写「知乎」的信息流/回答/消息等核心接口
# —— 不是纯去广告，爆炸半径大且规则已一年未更新。默认关；只想要 B站开屏的话，比起开这个，
# 更建议把那一条规则单独抄进上面的 [rewrite_local]。
https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rewrite/QuantumultX/AdvertisingScript/AdvertisingScript.conf, tag=去广告-脚本@bm7, update-interval=86400, opt-parser=false, enabled={{ customParams.adBlock.scriptSplash | default(false) }}
