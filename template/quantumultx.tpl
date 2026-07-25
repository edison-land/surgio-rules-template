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
#  以下三个区块用于「脚本改写 / 去广告」，默认留空。
#  需要时自己往里加（本模板不预置任何 MITM 改写规则）。
# ============================================================
[mitm]

[rewrite_local]

[rewrite_remote]
