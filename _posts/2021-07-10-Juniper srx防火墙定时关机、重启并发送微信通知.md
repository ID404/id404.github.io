---
layout: post
title: Juniper srx防火墙定时关机、重启并发送微信通知
keywords:
description:
categories:
---
<h1><strong>方法一：使用event-options进行定时关机</strong></h1>
<p>配置前先确定设备的时间是否准确，可通过命令检查</p>
<p>run show system uptime</p>
<p>若时间不准确，需要设置NTP服务器确保设备时间正常</p>
<p>NTP服务器设置参考：set system ntp server ntp1.aliyun.com</p>
<p>&nbsp;</p>
<p>以下配置为设置防火墙在北京时间每天00：15关机</p>
<p>&nbsp;</p>
<div class="cnblogs_code">
<pre>set event-options generate-event shutdowndaily-id404 <span style="color: #0000ff;">time</span>-of-day <span style="color: #800000;">"</span><span style="color: #800000;">00:15:00 +0800</span><span style="color: #800000;">"</span><span style="color: #000000;">
set event</span>-options policy shutdown-<span style="color: #000000;">srx100 events shutdowndaily-id404
set event</span>-options policy shutdown-srx100 <span style="color: #0000ff;">then</span> execute-commands commands <span style="color: #800000;">"</span><span style="color: #800000;">request system power-off</span><span style="color: #800000;">"</span>　　　　　　</pre>
</div>
<p>若需要设置为重启，可将脚本的power-off 改为reboot</p>
<p>&nbsp;</p>
<h1><strong>方法二：通过shell脚本</strong></h1>
<p>由于event-options 执行的条件只有time-interval(每隔XX秒执行) 和 time-of-day (每天指定时间) 两种方式 ，执行起来不够灵活。比如我想设定每周工作日指定时间关机，通过event-options就无法实现。</p>
<p>这种需求可通过shell编写关机脚本，通过crontab定时执行关机脚本实现</p>
<p>在配置模式下通过命令run start shell 进入shell 模式</p>
<div class="cnblogs_code">
<pre><span style="color: #000000;">root@id404# run start shell
root@id404</span>%</pre>
</div>
<p>首先确定脚本存放的位置 ，我将脚本放置在/cf/var/log/shutdown.sh &nbsp;也可以放置在其它文件夹，但需要确保设备重启后文件夹不会清空。有部分文件夹会在设备重启后清空的</p>
<p>编写关机脚本</p>
<div class="cnblogs_code">
<pre>root@id404% <span style="color: #0000ff;">vi</span> /cf/var/log/shutdown.<span style="color: #0000ff;">sh</span></pre>
</div>
<p>&nbsp;</p>
<p>脚本内容</p>
<div class="cnblogs_code">
<pre>#!bin/sh<br />#Author:id404<br />/sbin/shutdown -h now</pre>
</div>
<p>修改定时任务</p>
<div class="cnblogs_code">
<pre>root@% crontab -e</pre>
</div>
<p>定时任务内容</p>
<div class="cnblogs_code">
<pre><span style="color: #800080;">10</span> <span style="color: #800080;">0</span> * * <span style="color: #800080;">1</span>,<span style="color: #800080;">2</span>,<span style="color: #800080;">3</span>,<span style="color: #800080;">4</span>,<span style="color: #800080;">5</span> /bin/<span style="color: #0000ff;">sh</span> /cf/var/log/shutdown.<span style="color: #0000ff;">sh</span></pre>
</div>
<p>定时任务设置的内容为周一至同五 00：10 执行关机脚本</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>-----------------------------------------------------</p>
<h1>进阶：关机前微信通知</h1>
<p>微信通知主要是通过shell脚本提交http get请求至通知服务器，由通知服务器推送请求至微信</p>
<p>支持http get的通知服务器有很多 ，可自行选择plushplus、server酱、telegram机器人、BARK等。</p>
<p>我采用的是pushplus通知。</p>
<p>首先通过微信登陆官网&nbsp;http://pushplus.plus</p>
<p>登陆后找到调用方式一栏</p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20210710183401999-1848725155.png" alt="" width="614" height="455" loading="lazy" /></p>
<p>&nbsp;</p>
<p>http://www.pushplus.plus/send?token=bc3046106fec489ad&amp;title=XXX&amp;content=XXX&amp;template=html&nbsp;</p>
<p>将内容中的title=XXX中的XXX修改为标题，比如&ldquo;断网通知&rdquo;;将content=XXX中的XXX修改为内容，比如&ldquo; 设备将天5分钟后关机&rdquo;</p>
<p><span style="color: #ff0000;">注意每个账号的token是不一样的，不要复制我文章上的token内容!!!</span></p>
<p>&nbsp;</p>
<p>修改后复制到浏览器并提交，正常情况下微信会收到通知</p>
<p>&nbsp;</p>
<p>确定微信收到通知后下一步修改关机脚本：</p>
<p>&nbsp;</p>
<div class="cnblogs_code">
<pre>#!bin/<span style="color: #0000ff;">sh</span><span style="color: #000000;">
#Author:id404
curl </span>-d <span style="color: #800000;">"token=bc3046106fec489ad&amp;title=断网通知&amp;content=宿舍出口将于5分钟后关闭&amp;template=html" http://www.pushplus.plus/send</span>
sleep 300
/sbin/shutdown -h now</pre>
</div>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>效果如下：</p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20210710185353405-1522104842.png" alt="" width="399" height="874" loading="lazy" /></p>
<p>&nbsp;</p>
    
