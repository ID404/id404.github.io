---
    layout: post
    title: Juniper Secure Connect 配置脚本
    tags:
    categories:
    ---
    <p>若要使用Juniper Secure Connect ,SRX的版本必须为20.3以上，20.3以下只能使用<a href="https://www.cnblogs.com/id404/" target="_blank">dynamic vpn</a>.&nbsp;</p>
<p>首先生成证书并引用</p>
<div>
<div class="cnblogs_Highlighter">
<pre class="brush:csharp;gutter:true;">request security pki generate-key-pair size 4096 type rsa certificate-id Juniper
request security pki local-certificate generate-self-signed certificate-id Juniper subject "DC=Juniper,CN=edu" domain-name edu.juniper.net ip-address 1.1.1.1 
set system services web-management https pki-local-certificate Juniper

set services ssl termination profile SSL-JSC-term server-certificate Juniper
</pre>
</div>
<p>注意1.1.1.1为设备的公网IP，根据实际更改</p>
<p>&nbsp;</p>
<p>设置IKE</p>
<div class="cnblogs_Highlighter">
<pre class="brush:csharp;gutter:true;">set security ike proposal JSC-proposal authentication-method pre-shared-keys
set security ike proposal JSC-proposal dh-group group20
set security ike proposal JSC-proposal authentication-algorithm sha-256
set security ike proposal JSC-proposal encryption-algorithm aes-256-cbc
set security ike proposal JSC-proposal lifetime-seconds 28800

set security ike policy Juniper_secure_connect_policy mode aggressive
set security ike policy Juniper_secure_connect_policy proposals JSC-proposal
set security ike policy Juniper_secure_connect_policy pre-shared-key ascii-text 123456

set security ike gateway Juniper_secure_connect_ike_gw ike-policy Juniper_secure_connect_policy
set security ike gateway Juniper_secure_connect_ike_gw dynamic user-at-hostname "srx@juniper.com"
set security ike gateway Juniper_secure_connect_ike_gw dynamic ike-user-type shared-ike-id
set security ike gateway Juniper_secure_connect_ike_gw dead-peer-detection optimized
set security ike gateway Juniper_secure_connect_ike_gw dead-peer-detection interval 10
set security ike gateway Juniper_secure_connect_ike_gw dead-peer-detection threshold 5
set security ike gateway Juniper_secure_connect_ike_gw external-interface ge-0/0/1.0
set security ike gateway Juniper_secure_connect_ike_gw local-address 1.1.1.1
set security ike gateway Juniper_secure_connect_ike_gw aaa access-profile remote-access-vpn-access-profile
set security ike gateway Juniper_secure_connect_ike_gw version v1-only
set security ike gateway Juniper_secure_connect_ike_gw tcp-encap-profile SSL-JSC-profile
</pre>
</div>
<p>&nbsp;</p>
<p>设置IPSec</p>
<div class="cnblogs_Highlighter">
<pre class="brush:csharp;gutter:true;">set security ipsec policy Remote-access-vpn-policy perfect-forward-secrecy keys group19
set security ipsec policy Remote-access-vpn-policy proposal-set standard

