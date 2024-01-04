---
layout: post
title: GlobalProtect配合privacyIDEA做邮箱或TOTP二步验证
date: 2023-06-16 11:38:00
updated: 2023-06-20 16:31:00
keywords: Palo Alto, Global Protect, TOTP
categories: PaloAlto
---
    <p>#Author https://cnblogs.com/id404</p>
<p>本文重点在privacyIDEA的配置上，GlobalProtect只需将认证服务器设置为radius和勾选二步认证的选项。</p>
<h1>一、privacyIDEA安装</h1>
<p>privacyIDEA作为radius服务器存储用户信息，并进行邮箱二步验证。GlobalProtect对接外部radius服务器为privacyIDEA</p>
<p>当GlobalProtect用户登陆时，PA向privacyIDEA读取用户账号密码信息并进行验证，邮件发送验证码至用户的邮箱，验证通过后用户上线</p>
<p>&nbsp;</p>
<p>先安装好ubuntu 22.04.2 LTS</p>
<p>&nbsp;</p>
<div class="style-scope ytd-watch-metadata">
<div id="items" class="style-scope ytd-structured-description-content-renderer">
<div class="cnblogs_code">
<pre><span style="color: #000000;">#下载签名密钥

</span><span style="color: #0000ff;">wget</span> https:<span style="color: #008000;">//</span><span style="color: #008000;">lancelot.netknights.it/NetKnights-Release.asc</span>
<span style="color: #000000;">
 

#确认指纹

gpg </span>--import --import-options show-only --with-fingerprint NetKnights-<span style="color: #000000;">Release.asc

 

#添加签名密钥

</span><span style="color: #0000ff;">mv</span> NetKnights-Release.asc /etc/apt/trusted.gpg.d/<span style="color: #000000;">

 

#添加仓库

add</span>-apt-repository http:<span style="color: #008000;">//</span><span style="color: #008000;">lancelot.netknights.it/community/jammy/stable</span>
<span style="color: #000000;">
 

#privacyIDEA安装

privacyIDEA Installation: apt update </span>&amp;&amp; apt <span style="color: #0000ff;">install</span> privacyidea-apache2 privacyidea-radius -<span style="color: #000000;">y

 

#添加privacyIDEA web管理员

pi</span>-manage admin add admin -<span style="color: #000000;">e admin@localhost

 

#添加 privacyIDEA 本地认证用户:

