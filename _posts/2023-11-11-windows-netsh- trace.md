---
layout: post
title: windows自带工具netsh trace 抓包
keywords: windows
description: windows自带工具netsh trace 抓包
categories: windows
---
管理员模式运行

netsh trace start capture=yes report=disabled  protocol=TCP ipv4.address=192.168.0.40 tracefile=d:\a.etl

 

 

停止抓包

netsh trace stop

 

 

-------------------------------------------------------------

其它可选参数

 report=enabled 则还会额外输出系统的各类软硬件及系统诊断配置信息并打包为cab格式。disabled

persistent=yes 即使重启设备也会继续抓包，除非运行netsh trace stop 。默认是no

fielmode=single|circular|append  默认为circular

maxsize  默认为250MB，如果不限制抓包文件大小需要设置maxsize=0 同时需要设置 filemode=single

overwrite=yes|no 抓包文件是否覆盖原文件

correlation=yes： 不收集关联事件 默认yes
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>指定源地址</p>
<p>IPv4.SourceAddress=&lt;x.x.x.x&gt;</p>
<p>IPv4.DstinstionAddress=&lt;x.x.x.x&gt;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>protocol=&lt;protocol&gt;</p>
<p>例如：</p>
<p>protocol=6</p>
<p>protocol=!(TCP,UDP)</p>
<p>protocol=(4-10)</p>
<p>后面填写协议名称或协议号，其中</p>
<p>ICMP 协议号1</p>
<p>IPv4 协议号4</p>
<p>TCP 协议号6</p>
<p>UDP 协议号17</p>
<p>IPv6 协议号41</p>
<p>IPv6&nbsp; icmp协议号58</p>
<p>&nbsp;</p>
<p>IPv4.address=&lt;x.x.x.x&gt;</p>
<p>&nbsp;</p>
<p>CaptureInterface=&lt;interface name 或 GUID&gt;&nbsp; 使用命令netsh trace show interfaces可查看可用的接口</p>
<p>例子：&nbsp;</p>
<p>CaptureInterface={716A7812-4AEE-4545-9D00-C10EFD223551}</p>
<p>CaptureInterface=!{716A7812-4AEE-4545-9D00-C10EFD223551}</p>
<p>CaptureInterface="Local Area Connection"</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>查询其它可用的过滤条件</p>
<p>netsh trace show capturefilterhelp</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>------------------------------------------------------------------------------------</p>
<p>将抓包文件转换为XML</p>
<p><strong>netsh trace convert input=NetTrace-ICP.etl output=NetTrace-ICP.etl.xml dump=XML</strong></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>生成的etl文件可用微软件的network monitor查看 ，需要提前在Tools&gt; options &gt;Parser Profiles &gt; windows 设置为Set As Active&nbsp;</p>
<p><img src="blob:/images/blog/c37e59e7-5e16-4d40-a663-1b2a54a71b49" alt="Pasted Graphic.png" /></p>
<p>&nbsp;</p>
<p>若需要转换为wireshark可查看的文件格式pcapng，需要使用到转换工具</p>
<p>&nbsp;</p>
<p>etl文件转换转换工具下载地址</p>
<p><a href="https://github.com/microsoft/etl2pcapng/releases">https://github.com/microsoft/etl2pcapng/releases</a></p>
<p>&nbsp;</p>
<p>etl2pcapng.exe &lt;infile&gt;&lt;outfile&gt;</p>
<p>&nbsp;</p>
<p>例子</p>
<p>etl2pcapng.exe capture.etl out.pcapng</p>
<div>&nbsp;</div>
    