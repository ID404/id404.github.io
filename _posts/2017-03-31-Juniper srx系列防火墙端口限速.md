---
layout: post
title: Juniper srx系列防火墙端口限速
keywords: juniper, srx, 端口限速
description: Juniper srx系列防火墙端口限速
categories: juniper
---
端口限速
<img src="/images/blog/725676-20170331225122258-117962044.png" alt="" />

限制上传速度(应用到内网接口)

	set firewall family inet filter upload-limit term 0 from source-address 192.168.0.16/32
	set firewall family inet filter upload-limit term 0 then policer upload-1mb
	set firewall family inet filter upload-limit term 0 then accept
	set firewall family inet filter upload-limit term 1 from source-address 192.168.0.0/24
	set firewall family inet filter upload-limit term 1 then policer upload-9mb
	set firewall family inet filter upload-limit term 1 then accept
	set firewall family inet filter upload-limit term 2 then accept （其它网段不限速）
	set firewall policer upload-1mb if-exceeding bandwidth-limit 1m
	set firewall policer upload-1mb if-exceeding burst-size-limit 625k
	set firewall policer upload-1mb then discard
	set firewall policer upload-9mb if-exceeding bandwidth-limit 3m
	set firewall policer upload-9mb if-exceeding burst-size-limit 625k
	set firewall policer upload-9mb then discard 
应用到内网接口

	set interfaces vlan unit 100 family inet filter input upload-limit

限制下载速度（应用到内网接口）

	set firewall family inet filter download-limit term 0 from destination-address 192.168.0.222/32
	set firewall family inet filter download-limit term 0 then policer download-1mb
	set firewall family inet filter download-limit term 0 then accept
	set firewall family inet filter download-limit term 1 from destination-address 192.168.0.0/24
	set firewall family inet filter download-limit term 1 then policer download-9mb
	set firewall family inet filter download-limit term 1 then accept
	set firewall family inet filter download-limit term 2 then accept （其它网段不限速）
	set firewall policer download-1mb if-exceeding bandwidth-limit 1m
	set firewall policer download-1mb if-exceeding burst-size-limit 625k
	set firewall policer download-1mb then discard
	set firewall policer download-9mb if-exceeding bandwidth-limit 3m
	set firewall policer download-9mb if-exceeding burst-size-limit 625k
	set firewall policer download-9mb then discard 
应用到内网接口

	set interfaces vlan unit 100 family inet filter output download-limit
    
