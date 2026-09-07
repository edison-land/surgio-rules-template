{#
  微信 / 视频号必须直连的域名。clash.tpl 与 clash-tr.tpl 共用。
  注意：不含 video.qq.com —— 主模板要把它放在 anti-ad 之后，好让腾讯视频的广告域名仍被拦截；
  引用方在需要的位置自己加那一行。
#}
# 微信 / 腾讯 - 显式直连，避免 TUN + 代理双开时 CDN anycast 路由抖动。
# 这一段必须排在任何广告规则前面：anti-ad 里有 `+.wxs.qq.com`、`+.as.weixin.qq.com` 这类
# **整域**拦截，而 wxs.qq.com / tc.qq.com 正是视频号与朋友圈的图片、视频 CDN，
# 一旦被 reject，聊天正常但视频号只会转圈。
- DOMAIN-SUFFIX,weixin.qq.com,DIRECT
- DOMAIN-SUFFIX,wx.qq.com,DIRECT
- DOMAIN-SUFFIX,wechat.com,DIRECT
- DOMAIN-SUFFIX,mmfile.qq.com,DIRECT
- DOMAIN-SUFFIX,qpic.cn,DIRECT
- DOMAIN-SUFFIX,mmsns.qpic.cn,DIRECT
- DOMAIN-SUFFIX,qlogo.cn,DIRECT
- DOMAIN-SUFFIX,servicewechat.com,DIRECT
- DOMAIN-SUFFIX,wx.gtimg.com,DIRECT
# 视频号 / 朋友圈的图片与视频 CDN
- DOMAIN-SUFFIX,wxs.qq.com,DIRECT
- DOMAIN-SUFFIX,vweixinthumb.tc.qq.com,DIRECT
- DOMAIN-SUFFIX,wxapp.tc.qq.com,DIRECT
- DOMAIN,vweixinf.tc.qq.com,DIRECT
