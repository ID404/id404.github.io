---
    title: Palo Alto防火墙GlobalProtect配置
    date: 2023-06-08 10:18:00
    updated: 2023-06-21 16:42:00
    abbrlink: 17465413
    tags:
    categories:
    ---
    <p style="font-weight: 400;">&nbsp;#Author https://cnblogs.com/id404</p>
<h1><strong>一、证书设置</strong><strong>&nbsp;</strong></h1>
<p><img src="/images/blog/725676-20230608170952866-1142163017.png" alt="" width="714" height="62" /></p>
<p>&nbsp;</p>
<p style="font-weight: 400;">1、生成rootCA证书</p>
<p style="font-weight: 400;">证书名和常见名称可填写任意，一定要勾选&nbsp;证书授权机构</p>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608100142372-742370141.png" alt="" width="888" height="745" /></p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230611222748595-905786393.png" alt="" width="896" height="77" /></p>
<p>&nbsp;</p>
<p style="font-weight: 400;">&nbsp;</p>
<p style="font-weight: 400;">&nbsp;</p>
<p style="font-weight: 400;">&nbsp;</p>
<p style="font-weight: 400;">2、用生成的CA证书签发vpn证书</p>
<p style="font-weight: 400;">证书名称可填写任意</p>
<p style="font-weight: 400;">常见名称要填写<span style="color: #e03e2d;">公网的IP地址或域名</span>，至于是地址还是域名&nbsp;取决于登陆的时候是ip还是域名，这一项填写错误会导致客户端登陆的时候出现告警并无法连接</p>
<p style="font-weight: 400;">签名者要选择上一次生成的根证书</p>
<p style="font-weight: 400;">不能选择 证书授权机构</p>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608100229536-912165646.png" alt="" width="886" height="811" /></p>
<p id="1686189750673">&nbsp;</p>
<p style="font-weight: 400;">&nbsp;</p>
<p style="font-weight: 400;">3、用生成的证书签发用户证书</p>
<p style="font-weight: 400;">要求和上一步一样</p>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608100247249-1829944681.png" alt="" width="872" height="910" /></p>
<p id="1686189768376">&nbsp;</p>
<p style="font-weight: 400;">&nbsp;</p>
<p style="font-weight: 400;">4、配置SSL/TLS服务配置文件</p>
<p style="font-weight: 400;">证书需选择第2步中的证书</p>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608100304904-879751625.png" alt="" width="878" height="568" /></p>
<p id="1686189785958">&nbsp;</p>
<p style="font-weight: 400;"><span style="text-decoration: line-through;">证书也可以直接选择根证书。如果外网域名的IP变动频繁或有多个IP ，SSL/TLS服务配置文件无法选择多个web证书，web证书上的IP和实际连接的IP不一样时会 出现 &ldquo;<span style="background-color: #ff0000;">无法验证网关服务器证书</span>&rdquo;的错误 。此时证书可直接选择根证书GP_rootCA &nbsp;(经验证MAC OS能正常登陆 ，windows无法正常登陆，建议建多个portal 和gateway)</span></p>
<p>&nbsp;</p>
<p style="font-weight: 400;">&nbsp;</p>
<h1><strong>二、用户认证</strong></h1>
<p style="font-weight: 400;">1、新增本地用户</p>
<p style="font-weight: 400;">输入用户名和密码</p>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608100323073-1029489555.png" alt="" width="887" height="711" /></p>
<p id="1686189804255">&nbsp;</p>
<p style="font-weight: 400;">&nbsp;</p>
<p style="font-weight: 400;">2、设置身份验证配置文件</p>
<p style="font-weight: 400;">类型需选择本地数据库</p>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608100349075-1339086846.png" alt="" width="882" height="555" /></p>
<p><img src="/images/blog/725676-20230608100404130-1539661334.png" alt="" width="885" height="649" /></p>
<p style="font-weight: 400;">&nbsp;</p>
<p style="font-weight: 400;">&nbsp;</p>
<p style="font-weight: 400;">&nbsp;</p>
<h1><strong>三、配置隧道接口</strong></h1>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608100430459-1283859150.png" alt="" width="855" height="550" /></p>
<p><img src="/images/blog/725676-20230608100440180-2079642656.png" alt="" width="870" height="469" /></p>
<p>注意此处的IP地址与客户端地址同网段，客户端的数据经隧道接口转发至内网</p>
<h1>&nbsp;</h1>
<h1><strong>&nbsp;</strong></h1>
<h1><strong>四、配置</strong><strong>GlobalProtect</strong><strong>网关</strong></h1>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608100511809-314568099.png" alt="" width="858" height="533" /></p>
<p style="font-weight: 400;">接口选择外网接口，IPv4地址选择外网的IP</p>
<p style="font-weight: 400;">&nbsp;</p>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608100714766-1320895194.png" alt="" width="877" height="593" /></p>
<p><img src="/images/blog/725676-20230608100726683-1122499149.png" alt="" width="877" height="498" /></p>
<p><img src="/images/blog/725676-20230608100734313-2089724199.png" alt="" width="868" height="461" /></p>
<p><img src="/images/blog/725676-20230608100742107-1500411864.png" alt="" width="889" height="514" /></p>
<p><img src="/images/blog/725676-20230608100749711-1994310591.png" alt="" width="850" height="719" /></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>这里两个cookies的选项不建议勾选，否则PA上删除账号后 cookies还没过期的话账号依然能登陆</p>
<p><img src="/images/blog/725676-20230616205446089-1511377197.png" alt="" width="857" height="287" loading="lazy" /></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>地址池和隧道口同网段</p>
<p><img src="/images/blog/725676-20230608100803567-926524620.png" alt="" width="803" height="371" /></p>
<p style="font-weight: 400;">&nbsp;</p>
<p style="font-weight: 400;">访问路由添加内网的路由，否则客户端无法访问内网资源</p>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608101013894-1967279270.png" alt="" width="808" height="497" /></p>
<p id="1686190215077">&nbsp;</p>
<h1>&nbsp;</h1>
<h1><strong>五、</strong><strong>配置</strong><strong>GlobalProtect Portal</strong></h1>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608101245960-536343623.png" alt="" width="842" height="460" /></p>
<p><img src="/images/blog/725676-20230608101255421-1704231924.png" alt="" width="833" height="370" /></p>
<p><img src="/images/blog/725676-20230608101304094-294188479.png" alt="" width="781" height="473" /></p>
<p><img src="/images/blog/725676-20230608101311276-724155366.png" alt="" width="759" height="660" /></p>
<p><img src="/images/blog/725676-20230608101318143-545562919.png" alt="" width="720" height="436" /></p>
<p>&nbsp;</p>
<p>这里两个cookies的选项不建议勾选，否则PA上删除账号后 cookies还没过期的话账号依然能登陆</p>
<p>保存用户凭据根据实际选择，选择YES的话客户端会自动保存用户、密码，客户端重新打登陆不需要再输入</p>
<p><img src="/images/blog/725676-20230616205620049-1715912042.png" alt="" width="689" height="419" loading="lazy" /></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230608101331922-469094416.png" alt="" width="739" height="558" /></p>
<p style="font-weight: 400;">添加外网IP或域名</p>
<p style="font-weight: 400;">&nbsp;</p>
<p style="font-weight: 400;">&nbsp;</p>
<p style="font-weight: 400;">&nbsp;</p>
<h1><strong>六</strong><strong>、</strong><strong>修改</strong><strong>GlobalProtect</strong><strong>端口</strong></h1>
<p style="font-weight: 400;">GlobalProtect默认为443端口，若公网443端口被运营商封禁，需要将端口改为其它端口</p>
<p style="font-weight: 400;">参考：</p>
<p style="font-weight: 400;"><a href="https://knowledgebase.paloaltonetworks.com/KCSArticleDetail?id=kA10g000000ClGKCA0"><span style="text-decoration: underline;">https://knowledgebase.paloaltonetworks.com/KCSArticleDetail?id=kA10g000000ClGKCA0</span></a></p>
<p style="font-weight: 400;">原理：</p>
<p style="font-weight: 400;">新建&nbsp;loopback口，将GlobalProtect&nbsp;网关和门户的接口改为loopback</p>
<p style="font-weight: 400;">将外网接口的其它端口NAT至loopback的443端口</p>
<p style="font-weight: 400;">&nbsp;</p>
<h1><strong>七</strong><strong>、</strong><strong>NAT</strong><strong>及安全策略</strong></h1>
<p style="font-weight: 400;">略</p>
<p style="font-weight: 400;">&nbsp;</p>
<h1><strong>八、客户端安装证书</strong></h1>
<p style="font-weight: 400;">若客户端没有安装证书，会提示无法验证网关的服务器证书</p>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608101447875-253454032.png" alt="" width="502" height="782" /></p>
<p><img src="/images/blog/725676-20230608101456935-297687627.png" alt="" width="280" height="367" /></p>
<p id="1686190489344">&nbsp;</p>
<p style="font-weight: 400;">需要导出根证书并在客户端电脑将证书设置为信任的</p>
<p style="font-weight: 400;">&nbsp;</p>
<p style="font-weight: 400;">证书导出路径：</p>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608101525167-1560242008.png" alt="" width="846" height="420" /></p>
<p style="font-weight: 400;">windows:</p>
<p style="font-weight: 400;">证书需要存储在 <span style="color: #ff0000;">受信任的根证书颁发机构</span></p>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608101551918-513512007.png" alt="" width="597" height="597" /></p>
<p id="1686190553394">&nbsp;</p>
<p><strong>MAC</strong></p>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608101612466-1003028408.png" alt="" width="803" height="613" /></p>
<p id="1686190573870">&nbsp;</p>
<p style="font-weight: 400;">&nbsp;</p>
<h1><strong>&nbsp;</strong></h1>
<h1><strong>九、客户端下载</strong></h1>
<p style="font-weight: 400;">方式1、确保有授权的情况下检查更新</p>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608101634911-1372831673.png" alt="" width="866" height="583" /></p>
<p id="1686190596233">&nbsp;</p>
<p><strong>web</strong><strong>登陆后会的客户端的下载链接</strong></p>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608101701596-1808004089.png" alt="" width="839" height="724" /></p>
<p id="1686190622931">&nbsp;</p>
<h1><strong>&nbsp;</strong></h1>
<p><strong>方式</strong><strong>2</strong><strong>登陆</strong><strong>PA</strong><strong>的</strong><strong>supoort</strong><strong>网站 </strong><a href="https://support.paloaltonetworks.com/"><span style="text-decoration: underline;">https://support.paloaltonetworks.com/</span></a></p>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608101725386-1301854501.png" alt="" width="844" height="779" /></p>
<p id="1686190646635">&nbsp;</p>
<p style="font-weight: 400;">其中GlobalProtect&nbsp;Agent Bundle可上传至设备，其它版本可直接安装至对应的系统中</p>
<p style="font-weight: 400;"><img src="/images/blog/725676-20230608101750471-772020.png" alt="" width="823" height="759" /></p>
<p id="1686190671709">&nbsp;</p>
<h1><strong>&nbsp;</strong></h1>
<h1><strong>&nbsp;</strong></h1>
<h1><strong>十、退出</strong><strong>Glo</strong><strong>balProtect</strong><strong>客户端</strong></h1>
<p>&nbsp;</p>
<p style="font-weight: 400;">&nbsp;</p>
<p style="font-weight: 400;">GlobalProtect客户端没有退出选项</p>
<p style="font-weight: 400;">在windows可新建以下bat脚本退出</p>
<p style="font-weight: 400;">&nbsp;</p>
<pre class="language-bash highlighter-hljs"><code>echo off

