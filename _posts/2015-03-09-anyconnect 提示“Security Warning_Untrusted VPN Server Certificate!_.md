---
layout: post
title: anyconnect 提示“Security Warning:Untrusted VPN Server Certificate!"
keywords: cisco, anyconnect
description: anyconnect 提示“Security Warning:Untrusted VPN Server Certificate!"
categories: cisco
---
anyconnect 提示“Security Warning:Untrusted VPN Server Certificate!"

<p><img src="/images/blog/091347476745285.jpg" alt="" /></p>
<p>出现此连接警告的原因是因为路由器上<span lang="EN-US">CA证书的<span lang="EN-US">subject-name的字段与路由器的<span lang="EN-US">IP地址不一致造成的。重装修改生成新的<span lang="EN-US">CA证书，然后连接<span lang="EN-US">VPN时勾选选项"always trust the vpn server and import the certifaction"后再次连接就不会再弹出该安全告警。</span></span></span></span></span></p>
<p>&nbsp;</p>
<p>show run 后找到以下信息：</p>
<div class="cnblogs_code">
<pre>!<span style="color: #000000;">
crypto pki certificate chain TP</span>-self-signed-<span style="color: #800080;">19124</span><span style="color: #000000;">
certificate self</span>-signed <span style="color: #800080;">05</span><span style="color: #000000;">
3082022B </span><span style="color: #800080;">30820194</span> A0030201 <span style="color: #800080;">02020105</span> 300D0609 2A864886 F70D0101 <span style="color: #800080;">05050030</span><span style="color: #000000;"> 
31312F30 2D060355 </span><span style="color: #800080;">04031326</span> 494F532D 53656C66 2D536967 <span style="color: #800080;">6E65642D</span> <span style="color: #800080;">43657274</span> 
<span style="color: #800080;">69666963</span> 6174652D <span style="color: #800080;">31393132</span> <span style="color: #800080;">34313830</span> 3939301E 170D3135 <span style="color: #800080;">30333034</span> <span style="color: #800080;">30343436</span><span style="color: #000000;"> 
31335A17 0D323030 </span><span style="color: #800080;">31303130</span> <span style="color: #800080;">30303030</span> 305A3031 312F302D <span style="color: #800080;">06035504</span> <span style="color: #800080;">03132649</span><span style="color: #000000;"> 
4F532D53 656C662D 5369676E 65642D43 </span><span style="color: #800080;">65727469</span> <span style="color: #800080;">66696361</span> 74652D31 <span style="color: #800080;">39313234</span> 
<span style="color: #800080;">31383039</span> 3930819F 300D0609 2A864886 F70D0101 <span style="color: #800080;">01050003</span> 818D0030 <span style="color: #800080;">81890281</span><span style="color: #000000;"> 
8100C046 F965E4EA 7FD19E5A D31727B9 AD93DA9A EF138758 F65A9AD1 18114FE4 
A1AD404D CBB200C4 5232DCA4 892F6822 C9C9C830 41AFF407 1D4457BD 039EB24E </span></pre>
</div>
<p>&nbsp;</p>
<p><br />  取消原证书</p>
<div class="cnblogs_code">
<pre>router-name(config)#no crypto pki trustpoint TP-self-signed-<span style="color: #800080;">19124</span>
%<span style="color: #000000;"> Removing an enrolled trustpoint will destroy all certificates
received from the related Certificate Authority.

Are you sure you want to </span><span style="color: #0000ff;">do</span> this? [yes/<span style="color: #000000;">no]: yes
</span>% Be sure to ask the CA administrator to revoke your certificates.</pre>
</div>
<p>&nbsp;</p>
<p>生成新的证书：</p>
<div class="cnblogs_code">
<pre>router-name(config)#crypto key generate rsa general-keys label router-name modulus <span style="color: #800080;">1024</span><span style="color: #000000;"> exportable 
The name </span><span style="color: #0000ff;">for</span> the keys will be: router-<span style="color: #000000;">name

