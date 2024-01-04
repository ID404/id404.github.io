---
    layout: post
    title: juniper srx 动态VPN配置 密码认证 radius认证 AD域认证
    tags:
    categories:
    ---
    <div class="cnblogs_Highlighter">&nbsp;</div>
<p>　　</p>
<p>juniper srx系列防火墙的动态VPN又叫dynamic vpn ,可以通过电脑客户端远程拨入到设备所在网络中.目前低端系列的防火墙如srx100 srx210 srx240 srx550 srx650设备默认支持两个动态VPN并发授权,超过两个授权需要开通相应的license .srx300系列需要高版本才能支持,前段时间测试过300系列15.1D49是不支持动态VPN的,好像需要升级到D51版本以上.</p>
<p>&nbsp;</p>
<p>开启https</p>
<div class="cnblogs_code">
<pre><span style="color: #0000ff;">set</span> system services web-management https system-generated-<span style="color: #000000;">certificate
</span><span style="color: #0000ff;">set</span> system services web-management https <span style="color: #0000ff;">interface</span> vlan.<span style="color: #800080;">0</span></pre>
</div>
<p>&nbsp;</p>
<p>配置动态VPN后可能无法通过http进入到设备管理界面</p>
<div class="cnblogs_code">
<pre><span style="color: #0000ff;">set</span> system services web-management management-url admin</pre>
</div>
<p>输入以上命令可以通过http://ip地址/admin 这个url进入设备管理界面</p>
<p>&nbsp;</p>
<p>配置ike参数,其中fe-0/0/0.0为外网接口</p>
<div class="cnblogs_code">
<pre><span style="color: #0000ff;">set</span> security ike policy ike-dyn-vpn-<span style="color: #000000;">policy mode aggressive
</span><span style="color: #0000ff;">set</span> security ike policy ike-dyn-vpn-policy proposal-<span style="color: #0000ff;">set</span><span style="color: #000000;"> standard
</span><span style="color: #0000ff;">set</span> security ike policy ike-dyn-vpn-policy pre-shared-key ascii-text <span style="color: #800000;">"</span><span style="color: #800000;">$9$IlCRhSrlv8L7Vw.PTQn6lKv</span><span style="color: #800000;">"</span>
<span style="color: #0000ff;">set</span> security ike gateway dyn-vpn-local-gw ike-policy ike-dyn-vpn-<span style="color: #000000;">policy
</span><span style="color: #0000ff;">set</span> security ike gateway dyn-vpn-local-gw <span style="color: #0000ff;">dynamic</span><span style="color: #000000;"> hostname dynvpn
</span><span style="color: #0000ff;">set</span> security ike gateway dyn-vpn-local-gw <span style="color: #0000ff;">dynamic</span> connections-limit <span style="color: #800080;">10</span>
<span style="color: #0000ff;">set</span> security ike gateway dyn-vpn-local-gw <span style="color: #0000ff;">dynamic</span> ike-user-type group-ike-<span style="color: #000000;">id
</span><span style="color: #0000ff;">set</span> security ike gateway dyn-vpn-local-gw external-<span style="color: #0000ff;">interface</span> fe-<span style="color: #800080;">0</span>/<span style="color: #800080;">0</span>/<span style="color: #800080;">0.0</span>
<span style="color: #0000ff;">set</span> security ike gateway dyn-vpn-local-gw xauth access-profile dyn-vpn-access-profile</pre>
</div>
<p>&nbsp;</p>
<p>配置ipsec参数</p>
<div class="cnblogs_code">
<pre><span style="color: #0000ff;">set</span> security ipsec policy ipsec-dyn-vpn-policy proposal-<span style="color: #0000ff;">set</span><span style="color: #000000;"> standard
</span><span style="color: #0000ff;">set</span> security ipsec vpn dyn-vpn ike gateway dyn-vpn-local-<span style="color: #000000;">gw
</span><span style="color: #0000ff;">set</span> security ipsec vpn dyn-vpn ike ipsec-policy ipsec-dyn-vpn-policy</pre>
</div>
<p>&nbsp;</p>
<p>配置客户账号访问参数,不同账号可以访问到哪些资源 ,可以通过这里配置,示例中为用户test1只可以访问10.1.1.2这个主机IP,其它资源禁止访问,其它用户可以访问10.0.0.0/8网段的资源.注意配置的顺序,策略的匹配都是从上到下的,all建议放在最后.注意如果配置了radius认证服务器,相应可以远程拨入的用户也需要在这里添加 ,否则用户无法拨入.</p>
<div class="cnblogs_code">
<pre><span style="color: #0000ff;">set</span> security <span style="color: #0000ff;">dynamic</span>-vpn access-profile dyn-vpn-access-<span style="color: #000000;">profile
</span><span style="color: #0000ff;">set</span> security <span style="color: #0000ff;">dynamic</span>-vpn clients test remote-<span style="color: #0000ff;">protected</span>-resources <span style="color: #800080;">10.1</span>.<span style="color: #800080;">1.2</span>/<span style="color: #800080;">32</span>
<span style="color: #0000ff;">set</span> security <span style="color: #0000ff;">dynamic</span>-vpn clients test remote-exceptions <span style="color: #800080;">0.0</span>.<span style="color: #800080;">0.0</span>/<span style="color: #800080;">0</span>
<span style="color: #0000ff;">set</span> security <span style="color: #0000ff;">dynamic</span>-vpn clients test ipsec-vpn dyn-<span style="color: #000000;">vpn
</span><span style="color: #0000ff;">set</span> security <span style="color: #0000ff;">dynamic</span>-<span style="color: #000000;">vpn clients test user test1
</span><span style="color: #0000ff;">set</span> security <span style="color: #0000ff;">dynamic</span>-vpn clients all remote-<span style="color: #0000ff;">protected</span>-resources <span style="color: #800080;">10.0</span>.<span style="color: #800080;">0.0</span>/<span style="color: #800080;">8</span>
<span style="color: #0000ff;">set</span> security <span style="color: #0000ff;">dynamic</span>-vpn clients all remote-exceptions <span style="color: #800080;">0.0</span>.<span style="color: #800080;">0.0</span>/<span style="color: #800080;">0</span>
<span style="color: #0000ff;">set</span> security <span style="color: #0000ff;">dynamic</span>-vpn clients all ipsec-vpn dyn-<span style="color: #000000;">vpn
</span><span style="color: #0000ff;">set</span> security <span style="color: #0000ff;">dynamic</span>-<span style="color: #000000;">vpn clients all user aa
</span><span style="color: #0000ff;">set</span> security <span style="color: #0000ff;">dynamic</span>-<span style="color: #000000;">vpn clients all user client1
</span><span style="color: #0000ff;">set</span> security <span style="color: #0000ff;">dynamic</span>-<span style="color: #000000;">vpn clients all user client2
</span><span style="color: #0000ff;">set</span> security <span style="color: #0000ff;">dynamic</span>-vpn clients all user test</pre>
</div>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>配置安全策略</p>
<div class="cnblogs_code">
<pre><span style="color: #0000ff;">set</span> security policies <span style="color: #0000ff;">from</span>-zone untrust to-zone trust policy dyn-vpn-policy match source-<span style="color: #000000;">address any
</span><span style="color: #0000ff;">set</span> security policies <span style="color: #0000ff;">from</span>-zone untrust to-zone trust policy dyn-vpn-policy match destination-<span style="color: #000000;">address any
</span><span style="color: #0000ff;">set</span> security policies <span style="color: #0000ff;">from</span>-zone untrust to-zone trust policy dyn-vpn-<span style="color: #000000;">policy match application any
</span><span style="color: #0000ff;">set</span> security policies <span style="color: #0000ff;">from</span>-zone untrust to-zone trust policy dyn-vpn-policy then permit tunnel ipsec-vpn dyn-vpn</pre>
</div>
<p>&nbsp;</p>
<p>允许外网访问https和ike</p>
<div class="cnblogs_code">
<pre><span style="color: #0000ff;">set</span> security zones security-zone untrust interfaces fe-<span style="color: #800080;">0</span>/<span style="color: #800080;">0</span>/<span style="color: #800080;">0.0</span> host-inbound-traffic system-<span style="color: #000000;">services ike
</span><span style="color: #0000ff;">set</span> security zones security-zone untrust interfaces fe-<span style="color: #800080;">0</span>/<span style="color: #800080;">0</span>/<span style="color: #800080;">0.0</span> host-inbound-traffic system-services https</pre>
</div>
<p>&nbsp;</p>
<p>&nbsp; 设置相应的认证方式和地址池,如果是本地认证,可以去掉</p>
<p>&nbsp; set access profile dyn-vpn-access-profile authentication-order radius &nbsp;&nbsp;</p>
<p>&nbsp; set access profile dyn-vpn-access-profile authentication-order password</p>
<div class="cnblogs_code">
<pre><span style="color: #0000ff;">set</span> access profile dyn-vpn-access-profile authentication-<span style="color: #000000;">order password
</span><span style="color: #0000ff;">set</span> access profile dyn-vpn-access-profile client client1 firewall-user password <span style="color: #800000;">"</span><span style="color: #800000;">$9$KTdMxNVwYoZUx7VYoGq.Ctu</span><span style="color: #800000;">"</span>
<span style="color: #0000ff;">set</span> access profile dyn-vpn-access-profile address-assignment pool dyn-vpn-address-<span style="color: #000000;">pool
</span><span style="color: #0000ff;">set</span> access profile dyn-vpn-access-profile session-options client-idle-timeout <span style="color: #800080;">180</span>
<span style="color: #0000ff;">set</span> access profile dyn-vpn-access-profile radius-server <span style="color: #800080;">192.168</span>.<span style="color: #800080;">0.44</span> secret <span style="color: #800000;">"</span><span style="color: #800000;">$9$DJjmT6/tOIcApclvLVbaZUj.PTz39tu</span><span style="color: #800000;">"</span>
<span style="color: #0000ff;">set</span> access address-assignment pool dyn-vpn-address-pool family inet network <span style="color: #800080;">10.10</span>.<span style="color: #800080;">10.0</span>/<span style="color: #800080;">24</span>
<span style="color: #0000ff;">set</span> access address-assignment pool dyn-vpn-address-pool family inet xauth-attributes primary-dns <span style="color: #800080;">4.2</span>.<span style="color: #800080;">2.2</span>/<span style="color: #800080;">32</span>
<span style="color: #0000ff;">set</span> access firewall-authentication web-authentication <span style="color: #0000ff;">default</span>-profile dyn-vpn-access-profile</pre>
</div>
<p>　　</p>
<p>　这两句,示例中配置的是radius认证,这里的client1 为本地用户, 如果配置了多种认证方式,设备默认只使用第一种认证方式,这里一直没搞明白为什么,如果只认第一种认证方式的话为什么可以配置多种认证方式?在动态VPN里面设备默认没对认证服务器做轮询.这个要区别于system 层次里面的认证,登陆管理设备的账号同样可以同时配置radius 认证和本地认证,而且会对认证服务器进行轮询,比如raidus服务器认证失败了,会将请求发送到本地,如果所有认证服务器都认证不成功才会提示认证失败.</p>
<p>&nbsp;</p>
<p>若需要结合微软AD域做认证,可将access profile按以下内容更改.</p>
<p>实例中AD域为test.com 域服务器为192.168.0.223</p>
<div class="cnblogs_code">
<pre><span style="color: #0000ff;">set</span> access profile dyn-vpn-access-profile authentication-<span style="color: #000000;">order ldap
</span><span style="color: #0000ff;">set</span> access profile dyn-vpn-access-profile address-assignment pool dyn-vpn-address-<span style="color: #000000;">pool
</span><span style="color: #0000ff;">set</span> access profile dyn-vpn-access-profile session-options client-idle-timeout <span style="color: #800080;">180</span>
<span style="color: #0000ff;">set</span> access profile dyn-vpn-access-profile ldap-options <span style="color: #0000ff;">base</span>-distinguished-name CN=Users,DC=test,DC=<span style="color: #000000;">com
</span><span style="color: #0000ff;">set</span> access profile dyn-vpn-access-profile ldap-options search search-filter sAMAccountName=
<span style="color: #0000ff;">set</span> access profile dyn-vpn-access-profile ldap-options search admin-search distinguished-name CN=administrator,CN=Users,DC=test,DC=<span style="color: #000000;">com
</span><span style="color: #0000ff;">set</span> access profile dyn-vpn-access-profile ldap-options search admin-search password <span style="color: #800000;">"</span><span style="color: #800000;">$9$W31L-Vs24ZDi-ds4ZjPfp0B</span><span style="color: #800000;">"</span>
<span style="color: #0000ff;">set</span> access profile dyn-vpn-access-profile ldap-server <span style="color: #800080;">192.168</span>.<span style="color: #800080;">0.223</span> port <span style="color: #800080;">389</span>
<span style="color: #0000ff;">set</span> access address-assignment pool dyn-vpn-address-pool family inet network <span style="color: #800080;">10.10</span>.<span style="color: #800080;">10.0</span>/<span style="color: #800080;">24</span>
<span style="color: #0000ff;">set</span> access address-assignment pool dyn-vpn-address-pool family inet xauth-attributes primary-dns <span style="color: #800080;">4.2</span>.<span style="color: #800080;">2.2</span>/<span style="color: #800080;">32</span>
<span style="color: #0000ff;">set</span> access firewall-authentication web-authentication <span style="color: #0000ff;">default</span>-profile dyn-vpn-access-profile</pre>
</div>
<p>&nbsp;</p>
    
