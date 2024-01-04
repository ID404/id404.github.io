---
    layout: post
    title: freeradius对接ldap配置
    tags:
    categories:
    ---
    <p>1、安装freeradius</p>
<div class="page" title="Page 1">
<div class="layoutArea">
<div class="column">
<p>yum install freeradius freeradius-utils freeradius-ldap freeradius-krb5</p>
<p>&nbsp;</p>
<p>2、启用LDAP 模块</p>
<div class="page" title="Page 1">
<div class="layoutArea">
<div class="column">
<p>ln -s /etc/raddb/mods-available/ldap /etc/raddb/mods-enabled/</p>
<p>&nbsp;</p>
<p>3、配置radius客户端，修改/etc/raddb/clients.conf</p>
<p>client mbp {<br />	ipaddr		= 192.168.0.33/32<br />	secret		= 123456<br />}</p>
<p>4、修改<span style="font-style: italic;">/etc/raddb/sites-enabled/default 和 /etc/raddb/sites-enabled/inner-tunnel文件</span></p>
<p>&nbsp;</p>
<p>取消ldap前的注释</p>
<p>ldap</p>
<p><em id="__mceDel">if ((OK || updated) &amp;&amp; User-Password){<br />&nbsp;update{<br />&nbsp;control:Auth-Type:=ldap<br />&nbsp;}<br />&nbsp;}</em></p>

</div>

</div>

</div>
<p>同时取消Auth-Type LDAP的注释</p>
<p>Auth-Type LDAP {</p>
<p>　　ldap</p>
<p>}</p>
<p>&nbsp;</p>
<p>5、添加LDAP服务器的对接参数 ，修改/etc/raddb/mods-enable/ldap</p>
<p>主要修改以下配置，以下为对接freeipa的参数 ，其它如AD请自行修改信息</p>
<p>server = '10.0.0.10'</p>
<p>identity = 'uid=admin,cn=users,cn=accounts,dc=freeipa,dc=fly,dc=cn'<br />        password = 123456</p>
<p>base_dn = 'cn=users,cn=accounts,dc=freeipa,dc=fly,dc=cn'</p>
<p>&nbsp;</p>
<p>6、修改完毕后可以启动freeradius 或执行radiusd -X 进入debug 模式测试认证</p>
<p>&nbsp;</p>
<p>文章内容参考：<a href="https://eduroam.in/wp-content/uploads/2022/03/Configure-Freeradius-3-with-LDAP.pdf">https://eduroam.in/wp-content/uploads/2022/03/Configure-Freeradius-3-with-LDAP.pdf</a></p>
<p>&nbsp;</p>
<p>&nbsp;</p>

</div>

</div>

</div>
    
