---
layout: post
title: Linux下SSH免输密码快速登陆
keywords: linux, ssh, 免密
description: Linux下SSH免输密码快速登陆
categories: linux
---
在linux下可以通过ssh 连接远端设备时需要手动输入用户名和密码，免输入用户可以直接通过ssh -l Username 方式实现，但要做免输入密码使用ssh命令无法实现，此时需要用到expect。

<p>分别构建两个脚本，一个fssh 一个my.exp</p>
<p>my.exp实现ssh免输密码登陆，fssh记录用户名、密码、ip地址等信息。</p>
<p>分别将两个脚本放到/usr/bin目录下，并增加执行权限。</p>
<p>通过执行命令fssh XX 即可登陆到对应的远端设备</p>
<p>&nbsp;</p>
<p>Fssh 脚本</p>
<div class="cnblogs_code">
<pre>#!/bin/<span style="color: #0000ff;">sh</span><span style="color: #000000;">
store1(){
User</span>=<span style="color: #000000;">admin
Passwd</span>=<span style="color: #000000;">admin
IPaddr</span>=<span style="color: #800080;">1.1</span>.<span style="color: #800080;">1.1</span>
/usr/bin/<span style="color: #000000;">my.exp $User $Passwd $IPaddr
}

store2(){
User</span>=<span style="color: #000000;">admin
Passwd</span>=<span style="color: #000000;">admin
IPaddr</span>=<span style="color: #800080;">2.2</span>.<span style="color: #800080;">2.2</span>
/usr/bin/<span style="color: #000000;">my.exp $User $Passwd $IPaddr
}

bhc(){
User</span>=<span style="color: #000000;">admin
Passwd</span>=<span style="color: #000000;">admin
IPaddr</span>=<span style="color: #800080;">3.3</span>.<span style="color: #800080;">3.3</span>
/usr/bin/<span style="color: #000000;">my.exp $User $Passwd $IPaddr
}

store4(){
User</span>=<span style="color: #000000;">store4
Passwd</span>=<span style="color: #000000;">admin
IPaddr</span>=<span style="color: #800080;">4.4</span>.<span style="color: #800080;">4.4</span>
/usr/bin/<span style="color: #000000;">my.exp $User $Passwd $IPaddr
}


asa5510(){
User</span>=<span style="color: #000000;">store4
Passwd</span>=<span style="color: #000000;">admin
IPaddr</span>=<span style="color: #800080;">5.5</span>.<span style="color: #800080;">5.5</span>
/usr/bin/<span style="color: #000000;">my.exp $User $Passwd $IPaddr
}


</span><span style="color: #0000ff;">if</span> [ $<span style="color: #800080;">1</span> = <span style="color: #800000;">"</span><span style="color: #800000;">store1</span><span style="color: #800000;">"</span> ];<span style="color: #0000ff;">then</span><span style="color: #000000;">
store1
</span><span style="color: #0000ff;">elif</span> [ $<span style="color: #800080;">1</span> = <span style="color: #800000;">"</span><span style="color: #800000;">store4</span><span style="color: #800000;">"</span> ];<span style="color: #0000ff;">then</span><span style="color: #000000;">
store4
</span><span style="color: #0000ff;">elif</span> [ $<span style="color: #800080;">1</span> = <span style="color: #800000;">"</span><span style="color: #800000;">store2</span><span style="color: #800000;">"</span> ];<span style="color: #0000ff;">then</span><span style="color: #000000;">
store2
</span><span style="color: #0000ff;">elif</span> [ $<span style="color: #800080;">1</span> = <span style="color: #800000;">"</span><span style="color: #800000;">bhc</span><span style="color: #800000;">"</span> ];<span style="color: #0000ff;">then</span><span style="color: #000000;">
bhc
</span><span style="color: #0000ff;">elif</span> [ $<span style="color: #800080;">1</span> = <span style="color: #800000;">"</span><span style="color: #800000;">asa5510</span><span style="color: #800000;">"</span> ];<span style="color: #0000ff;">then</span><span style="color: #000000;">
asa5510
</span><span style="color: #0000ff;">else</span>
<span style="color: #0000ff;">echo</span> <span style="color: #800000;">"</span><span style="color: #800000;">var error</span><span style="color: #800000;">"</span>
<span style="color: #0000ff;">fi</span></pre>
</div>
<div class="cnblogs_Highlighter">
<pre class="brush:bash;gutter:true;">　　</pre>
</div>
<p>expect 脚本：my.exp</p>
<div class="cnblogs_code">
<pre>#!/usr/bin/expect -<span style="color: #000000;">f

set User [lindex $argv </span><span style="color: #800080;">0</span><span style="color: #000000;">]
set Passwd [lindex $argv </span><span style="color: #800080;">1</span><span style="color: #000000;">]
set IPadd [lindex $argv </span><span style="color: #800080;">2</span><span style="color: #000000;">]

spawn </span><span style="color: #0000ff;">ssh</span><span style="color: #000000;"> $User@$IPadd
expect {
</span><span style="color: #800000;">"</span><span style="color: #800000;">*yes/no</span><span style="color: #800000;">"</span> { send <span style="color: #800000;">"</span><span style="color: #800000;">yes\r</span><span style="color: #800000;">"</span><span style="color: #000000;">;exp_continue }
</span><span style="color: #800000;">"</span><span style="color: #800000;">*assword*</span><span style="color: #800000;">"</span> { send <span style="color: #800000;">"</span><span style="color: #800000;">$Passwd\r</span><span style="color: #800000;">"</span><span style="color: #000000;"> }
}
interact
exit</span></pre>
</div>
<p>&nbsp;</p>
    
