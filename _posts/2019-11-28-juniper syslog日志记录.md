---
layout: post
title: juniper syslog日志记录
keywords: juniper, syslog
description: juniper syslog日志记录
categories: juniper
---

详细日志的关键字可以通过https://apps.juniper.net/syslog-explorer/查询
<p>查询日志可通过命令show log XXX显示 ，其中XXX为文件名</p>
<p><br />set security log mode stream<br />set security log report</p>
<p><br />为了记录日志发生时间的准确性，建议首先设置好ntp服务器<br />set system ntp server cn.pool.ntp.org </p>
<p>记录接口up down状态<br />set system syslog file interfaces-logs any any<br />set system syslog file interfaces-logs match ifOperStatus</p>
<p>VPN日志记录<br />set system syslog file kmd-logs daemon info<br />set system syslog file kmd-logs match KMD</p>
<p>用户命令执行记录<br />set system syslog file interactive-commands interactive-commands any</p>
<p>用户认证记录（所有）<br />set system syslog file auth.log authorization info</p>
<p>用户认证成功记录<br />set system syslog file auth_success.log authorization info<br />set system syslog file auth_success.log match "Accepted| LOGIN_INFORMATION"</p>
<p><br />用户修改记录<br />set system syslog file change.log change-log info</p>
<p>记录dynamic vpn用户认证记录<br />Set system syslog file dyn_success.log any any<br />Set system syslog file dyn_success.log match "DYNAMIC_VPN| FWAUTH| KMD_VPN_UP_ALARM_USER"</p>
<p><br />记录ping对端IP不可达<br />set system syslog file ping_to_GZ any any<br />set system syslog file ping_to_GZ match "PING_TEST_FAILED| PING_PROBE_FAILED"</p>
<p>set services rpm probe prob test ping_test_to_GZ target address 192.168.12.12<br />set services rpm probe prob test ping_test_to_GZ probe-count 5<br />set services rpm probe prob test ping_test_to_GZ probe-interval 1<br />set services rpm probe prob test ping_test_to_GZ test-interval 2<br />set services rpm probe prob test ping_test_to_GZ thresholds successive-loss 2<br />set services rpm probe prob test ping_test_to_GZ thresholds total-loss 4</p>
<p><br />记录会话日志<br />set&nbsp;system&nbsp;syslog&nbsp;file&nbsp;traffic-log&nbsp;any&nbsp;any<br />set&nbsp;system&nbsp;syslog&nbsp;file&nbsp;traffic-log&nbsp;match&nbsp;"RT_FLOW_SESSION" <br />策略中要加上session-init或session-close \ couunt</p>
<p>&nbsp;</p>
<p>set system syslog file policy_session user info<br />set system syslog file policy_session match RT_FLOW<br />set system syslog file policy_session archive size 1000k<br />set system syslog file policy_session archive world-readable<br />set system syslog file policy_session structured-data</p>
<p><br />将syslog发送到远程日志服务器<br />Set system syslog host 192.168.0.123 any any</p>
<p>记录IDP日志<br /> set system syslog file IDP_Log any any<br />set system syslog file IDP_Log match "RT_IDP"</p>
    