taskkill /f /im pangpa.exe

sc stop PanGPS

rem sc config PanGPS start= demand

rem pause</code></pre>
<p style="font-weight: 400;">&nbsp;</p>
<p style="font-weight: 400;">&nbsp;</p>
<p style="font-weight: 400;">MacOS脚本&nbsp;</p>
<pre class="language-bash highlighter-hljs"><code>
#!/bin/bash



case $# in

&nbsp;&nbsp;&nbsp;0)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;echo "Usage: $0 {start|stop}"

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;exit 1

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;;

&nbsp;&nbsp;&nbsp;1)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;case $1 in

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;start)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;echo "Starting GlobalProtect..."

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;launchctl load /Library/LaunchAgents/com.paloaltonetworks.gp.pangpa.plist

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;launchctl load /Library/LaunchAgents/com.paloaltonetworks.gp.pangps.plist

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;echo "Done!"

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;stop)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;echo "Stopping GlobalProtect..."

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;launchctl remove com.paloaltonetworks.gp.pangps

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;launchctl remove com.paloaltonetworks.gp.pangpa

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;echo "Done!"

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;echo "'$1' is not a valid verb."

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;echo "Usage: $0 {start|stop}"

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;exit 2

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;esac

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;;

&nbsp;&nbsp;&nbsp;*)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;echo "Too many args provided ($#)."

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;echo "Usage: $0 {start|stop}"

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;exit 3

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;;;

