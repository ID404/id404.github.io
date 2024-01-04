---
layout: post
title: juniper模拟器使用设置 virtualbox
keywords:
description:
categories:
---
<p>最近学习juniper的防火墙，在网上找的模拟器。根据http://bbs.hh010.com/thread-377313-1-1.html的设置，但virtualbox启动时一直报错</p>
<div class="cnblogs_Highlighter">
<pre class="brush:csharp;gutter:true;">NamedPipe#0 failed to connect to named pipe \\.\pipe\com_1 (VERR_FILE_NOT_FOUND).


返回 代码:
E_FAIL (0x80004005)
组件:
ConsoleWrap
界面:
IConsole {872da645-4a9b-1727-bee2-5585105b9eed}
</pre>
</div>
<p><img src="/images/blog/725676-20151007220317581-2016157882.png" alt="" />　</p>
<p>&nbsp;</p>
<p>最后稍稍更改一下设置可正常启动</p>
<p>端口编号： 用户定义</p>
<p>端口模式：主机管道</p>
<p>取消勾选&ldquo;连接至现有通道或套接字&rdquo;</p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20151007220554190-963806800.png" alt="" /></p>
<p>&nbsp;</p>
    
