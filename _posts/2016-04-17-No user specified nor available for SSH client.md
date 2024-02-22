---
layout: post
title: No user specified nor available for SSH client
keywords: cisco, ASA, SSH
description: No user specified nor available for SSH client
categories: cisco
---
ASA防火墙配置好ssh后，从另一个直连的路由器ssh登陆提示：No user specified nor available for SSH client
<p>ASA IP 192.168.1.1 用户名admin</p>
<p>在路由器ssh登陆时添加参数 -l 指定用户名：</p>
<p>R# ssh -l admin 192.168.1.1</p>
    
