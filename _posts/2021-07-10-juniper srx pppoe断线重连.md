---
layout: post
title: juniper srx pppoe断线重连
keywords: juniper, srx, pppoe
description: juniper srx pppoe断线重连
categories: juniper
---

srx防火墙在配置pppoe拨号时可以增加auto-reconnect配置进行断线重连

<p>set interfaces pp0 unit 0 pppoe-options auto-reconnect 10</p>
<p>&nbsp;</p>
<p>同时也可以通过event-options监测pppoe接口，发现接口down后自动重连</p>
<div class="cnblogs_code">
<pre>set system syslog <span style="color: #0000ff;">file</span> syslog-event-daemon-<span style="color: #000000;">warning-id404 any any
set system syslog </span><span style="color: #0000ff;">file</span> syslog-event-daemon-warning-id404 match <span style="color: #800000;">"</span><span style="color: #800000;">SNMP_TRAP_LINK_DOWN|SNMP_TRAP_LINK_UP|ifOperStatus</span><span style="color: #800000;">"</span><span style="color: #000000;">

set event</span>-options policy reconnect-<span style="color: #000000;">pppoe-id404 events snmp_trap_link_down
set event</span>-options policy reconnect-pppoe-id404 attributes-match snmp_trap_link_down.interface-name matches pp0.<span style="color: #800080;">0</span><span style="color: #000000;">
set event</span>-options policy reconnect-pppoe-id404 <span style="color: #0000ff;">then</span> execute-commands commands <span style="color: #800000;">"</span><span style="color: #800000;">request pppoe connect pp0.0</span><span style="color: #800000;">"</span></pre>
</div>
<p>&nbsp;</p>
    
