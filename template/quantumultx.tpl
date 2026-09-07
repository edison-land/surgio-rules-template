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

{% include "_filters-quantumultx.tpl" %}
