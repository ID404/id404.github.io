---
    title: GlobalProtect 客户端证书认证
    date: 2023-06-16 18:50:00
    updated: 2023-06-19 11:19:00
    abbrlink: 17485517
    tags:
    categories:
    ---
    <p>#Author https://cnblogs.com/id404</p>
<p>&nbsp;</p>
<h1>GlobalProtect 客户端证书认证</h1>
<p>&nbsp;GlobalProtect的基本配置可参考博文 <a href="https://www.cnblogs.com/id404/p/17465413.html">https://www.cnblogs.com/id404/p/17465413.html</a>&nbsp; 本文不再叙述</p>
<p>最终效果是客户端未安装客户端证书时无法登陆，每个客户端可安装各自证书</p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230616144119632-1475111007.png" width="205" height="308" /></p>
<h1>一、证书配置文件</h1>
<p>新建证书配置文件，一定要选择右下角的 阻止具有过期证书的会话</p>
<p><img src="/images/blog/725676-20230616144251338-251949249.png" width="703" height="507" /></p>
<h1>二、GlobalProtect修改门户配置</h1>
<p>在门户配置-身份验证-证书配置文件 选择上一步创建的配置文件</p>
<p><img src="/images/blog/725676-20230616144401504-519345776.png" width="744" height="455" /></p>
<p>客户端身份验证中 允许使用用户凭证或客户端证书进行身份验证 选择NO</p>
<p><img src="/images/blog/725676-20230616144508300-1277129777.png" width="652" height="377" /></p>
<p>&nbsp;</p>
<h1>三、GlobalProtect网关修改</h1>
<p>在网关-身份验证-证书配置文件 选择第一步创建的配置文件</p>
<p><img src="/images/blog/725676-20230616144727109-604867544.png" width="659" height="376" /></p>
<p>&nbsp;</p>
<p>客户端身份验证中 允许使用用户凭证或客户端证书进行身份验证 选择NO</p>
<p><img src="/images/blog/725676-20230616144855365-1749657362.png" width="729" height="371" /></p>
<p>&nbsp;</p>
<h1>四、创建客户端证书</h1>
<p>在证书页面生成客户端证书，可以多个用户共用一个证书或单个用户单个证书，可用证书名称或证书属性区分</p>
<p><img src="/images/blog/725676-20230616145240110-182682791.png" width="545" height="422" /></p>
<h2>4.1 证书导出</h2>
<p>证书导出格式建议选择PKCS12，客户端需提供密码才能安装 ，提高安全性</p>
<p><img src="/images/blog/725676-20230616145458415-2120992807.png" width="616" height="376" /></p>
<p>&nbsp;</p>
<h2>4.2 证书安装</h2>
<p>客户端双击打开后输入密码</p>
<p>MAC：</p>
<p><img src="/images/blog/725676-20230616145742191-537447436.png" width="614" height="253" /></p>
<p>windows:</p>
<p><img src="/images/blog/725676-20230616150924884-32793776.png" width="586" height="596" /></p>
<h2>4.3 门户登陆&nbsp;</h2>
<p>登陆时选择证书：</p>
<p><img src="/images/blog/725676-20230616151858610-973330543.png" width="652" height="311" /></p>
<p><img src="/images/blog/725676-20230616151442513-1297187131.png" width="348" height="211" /></p>
<p>登陆成功</p>
<p><img src="/images/blog/725676-20230616151525358-788393359.png" width="766" height="670" /></p>
<p>MAC：</p>
<p><img src="/images/blog/725676-20230616150330228-1332394179.png" /></p>
<h2>4.4 客户端登陆：</h2>
<p><img src="/images/blog/725676-20230616152113998-917523242.png" width="268" height="406" /></p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230616150128342-2033661643.png" width="546" height="440" /></p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20230616150146014-834812412.png" width="544" height="164" /></p>
<h1>五、证书验证</h1>
<p>以上四点基本能完成证书认证，在证书过期后需要重新生成证书。但存在一个问题证书过期前吊销证书的话客户端依然能认证成功，除过期时间外其它证书的状态无法验证</p>
<p>以下设置ocsp验证证书状态：</p>
<h2>5.1接口修改</h2>
<p>修改接口管理的配置文件允许http ocsp验证</p>
<p><img src="/images/blog/725676-20230616183140218-738450980.png" width="572" height="411" /></p>
<p><img src="/images/blog/725676-20230616183246753-1439179676.png" width="642" height="206" /></p>
<p><span style="background-color: #e03e2d;">注意 根据官方案例，https://knowledgebase.paloaltonetworks.com/KCSArticleDetail?id=kA14u000000kGEMCA2 &nbsp;</span></p>
<p><span style="background-color: #e03e2d;">不支持OSCP和 GlobalProtect Portal在同一接口上</span></p>
<p>&nbsp;</p>
<h2>5.2 OCSP响应配置</h2>
<p>设置ocsp响应配置</p>
<p><img src="/images/blog/725676-20230616183324861-1791750774.png" width="562" height="282" /></p>
<p>&nbsp;</p>
<p>设置 证书配置文件</p>
<p><img src="/images/blog/725676-20230616183408351-1659980756.png" width="574" height="353" /></p>
<p>&nbsp;</p>
<h2>5.3 GlobalProtect门户修改</h2>
<p><img src="/images/blog/725676-20230616183833325-1600544319.png" width="680" height="409" /></p>
<h2>5.4GlobalProtect 网关修改</h2>
<p><img src="/images/blog/725676-20230616184104052-1973162338.png" width="642" height="375" /></p>
<h2>5.5 生成用户证书</h2>
<p><img src="/images/blog/725676-20230616153426837-1093827828.png" width="598" height="473" /></p>
<p><span style="background-color: #e03e2d;">OCSP响应者必须选择正确</span></p>
<p>&nbsp;</p>
<p>按照4.1-4.4 步骤进行证书安装及登陆&nbsp;</p>
<p>&nbsp;</p>
<h2>5.6 吊销证书</h2>
<p><img src="/images/blog/725676-20230616152624232-530902484.png" width="609" height="353" /></p>
<p>证书吊销后门户和网关都无法登陆</p>
<p><img src="/images/blog/725676-20230616173137787-258569463.png" width="796" height="510" /></p>
<p>&nbsp;</p>
<p><span style="background-color: #e03e2d;">在测试过程中发现mac系统和windos系统表现有差异，部分证书吊销后客户端依然能正常登陆 ，第五大点证书验证部分仅作参考，有待进一步详细测试</span></p>
    