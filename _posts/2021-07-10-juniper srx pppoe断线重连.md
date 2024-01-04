---
layout: post
title: juniper srx pppoe断线重连
keywords: juniper, srx, pppoe
description: juniper srx pppoe断线重连
categories: juniper
---
srx防火墙在配置pppoe拨号时可以增加auto-reconnect配置进行断线重连

set interfaces pp0 unit 0 pppoe-options auto-reconnect 10

同时也可以通过event-options监测pppoe接口，发现接口down后自动重连

	set system syslog file syslog-event-daemon-warning-id404 any any
	set system syslog file syslog-event-daemon-warning-id404 match "SNMPTRAPLINKDOWN|SNMPTRAPLINKUP|ifOperStatus"
	
	
	set event-options policy reconnect-pppoe-id404 events snmptraplinkdown
	set event-options policy reconnect-pppoe-id404 attributes-match snmptraplinkdown.interface-name matches pp0.0
	set event-options policy reconnect-pppoe-id404 then execute-commands commands "request pppoe connect pp0.0"
	    
