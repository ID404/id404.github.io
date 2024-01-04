---
layout: post
title: GlobalProtect配合privacyIDEA对接ldap做二步验证
keywords: Globalprotect, privacyIDEA
description: GlobalProtect配合privacyIDEA对接ldap做二步验证
categories: PaloAlto
---
<p>#Author https://cnblogs.com/id404</p>
<p>GlobalProtect的和privacyIDEA的安装部署及基础设置可参考前一篇博文</p>
<p><a href="https://www.cnblogs.com/id404/p/17484847.html">https://www.cnblogs.com/id404/p/17484847.html</a></p>
<p>&nbsp;</p>
<p>PaloAlto设备在前一篇文章的基础不需要修改，本文重点在privacyIDEA的配置上</p>
<p>&nbsp;</p>
<h1>一、对接ldap</h1>
<p><img src="/images/blog/725676-20230628153538455-34449494.png" alt="" width="887" height="416" loading="lazy" /></p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230628153654855-603044837.png" alt="" loading="lazy" /></p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230628153721006-1373181901.png" alt="" loading="lazy" /></p>
<p>&nbsp;点击Test LDAP Resolver 显示成功并发现用户即LDAP对接成功</p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230628153824566-234084508.png" alt="" width="595" height="140" loading="lazy" /></p>
<p>&nbsp;</p>
<h1>二、默认认证域添加ldap用户源</h1>
<p><img src="/images/blog/725676-20230628153940254-1072421161.png" alt="" width="840" height="178" loading="lazy" /></p>
<p>&nbsp;</p>
<h1>&nbsp;三、认证策略修改</h1>
<p><img src="/images/blog/725676-20230628154037903-409371475.png" alt="" loading="lazy" /></p>
<p>&nbsp;</p>
<p>用户源添加ldap</p>
<p>用户添加idap用户</p>
<p><img src="/images/blog/725676-20230628154142514-1362200961.png" alt="" loading="lazy" /></p>
<p>&nbsp;</p>
<h1>四、针对用户生成二步验证token</h1>
<p><img src="/images/blog/725676-20230628154337595-369642670.png" alt="" loading="lazy" /></p>
<p>&nbsp;用手机扫描二维码</p>
<p><img src="/images/blog/725676-20230628154534057-59356892.png" alt="" loading="lazy" /></p>
<h1>&nbsp;五、登陆测试</h1>
<p><img src="/images/blog/725676-20230628154626668-2143477372.png" alt="" loading="lazy" /></p>
<p>&nbsp;登陆成功</p>
<p><img src="/images/blog/725676-20230628154740112-1748630410.png" alt="" loading="lazy" /></p>
<p>&nbsp;</p>
    
