{#
  机场版（clash.tpl）的分流规则：按服务分策略组（AI / 学术 / YouTube / Apple / 微软…）。
  自建节点版（clash-tr.tpl）走白名单模式，规则简单得多，不用这一份；
  两者共用的只有 _wechat-direct-clash.tpl。
#}
rules:
- DOMAIN-SUFFIX,local,DIRECT
{% include "_wechat-direct-clash.tpl" %}
{% if customParams.adBlock.filter | default(false) %}
- RULE-SET,anti-ad,📢广告链接
{% endif %}
# 视频号的视频流挂在 video.qq.com 下（finder*.video.qq.com）。放在 anti-ad 之后，
# 这样腾讯视频自己的广告域名（adss.video.qq.com 等）仍然会被广告规则命中。
- DOMAIN-SUFFIX,video.qq.com,DIRECT
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
