---
layout: post
title: ASA5510 映射443端口时提示 unable to reserve port 443 for static PAT
keywords:
description:
categories:
---
<div id="sina_keyword_ad_area2" class="articalContent   newfont_family">
<p><img src="/images/blog/011309205333080.png" alt="" /><br />
ERROR: unable to reserve port 443 for static PAT<br />
ERROR: unable to download policy</p>
<p>ASA 5510 在做443端口映射时提示unable to reserve port 443 for static
PAT，原因是asdm或webvpn占用443端口，将asdm和webvpn端口更改为其它端口即可</p>
<p>更改asdm端口：</p>
<div class="cnblogs_Highlighter">
<pre class="brush:objc;gutter:true;">ASA(config)#no http server enable
ASA(config)#http server enable 8080
</pre>
</div>
<p>　　</p>
<p>更改webvpn端口</p>
<div class="cnblogs_Highlighter">
<pre class="brush:objc;gutter:true;">ASA(config)#webvpn
ASA(config-webvpn)#enable outside
ASA(config-webvpn)#port 65010
</pre>
</div>
<p>　　</p>
<p>以下为cisco 官方资料：<br />
<a title="http://www.cisco.com/c/en/us/support/docs/security/asa-5500-x-series-next-generation-firewalls/64758-pix70-nat-pat.html" href="http://www.cisco.com/c/en/us/support/docs/security/asa-5500-x-series-next-generation-firewalls/64758-pix70-nat-pat.html" rel="nofollow">
http://www.cisco.com/c/en/us/support/docs/security/asa-5500-x-series-next-generation-firewalls/64758-pix70-nat-pat.html</a></p>
<p><img src="/images/blog/011303151433210.jpg" alt="" /></p>
<p>&nbsp;<br />
<br />
查看原文：<a href="http://imjc.tk/archives/589.html" rel="nofollow">http://imjc.tk/archives/589.html</a></p>




							
		</div>
    