</span>/opt/privacyidea<span style="color: #008000;">//</span><span style="color: #008000;">bin/privacyidea-create-pwidresolver-user -u ljc -i 10 -p 123456.com -d 'User LJC' &gt;&gt; /etc/privacyidea/privacyidea_user</span>
<span style="color: #000000;">
#其中ljc为用户名 </span><span style="color: #800080;">123456</span>.com为密码<br /><br /></pre>
</div>
<p>&nbsp;</p>
<h2>1.2 配置radius客户端</h2>
<p>vi /etc/freeradius/3.0/clients.conf</p>
<p>在# IPv6 Client前面增加</p>
<pre class="language-bash highlighter-hljs"><code>client palo_alto {
        ipaddr  = 192.168.0.24
        secret  = pasecret123
}</code></pre>
<p>保存退出后重启freeradius</p>
<p>systemctl restart freeradius</p>
<p>&nbsp;</p>
<h1>二、privacyIDEA 配置</h1>
<h2>2.1隐藏web欢迎信息</h2>
<p><img src="/images/blog/725676-20230616100027128-733534197.png" /></p>
<p><img src="/images/blog/725676-20230616100108425-1329370438.png" /></p>
<p>搜索hide,勾选hide_welcome_info隐藏web界面欢迎信息</p>
<p><img src="/images/blog/725676-20230616100204876-1571710815.png" /></p>
<p>修改web超时时间</p>
<p><img src="/images/blog/725676-20230616100831118-1917432630.png" /></p>
<h2>&nbsp;</h2>
<h2>2.2创建认证域</h2>
<p><img src="/images/blog/725676-20230616101113542-376318775.png" /></p>
<p><img src="/images/blog/725676-20230616101228105-1060841584.png" width="903" height="210" /></p>
<h2>2.3创建认证数据库</h2>
<p><img src="/images/blog/725676-20230616101723975-1067927058.png" /></p>
<p>File name 选择第一步安装privacyIDEA时创建的本地密码数据库文件 /etc/privacyidea/privacyidea_user&nbsp;</p>
<p><img src="/images/blog/725676-20230616101745342-1083620739.png" /></p>
<p>返回认证域选择刚刚创建的本地密码数据库并设置优先级</p>
<p><img src="/images/blog/725676-20230616102033449-1329883490.png" width="937" height="265" /></p>
<h2>2.4 设置邮件发送服务器</h2>
<p><img src="/images/blog/725676-20230616102259247-1668756456.png" /></p>
<p>填写邮件服务器的相关信息，并保存。填写完毕可点击Send Test Email测试配置是否正确</p>
<p><img src="/images/blog/725676-20230616102338736-324995956.png" /></p>
<h2>&nbsp;</h2>
<h2>2.5 设置用户邮件Email Token及超时时间</h2>
<p>设置全局超时时间设备为10分钟&nbsp;</p>
<p><img src="/images/blog/725676-20230616102650235-362625224.png" width="1016" height="444" /></p>
<p>设置单个用户的邮箱</p>
<p><img src="/images/blog/725676-20230616103310768-1986249975.png" width="962" height="669" /></p>
<p>&nbsp;</p>
<h2>2.6 设置认证策略</h2>
<p><img src="/images/blog/725676-20230616103613974-1171755156.png" /></p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230616103646846-1670021011.png" width="706" height="320" /></p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230616103732897-923331568.png" /></p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230616103920567-1529622117.png" /></p>
<p>输入：Please enter the code you received email</p>
<p>这段文字会出现输入验证码的界面</p>
<p><img src="/images/blog/725676-20230616103937776-853296558.png" /></p>
<p>&nbsp;</p>
<p><span class="ui-highlight">email</span>_challenge_text： Please enter the code you received email</p>
<p><span class="ui-highlight">email</span>subject(邮件标题)： I think you just received a PaloAlto GlobalProtect OTP</p>
<p><span class="ui-highlight">email</span>text(邮件内容)： {otp} is the you received OTP</p>
<p><img src="/images/blog/725676-20230616104245308-6818305.png" /></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230616104528330-1859415741.png" /></p>
<p>&nbsp;</p>
<p>保存后的策略</p>
<p><img src="/images/blog/725676-20230616104634290-751164807.png" width="993" height="304" /></p>
<h1>三、Palo Alto 配置</h1>
<p>具体GlobalProtect的配置可参考另一篇博文，这里不再叙述 <a href="https://www.cnblogs.com/id404/p/17465413.html">https://www.cnblogs.com/id404/p/17465413.html</a></p>
<h2>3.1 radius配置</h2>
<p>确认radius的服务路由，设备默认从管理口发送radius请求，若需要从其它接口发送radius请求</p>
<p><img src="/images/blog/725676-20230616105753311-102481042.png" width="841" height="424" /></p>
<p><img src="/images/blog/725676-20230616110526223-835121321.png" /></p>
<p>&nbsp;</p>
<p>门户将身份验证配置文件改为 radius</p>
<p><img src="/images/blog/725676-20230616110732106-2104680289.png" width="909" height="552" /></p>
<p>代理将双因素认证选上</p>
<p><img src="/images/blog/725676-20230616110949868-298831810.png" width="851" height="442" /></p>
<p>网关将身份验证配置文件改为 radius</p>
<p><img src="/images/blog/725676-20230616111612339-1695989153.png" /></p>
<h1>三、客户端登陆</h1>
<h2>3.1 门户登陆</h2>
<p><img src="/images/blog/725676-20230616112205072-1381800338.png" /></p>
<p><img src="/images/blog/725676-20230616112914008-1165996427.png" /></p>
<p><img src="/images/blog/725676-20230616113031697-1923447056.png" width="611" height="222" /></p>
<p>登陆成功</p>
<p><img src="/images/blog/725676-20230616113112262-922471552.png" /></p>
<p>&nbsp;</p>
<p>客户端登陆&nbsp;</p>
<p><img src="/images/blog/725676-20230616113314209-313897771.png" width="238" height="364" /></p>
<p><img src="/images/blog/725676-20230616113353195-1806458623.png" width="437" height="299" /></p>
<p><img src="/images/blog/725676-20230616113429475-536340447.png" width="278" height="377" /></p>
<p>PA上可以看到用户成功连接&nbsp;</p>
<p><img src="/images/blog/725676-20230616113635206-38732808.png" /></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<h1>四、TOTP二步验证</h1>
<h2>4.1 privicyIDEA配置-用户token</h2>
<p>删除并新建用户token</p>
<p>删除之前针对用户建立的EMAIL token</p>
<p><img src="/images/blog/725676-20230620124327589-450632402.png" alt="" loading="lazy" /></p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230620124445857-818770970.png" alt="" loading="lazy" /></p>
<p>&nbsp;</p>
<p>新建用户TOTP token</p>
<p><img src="/images/blog/725676-20230620124600490-778844857.png" alt="" width="1018" height="647" loading="lazy" /></p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230620163059713-337081262.png" alt="" width="862" height="417" loading="lazy" /></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>用google authentior或其它TOTP二步验证工具扫描二维码</p>
<p><img src="/images/blog/725676-20230620125058254-1640245207.png" alt="" loading="lazy" /></p>
<p>&nbsp;</p>
<h2>4.2 privicyIDEA配置-认证策略</h2>
<p><img src="/images/blog/725676-20230620125234823-1826933897.png" alt="" width="981" height="452" loading="lazy" /></p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230620125346246-1697031708.png" alt="" width="1035" height="555" loading="lazy" /></p>
<p>&nbsp;</p>
<p>取消前面步骤配置的Email选项，只选择以下四项</p>
<p>challenge_response填写 TOTP</p>
<p>challenge_text 内容随意，主要用于提醒用户输入二步验证密码</p>
<p><img src="/images/blog/725676-20230620125414246-1176768905.png" alt="" loading="lazy" /></p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230620125437628-1296485199.png" alt="" loading="lazy" /></p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230620125457902-962523211.png" alt="" loading="lazy" /></p>
<h2>4.3 用户登陆&nbsp;</h2>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230620133129053-908836607.png" alt="" loading="lazy" /></p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230620133211323-1765699456.png" alt="" loading="lazy" /></p>
<p>&nbsp;登陆成功</p>
<p><img src="/images/blog/725676-20230620133307297-1729110753.png" alt="" loading="lazy" /></p>
<p>&nbsp;客户端登陆&nbsp;</p>
<p><img src="/images/blog/725676-20230620133352925-104810645.png" alt="" loading="lazy" /></p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230620133423274-2091400453.png" alt="" loading="lazy" /></p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230620133454970-1641024766.png" alt="" loading="lazy" /></p>
<h1>&nbsp;五、多种认证方式</h1>
<p>比如用户1 使用邮件二次认证 用户2、3使用TOTP二次认证，用户4直接密码认证不做二次认证，可创建多条策略policy,针对不同用户做不同认证</p>
<p><img src="/images/blog/725676-20230620142758260-766076876.png" alt="" width="922" height="349" loading="lazy" /></p>
<p>&nbsp;</p>
</div>
</div>
    