esac</code></pre>
<p style="font-weight: 400;">&nbsp;</p>
<h1 style="font-weight: 400;">十一、证书过期&nbsp;</h1>
<p><img src="/images/blog/725676-20230611222958598-99168656.png" width="880" height="1152" /></p>
<p>&nbsp;</p>
<p>根证书续订后需要重新导入至客户端电脑</p>
<p>&nbsp;</p>
<h1>十二、其它问题&nbsp;</h1>
<h2>12.1 根证书自动安装</h2>
<p>默认情况下客户端需要手动安装根证书，若希望客户端自动安装证书，可按如下设置</p>
<p><img src="/images/blog/725676-20230621164125999-395050365.png" alt="" width="799" height="447" loading="lazy" /></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230621152228819-352100939.png" alt="" width="831" height="389" loading="lazy" /></p>
<p>&nbsp;</p>
<p>提交后新安装的客户在登陆的时候选择仍然继续就会自动安装根证书，若没有出现 仍然继续 ，需卸载客户端并重新安装 。MAC OS 系统卸载需要使用卸载程序，不能直接删除app,否则 仍然继续按键无法点击。</p>
<p><img src="/images/blog/725676-20230621152331630-1396905657.png" alt="" width="331" height="434" loading="lazy" /></p>
<p>&nbsp;</p>
    