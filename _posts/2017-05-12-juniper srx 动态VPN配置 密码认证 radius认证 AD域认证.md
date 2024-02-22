---
layout: post
title: juniper srx 动态VPN配置 密码认证 radius认证 AD域认证
keywords: juniper, srx, radius, AD
description: juniper srx 动态VPN配置 密码认证 radius认证 AD域认证
categories: juniper
---
 
juniper srx系列防火墙的动态VPN又叫dynamic vpn ,可以通过电脑客户端远程拨入到设备所在网络中.目前低端系列的防火墙如srx100 srx210 srx240 srx550 srx650设备默认支持两个动态VPN并发授权,超过两个授权需要开通相应的license .srx300系列需要高版本才能支持,前段时间测试过300系列15.1D49是不支持动态VPN的,好像需要升级到D51版本以上.

 

开启https

	set system services web-management https system-generated-certificate
	set system services web-management https interface vlan.0
 

配置动态VPN后可能无法通过http进入到设备管理界面

	set system services web-management management-url admin
输入以上命令可以通过http://ip地址/admin 这个url进入设备管理界面

 

配置ike参数,其中fe-0/0/0.0为外网接口

 
	set security ike policy ike-dyn-vpn-policy mode aggressive
	set security ike policy ike-dyn-vpn-policy proposal-set standard
	set security ike policy ike-dyn-vpn-policy pre-shared-key ascii-text "$9$IlCRhSrlv8L7Vw.PTQn6lKv"
	set security ike gateway dyn-vpn-local-gw ike-policy ike-dyn-vpn-policy
	set security ike gateway dyn-vpn-local-gw dynamic hostname dynvpn
	set security ike gateway dyn-vpn-local-gw dynamic connections-limit 10
	set security ike gateway dyn-vpn-local-gw dynamic ike-user-type group-ike-id
	set security ike gateway dyn-vpn-local-gw external-interface fe-0/0/0.0
	set security ike gateway dyn-vpn-local-gw xauth access-profile dyn-vpn-access-profile
 
 

配置ipsec参数

	set security ipsec policy ipsec-dyn-vpn-policy proposal-set standard
	set security ipsec vpn dyn-vpn ike gateway dyn-vpn-local-gw
	set security ipsec vpn dyn-vpn ike ipsec-policy ipsec-dyn-vpn-policy
 

配置客户账号访问参数,不同账号可以访问到哪些资源 ,可以通过这里配置,示例中为用户test1只可以访问10.1.1.2这个主机IP,其它资源禁止访问,其它用户可以访问10.0.0.0/8网段的资源.注意配置的顺序,策略的匹配都是从上到下的,all建议放在最后.注意如果配置了radius认证服务器,相应可以远程拨入的用户也需要在这里添加 ,否则用户无法拨入.

 
	set security dynamic-vpn access-profile dyn-vpn-access-profile
	set security dynamic-vpn clients test remote-protected-resources 10.1.1.2/32
	set security dynamic-vpn clients test remote-exceptions 0.0.0.0/0
	set security dynamic-vpn clients test ipsec-vpn dyn-vpn
	set security dynamic-vpn clients test user test1
	set security dynamic-vpn clients all remote-protected-resources 10.0.0.0/8
	set security dynamic-vpn clients all remote-exceptions 0.0.0.0/0
	set security dynamic-vpn clients all ipsec-vpn dyn-vpn
	set security dynamic-vpn clients all user aa
	set security dynamic-vpn clients all user client1
	set security dynamic-vpn clients all user client2
	set security dynamic-vpn clients all user test
 
 

 

配置安全策略

	set security policies from-zone untrust to-zone trust policy dyn-vpn-policy match source-address any
	set security policies from-zone untrust to-zone trust policy dyn-vpn-policy match destination-address any
	set security policies from-zone untrust to-zone trust policy dyn-vpn-policy match application any
	set security policies from-zone untrust to-zone trust policy dyn-vpn-policy then permit tunnel ipsec-vpn dyn-vpn
 

允许外网访问https和ike

	set security zones security-zone untrust interfaces fe-0/0/0.0 host-inbound-traffic system-services ike
	set security zones security-zone untrust interfaces fe-0/0/0.0 host-inbound-traffic system-services https
	 

  设置相应的认证方式和地址池,如果是本地认证,可以去掉

  set access profile dyn-vpn-access-profile authentication-order radius   

  set access profile dyn-vpn-access-profile authentication-order password

 
	set access profile dyn-vpn-access-profile authentication-order password
	set access profile dyn-vpn-access-profile client client1 firewall-user password "$9$KTdMxNVwYoZUx7VYoGq.Ctu"
	set access profile dyn-vpn-access-profile address-assignment pool dyn-vpn-address-pool
	set access profile dyn-vpn-access-profile session-options client-idle-timeout 180
	set access profile dyn-vpn-access-profile radius-server 192.168.0.44 secret "$9$DJjmT6/tOIcApclvLVbaZUj.PTz39tu"
	set access address-assignment pool dyn-vpn-address-pool family inet network 10.10.10.0/24
	set access address-assignment pool dyn-vpn-address-pool family inet xauth-attributes primary-dns 4.2.2.2/32
	set access firewall-authentication web-authentication default-profile dyn-vpn-access-profile
　这两句,示例中配置的是radius认证,这里的client1 为本地用户, 如果配置了多种认证方式,设备默认只使用第一种认证方式,这里一直没搞明白为什么,如果只认第一种认证方式的话为什么可以配置多种认证方式?在动态VPN里面设备默认没对认证服务器做轮询.这个要区别于system 层次里面的认证,登陆管理设备的账号同样可以同时配置radius 认证和本地认证,而且会对认证服务器进行轮询,比如raidus服务器认证失败了,会将请求发送到本地,如果所有认证服务器都认证不成功才会提示认证失败.



 

若需要结合微软AD域做认证,可将access profile按以下内容更改.

实例中AD域为test.com 域服务器为192.168.0.223

 
	set access profile dyn-vpn-access-profile authentication-order ldap
	set access profile dyn-vpn-access-profile address-assignment pool dyn-vpn-address-pool
	set access profile dyn-vpn-access-profile session-options client-idle-timeout 180
	set access profile dyn-vpn-access-profile ldap-options base-distinguished-name CN=Users,DC=test,DC=com
	set access profile dyn-vpn-access-profile ldap-options search search-filter sAMAccountName=
	set access profile dyn-vpn-access-profile ldap-options search admin-search distinguished-name CN=administrator,CN=Users,DC=test,DC=com
	set access profile dyn-vpn-access-profile ldap-options search admin-search password "$9$W31L-Vs24ZDi-ds4ZjPfp0B"
	set access profile dyn-vpn-access-profile ldap-server 192.168.0.223 port 389
	set access address-assignment pool dyn-vpn-address-pool family inet network 10.10.10.0/24
	set access address-assignment pool dyn-vpn-address-pool family inet xauth-attributes primary-dns 4.2.2.2/32
	set access firewall-authentication web-authentication default-profile dyn-vpn-access-profile
    
