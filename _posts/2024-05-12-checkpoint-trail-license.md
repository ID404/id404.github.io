---
layout: post
title: checkpoint防火墙测试授权申请
keywords: checkpoint, 防火墙, 测试授权申请
description: 在线申请checkpoint防火墙临时授权
categories: checkpoint
---
本文介绍如何在线申请checkpoint防火墙的测试授权

请先确保已注册官网账号并能正常登录Product Center，并安装好checkpoint并配置好管理IP
(授权申请需要用到设备IP地址，不需要连网)
(官网账号最好使用公司邮箱申请)

[Product Center 链接 ](https://usercenter.checkpoint.com/usercenter/portal/js_pane/AccountsId,ProductsCenterId)

正常登录后可看到如下图内容

 ![product center](/images/blog/checkpoint_license/checkpoint_license0.png)

其中select account里面有相关账号

选择product center中的Product Evaluation 或 打开链接下面链接

 [授权申请](https://usercenter.checkpoint.com/ucapps/prodeval)

![license_1](/images/blog/checkpoint_license/licsense_1.png)

选择 `ALL-IN-ONE EVALUATION`

在`User Center Account`选择自己的账户

`IP Address`填写防火墙或管理平台的IP地址

`Purpose of Evaluation`随便选

最后勾选下面两个选项并点击`Get Evaluation`

随后会提示申请成功，并且账号邮箱会收到相关邮件，如下图

![申请成功](/images/blog/checkpoint_license/licsense_3.png)

![申请成功2](/images/blog/checkpoint_license/licsense_5.png)

其中 cplic开头的一行为申请到的授权，复制这行文本内容

打开checkpoint管理平台，进入`Maintance` - `License Status`

点击`Offline Activation` - `New`

将刚才复制的文本粘贴至第一行中，下面IP等内容会自动填充，最后点击OK即可

![finish](/images/blog/checkpoint_license/checkpoint_license_9.png)

![finish](/images/blog/checkpoint_license/checkpoint_license_10.png)
