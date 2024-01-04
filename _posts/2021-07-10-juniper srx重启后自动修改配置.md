---
    layout: post
    title: juniper srx重启后自动修改配置
    tags:
    categories:
    ---
    <p>在配置模式下通过命令run start shell 进入shell 模式</p>
<div class="cnblogs_code">
<pre>root@id404# run start shell
root@id404%</pre>
</div>
<p>首先确定脚本存放的位置 ，我将脚本放置在/cf/var/log/change-config.sh &nbsp;也可以放置在其它文件夹，但需要确保设备重启后文件夹不会清空。有部分文件夹会在设备重启后清空的</p>
<p>脚本内容：</p>
<div class="cnblogs_code">
<pre><span style="color: #0000ff;">#!/bin/sh<br />#author:id404<br /><br />echo</span> <span style="color: #800000;">'</span><span style="color: #800000;">STARTING sleep 300s to complete boot process</span><span style="color: #800000;">'</span> &gt;&gt;  /var/log/updatevpn-<span style="color: #0000ff;">date</span><span style="color: #000000;">.log
logger </span><span style="color: #800000;">"</span><span style="color: #800000;">STARTING sleep 300s to complete boot process</span><span style="color: #800000;">"</span>
<span style="color: #0000ff;">sleep</span> <span style="color: #800080;">300</span>
<span style="color: #0000ff;">echo</span> <span style="color: #800000;">'</span><span style="color: #800000;">after 300s</span><span style="color: #800000;">'</span> &gt;&gt;  /var/log/updatevpn-<span style="color: #0000ff;">date</span><span style="color: #000000;">.log
logger </span><span style="color: #800000;">"</span><span style="color: #800000;">AFTER 300s</span><span style="color: #800000;">"</span><span style="color: #000000;">
logger </span><span style="color: #800000;">"</span><span style="color: #800000;">STARTING configuration using script</span><span style="color: #800000;">"</span>
<span style="color: #0000ff;">date</span> &gt;&gt; /var/log/updatevpn-<span style="color: #0000ff;">date</span><span style="color: #000000;">.log
</span><span style="color: #0000ff;">echo</span> <span style="color: #800000;">"</span><span style="color: #800000;">STARTING configuration using script</span><span style="color: #800000;">"</span>  &gt;&gt; /var/log/updatevpn-<span style="color: #0000ff;">date</span><span style="color: #000000;">.log
</span>/usr/sbin/cli -c <span style="color: #800000;">'</span><span style="color: #800000;">configure;delete security ike gateway id404-sdwan-gw address;set security ike gateway id404-sdwan-gw address vpn.id404.cn;commit comment "Commit by script updatevpn address"</span><span style="color: #800000;">'</span></pre>
</div>
<p>&nbsp;</p>
<p>修改定时任务内容</p>
<div class="cnblogs_code">
<pre>root@id404% crontab -e</pre>
</div>
<div class="cnblogs_code">
<pre>@reboot /bin/sh /cf/var/log/change-config.sh</pre>
</div>
    
