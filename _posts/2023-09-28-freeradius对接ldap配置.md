---
layout: post
title: freeradius对接ldap配置
keywords: freeradius, ldap
description: freeradius对接ldap配置
categories: linux
---

1、安装freeradius

yum install freeradius freeradius-utils freeradius-ldap freeradius-krb5

 

2、启用LDAP 模块

ln -s /etc/raddb/mods-available/ldap /etc/raddb/mods-enabled/

 

3、配置radius客户端，修改/etc/raddb/clients.conf

client mbp {
ipaddr = 192.168.0.33/32
secret = 123456
}

4、修改/etc/raddb/sites-enabled/default 和 /etc/raddb/sites-enabled/inner-tunnel文件

 

取消ldap前的注释

ldap

if ((OK || updated) && User-Password){
 update{
 control:Auth-Type:=ldap
 }
 }

同时取消Auth-Type LDAP的注释

Auth-Type LDAP {

　　ldap

}

 

5、添加LDAP服务器的对接参数 ，修改/etc/raddb/mods-enable/ldap

主要修改以下配置，以下为对接freeipa的参数 ，其它如AD请自行修改信息

server = '10.0.0.10'

identity = 'uid=admin,cn=users,cn=accounts,dc=freeipa,dc=fly,dc=cn'
password = 123456

base_dn = 'cn=users,cn=accounts,dc=freeipa,dc=fly,dc=cn'

 

6、修改完毕后可以启动freeradius 或执行radiusd -X 进入debug 模式测试认证

 

文章内容参考：https://eduroam.in/wp-content/uploads/2022/03/Configure-Freeradius-3-with-LDAP.pdf
    