</span>% The key modulus size is <span style="color: #800080;">1024</span><span style="color: #000000;"> bits
</span>% Generating <span style="color: #800080;">1024</span><span style="color: #000000;"> bit RSA keys, keys will be exportable...
[OK] (elapsed </span><span style="color: #0000ff;">time</span> was <span style="color: #800080;">0</span><span style="color: #000000;"> seconds)

router</span>-name(config)#crypto pki trustpoint router-<span style="color: #000000;">name 
router</span>-name(ca-<span style="color: #000000;">trustpoint)#en
router</span>-name(ca-<span style="color: #000000;">trustpoint)#enrollment sel

router</span>-name(ca-<span style="color: #000000;">trustpoint)#enrollment selfsigned


router</span>-name(ca-trustpoint)#rsakeypair router-<span style="color: #000000;">name

router</span>-name(ca-trustpoint)#subject-name <span style="color: #800080;">1.2</span>.<span style="color: #800080;">3.4</span>
<span style="color: #800000;">"</span><span style="color: #800000;">1.2.3.4</span><span style="color: #800000;">"</span><span style="color: #000000;"> is not a valid subject name
The subject name must be </span><span style="color: #0000ff;">in</span> X.<span style="color: #800080;">500</span><span style="color: #000000;"> (LDAP) format

router</span>-name(ca-trustpoint)#subject-name cn=<span style="color: #800080;">1.2</span>.<span style="color: #800080;">3.4</span><span style="color: #000000;">
router</span>-name(ca-<span style="color: #000000;">trustpoint)#exit

router</span>-name(config)#crypto pki enroll router-<span style="color: #000000;">name
</span>% Include the router serial number <span style="color: #0000ff;">in</span> the subject name? [yes/<span style="color: #000000;">no]: no
</span>% Include an IP address <span style="color: #0000ff;">in</span> the subject name?<span style="color: #000000;"> [no]: no
Generate Self Signed Router Certificate</span>? [yes/<span style="color: #000000;">no]: yes

Router Self Signed Certificate successfully created

router</span>-<span style="color: #000000;">name(config)#exit

router</span>-<span style="color: #000000;">name#conf t
router</span>-<span style="color: #000000;">name(config)#webvpn gateway VPNGW
router</span>-name(config-webvpn-gateway)#ssl trustpoint router-<span style="color: #000000;">name
router</span>-name(config-webvpn-<span style="color: #000000;">gateway)#exit
router</span>-name(config)#exit</pre>
</div>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>查看新生成的证书：</p>
<div class="cnblogs_code">
<pre>router-name#<span style="color: #0000ff;">sh</span> crypto pki certificates router-<span style="color: #000000;">name
Router Self</span>-<span style="color: #000000;">Signed Certificate
Status: Available
Certificate Serial Number (hex): </span><span style="color: #800080;">06</span><span style="color: #000000;">
Certificate Usage: General Purpose
Issuer: 
</span><span style="color: #0000ff;">hostname</span>=router-<span style="color: #000000;">name.yourdomain.com
cn</span>=<span style="color: #800080;">1.2</span>.<span style="color: #800080;">3.4</span><span style="color: #000000;">
Subject:
Name: router</span>-<span style="color: #000000;">name.yourdomain.com
</span><span style="color: #0000ff;">hostname</span>=router-<span style="color: #000000;">name.yourdomain.com
cn</span>=<span style="color: #800080;">1.2</span>.<span style="color: #800080;">3.4</span><span style="color: #000000;">
Validity Date: 
start </span><span style="color: #0000ff;">date</span>: <span style="color: #800080;">02</span>:<span style="color: #800080;">16</span>:<span style="color: #800080;">57</span> UTC Mar <span style="color: #800080;">9</span> <span style="color: #800080;">2015</span><span style="color: #000000;">
end </span><span style="color: #0000ff;">date</span>: <span style="color: #800080;">00</span>:<span style="color: #800080;">00</span>:<span style="color: #800080;">00</span> UTC Jan <span style="color: #800080;">1</span> <span style="color: #800080;">2020</span><span style="color: #000000;">
Associated Trustpoints: router</span>-name</pre>
</div>
<p>&nbsp;</p>
    
