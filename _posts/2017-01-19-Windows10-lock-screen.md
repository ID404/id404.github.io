---
	 post:
title: Windows10 锁屏无法登陆
date: 2017-01-19 14:18:00
description:
:
categories:
---
    <p>管理员运行cmd 执行以下</p>
<p><br />if exist "%SystemRoot%\System32\InputMethod\CHS\ChsIME.exe" (<br />TAKEOWN /F "%SystemRoot%\System32\InputMethod\CHS\ChsIME.exe"<br />icacls "%SystemRoot%\System32\InputMethod\CHS\ChsIME.exe" /deny "NT AUTHORITY\SYSTEM:RX"</p>
<p>)</p>
<p>&nbsp;</p>
    