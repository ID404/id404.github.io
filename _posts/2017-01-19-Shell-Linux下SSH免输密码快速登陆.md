---
layout: post
title: Linux下SSH免输密码快速登陆
keywords: linux, ssh, 免密
description: Linux下SSH免输密码快速登陆
categories: linux
---
在linux下可以通过ssh 连接远端设备时需要手动输入用户名和密码，免输入用户可以直接通过ssh -l Username 方式实现，但要做免输入密码使用ssh命令无法实现，此时需要用到expect。

分别构建两个脚本，一个fssh 一个my.exp

my.exp实现ssh免输密码登陆，fssh记录用户名、密码、ip地址等信息。

分别将两个脚本放到/usr/bin目录下，并增加执行权限。

通过执行命令fssh XX 即可登陆到对应的远端设备

Fssh 脚本:

	#!/bin/sh
	store1(){
	User=admin
	Passwd=admin
	IPaddr=1.1.1.1
	/usr/bin/my.exp $User $Passwd $IPaddr
	}
	
	store2(){
	User=admin
	Passwd=admin
	IPaddr=2.2.2.2
	/usr/bin/my.exp $User $Passwd $IPaddr
	}
	
	bhc(){
	User=admin
	Passwd=admin
	IPaddr=3.3.3.3
	/usr/bin/my.exp $User $Passwd $IPaddr
	}
	
	store4(){
	User=store4
	Passwd=admin
	IPaddr=4.4.4.4
	/usr/bin/my.exp $User $Passwd $IPaddr
	}
	
	
	asa5510(){
	User=store4
	Passwd=admin
	IPaddr=5.5.5.5
	/usr/bin/my.exp $User $Passwd $IPaddr
	}
	
	
	if [ $1 = "store1" ];then
	store1
	elif [ $1 = "store4" ];then
	store4
	elif [ $1 = "store2" ];then
	store2
	elif [ $1 = "bhc" ];then
	bhc
	elif [ $1 = "asa5510" ];then
	asa5510
	else
	echo "var error"
	fi
 
 
<p>expect 脚本：my.exp</p>
	
	#!/usr/bin/expect -f
		
	set User [lindex $argv 0]
	set Passwd [lindex $argv 1]
	set IPadd [lindex $argv 2]
		
	spawn ssh $User@$IPadd
	expect {
	"*yes/no" { send "yes\r";exp_continue }
	"*assword*" { send "$Passwd\r" }
	}
	interact
	exit
    
