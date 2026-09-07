{#
  微信 / 视频号必须直连的域名。quantumultx.tpl 与 quantumultx-tr.tpl 共用。
  QX 官方 sample.conf 没有写明 filter_local 与 filter_remote 的优先级，所以这里不依赖顺序：
  实际核对过两个远程广告表，它们只拦 wxsnsdythumb.wxs.qq.com（朋友圈广告缩略图）和
  gu/py/py2.qlogo.cn，没有整域拦 wxs.qq.com —— 整域拦截只出现在 Clash 用的 anti-ad 里。
#}
# 微信 / 视频号 - 显式直连。
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
