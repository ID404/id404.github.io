---
    layout: post
    title: Juniper SRX防火墙U盘启动及硬盘故障恢复
    tags:
    categories:
    ---
    <p>Juniper SRX防火墙可以设置为U盘启动，当设备内置硬盘故障时可以临时用预先制作好的U盘启动</p>
<p><a href="https://www.cnblogs.com/id404/" target="_blank">步骤如下</a>：</p>
<p>1、从正常的设备上将系统镜像至U盘(或可以将做好的镜像文件写入至U盘)</p>
<p>2、将U盘接至损坏的设备上，设置从U盘启动设备</p>
<p>3、设备成功启动后将U盘镜像至设备内置硬盘</p>
<p>&nbsp;</p>
<h1><strong>1、从正常的设备上将系统镜像至U盘(或可以将做好的镜像文件写入至U盘)</strong></h1>
<p>进入正常的设备后，接入U盘，若设备能正常识别U盘，console会出现如下提示</p>
<p>若通过ssh或telnet进入，需要查看日志文件messages,命令show log message</p>
<p><img src="/images/blog/725676-20220118104115008-1055795944.png" alt="" /></p>
<p>&nbsp;</p>
<p>将系统硬盘镜像至U盘命令：</p>
<p>request system snapshot media usb</p>
<p>&nbsp;</p>
<p>制作过程视U盘速度，一般10-20分钟左右。</p>
<p>&nbsp;</p>
<p>U盘制作完毕后可以测试一下是否能从U盘启动</p>
<p>执行命令：request system reboot media usb at now</p>
<p>&nbsp;</p>
<p>重启后若出现如下提示，则表示从U盘启动成功：</p>
<p>&nbsp;NOTICE: System is running on alternate media device &nbsp; &nbsp; &nbsp;(/dev/da1s1a)</p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20220118110118204-1626057035.png" alt="" /></p>
<p>&nbsp;</p>
<h1>2、将U盘接至损坏的设备上，设置从U盘启动设备</h1>
<p>正常关机后，U盘就可以拿到故障的SRX上将U盘的系统恢复至设备内置硬盘或从U盘启动</p>
<p>在故障设备启动时按空格 进入loader模式</p>
<p>设置从U盘启动<br />loader&gt; nextboot usb</p>
<p>loader&gt;reboot</p>
<p><img src="/images/blog/725676-20220118110348537-2019525044.png" alt="" /></p>
<p>&nbsp;</p>
<h1>3、设备成功启动后将U盘镜像至设备内置硬盘</h1>
<p>从U盘启动后，执行命令request system snapshot media internal可将U盘镜像至设备内置硬盘</p>
<p>镜像成功后重启并<a href="https://www.cnblogs.com/id404/" target="_blank">断开U盘即可</a>。</p>
<p>&nbsp;</p>
<p>------------------------------------------------------------------</p>
<p>制作好的U盘，可以用UltraISO、WinImage等工具做成镜像文件。客户设备故障直接将镜像文件传过去即可。</p>
<p>&nbsp;</p>
<p>srx340系列早期的设备内置硬盘容易故障，也无法通过镜像、重装方式恢复。可以临时用U盘启动来解决，彻底的解决方式是更换设备内置的硬盘</p>
<p>&nbsp;</p>
<p>可以在淘宝或闲鱼搜索dom 电子盘</p>
<p><img src="/images/blog/725676-20220118133419193-1726122228.png" alt="" width="568" height="502" /></p>
<p>&nbsp;</p>
    