set security ipsec vpn Remote-access-vpn bind-interface st0.0
set security ipsec vpn Remote-access-vpn df-bit clear
set security ipsec vpn Remote-access-vpn copy-outer-dscp
set security ipsec vpn Remote-access-vpn ike gateway Juniper_secure_connect_ike_gw
set security ipsec vpn Remote-access-vpn ike ipsec-policy Remote-access-vpn-policy
set security ipsec vpn Remote-access-vpn traffic-selector ts-1 local-ip 10.0.0.0/8
set security ipsec vpn Remote-access-vpn traffic-selector ts-1 remote-ip 0.0.0.0/0
set security ipsec vpn Remote-access-vpn traffic-selector ts-2 local-ip 192.168.0.0/16
set security ipsec vpn Remote-access-vpn traffic-selector ts-2 remote-ip 0.0.0.0/0
</pre>
</div>
<p>&nbsp;</p>
<p>设置Remote-access</p>
<div class="cnblogs_Highlighter">
<pre class="brush:csharp;gutter:true;">set security remote-access profile RA-JSC-1 ipsec-vpn Remote-access-vpn
set security remote-access profile RA-JSC-1 access-profile remote-access-vpn-access-profile
set security remote-access profile RA-JSC-1 client-config RA-JSC-Client
set security remote-access client-config RA-JSC-Client connection-mode manual
set security remote-access client-config RA-JSC-Client dead-peer-detection interval 60
set security remote-access client-config RA-JSC-Client dead-peer-detection threshold 5
set security remote-access default-profile RA-JSC-1
</pre>
</div>
<p>&nbsp;</p>
<p>设置安全区域和策略</p>
<div class="cnblogs_Highlighter">
<pre class="brush:csharp;gutter:true;">set security policies from-zone vpn to-zone trust policy vpn-to-trust match source-address any
set security policies from-zone vpn to-zone trust policy vpn-to-trust match destination-address any
set security policies from-zone vpn to-zone trust policy vpn-to-trust match application any
set security policies from-zone vpn to-zone trust policy vpn-to-trust then permit

set security tcp-encap profile SSL-JSC-profile ssl-profile SSL-JSC-term

set security zones security-zone vpn interfaces st0.0 
set security zones security-zone vpn interfaces st0.0 
</pre>
</div>
<p>&nbsp;</p>
</div>
<p>其它</p>
<div class="cnblogs_Highlighter">
<pre class="brush:csharp;gutter:true;">set interfaces st0 unit 0 family inet

set access profile remote-access-vpn-access-profile client user_username firewall-user password "$98xNrloJUjq.Apu1Ic-dsaZj"
set access profile remote-access-vpn-access-profile address-assignment pool remote-access-vpn-pool
set access address-assignment pool remote-access-vpn-pool family inet network 192.168.254.0/24
set access address-assignment pool remote-access-vpn-pool family inet xauth-attributes primary-dns 114.114.114.114/32
set access firewall-authentication web-authentication default-profile remote-access-vpn-access-profile
</pre>
</div>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>客户端下载地址：</p>
<div>https://support.juniper.net/support/downloads/</div>
<div>&nbsp;</div>
<div>输入设备的公网IP进行链接即可</div>
<div>若设备的443端口被封，可通过命令更改为其它端口：</div>
<div>set system services web-management https port 8443</div>
<div><img src="/images/blog/725676-20220116185840488-1711852338.png" alt="" />
<p><img src="/images/blog/725676-20220116185848956-1163792909.png" alt="" /></p>
<p><img src="/images/blog/725676-20220116185857941-141507157.png" alt="" /></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>若需要<a href="https://www.cnblogs.com/id404/" target="_blank">对接ldap</a>， 需要将remote-access-vpn-access-profile改为如下：</p>
<div class="cnblogs_Highlighter">
<pre class="brush:bash;gutter:true;">set access profile remote-access-vpn-access-profile authentication-order ldap
set access profile remote-access-vpn-access-profile address-assignment pool remote-access-vpn-pool
set access profile remote-access-vpn-access-profile ldap-options base-distinguished-name CN=Users,DC=id404,DC=local
set access profile remote-access-vpn-access-profile ldap-options search search-filter sAMAccountName=
set access profile remote-access-vpn-access-profile ldap-options search admin-search distinguished-name CN=Administrator,CN=Users,DC=id404,DC=local
set access profile remote-access-vpn-access-profile ldap-options search admin-search password "$2$M8ZUiHmSylLx"
set access profile remote-access-vpn-access-profile ldap-server 10.12.130.6 tls-type start-tls
set access profile remote-access-vpn-access-profile ldap-server 10.12.130.6 tls-timeout 3
set access profile remote-access-vpn-access-profile ldap-server 10.12.130.6 tls-min-version v1.2
set access profile remote-access-vpn-access-profile ldap-server 10.12.130.6 no-tls-certificate-check
set access profile remote-access-vpn-access-profile ldap-server 10.12.130.6 tls-peer-name peername
</pre>
</div>
<p>&nbsp;</p>
<p>&nbsp;</p>
</div>
<p>&nbsp;</p>
    
