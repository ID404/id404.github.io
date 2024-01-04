---
layout: post
title: linux清空linux 和history
keywords: linux, history
description: linux清空linux 和history
categories: linux
---
 echo > /var/log/wtmp;echo > /var/log/btmp;history -c;echo > ./.bash_history

 可设置定时任务，定时清空
 
    
