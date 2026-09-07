{#
  微信 / 视频号必须直连的域名。quantumultx.tpl 与 quantumultx-tr.tpl 共用。
  QX 的本地规则优先于 [filter_remote]，所以这里可以直接包含 video.qq.com。
#}
# 微信 / 视频号 - 显式直连。上游广告表里有 wxs.qq.com 这类整域拦截，
# 而它正是视频号与朋友圈的图片、视频 CDN，被拦掉就只会转圈。
DOMAIN-SUFFIX,weixin.qq.com,DIRECT
DOMAIN-SUFFIX,wx.qq.com,DIRECT
DOMAIN-SUFFIX,wechat.com,DIRECT
DOMAIN-SUFFIX,mmfile.qq.com,DIRECT
DOMAIN-SUFFIX,qpic.cn,DIRECT
DOMAIN-SUFFIX,qlogo.cn,DIRECT
DOMAIN-SUFFIX,servicewechat.com,DIRECT
DOMAIN-SUFFIX,wx.gtimg.com,DIRECT
DOMAIN-SUFFIX,wxs.qq.com,DIRECT
DOMAIN-SUFFIX,vweixinthumb.tc.qq.com,DIRECT
DOMAIN-SUFFIX,wxapp.tc.qq.com,DIRECT
DOMAIN,vweixinf.tc.qq.com,DIRECT
DOMAIN-SUFFIX,video.qq.com,DIRECT
