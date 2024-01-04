---
layout: post
title: Powershell 实现telnet 服务端
keywords: powershell
description: Powershell 实现telnet 服务端
categories: windows
---

简单的telnet服务器用于检测端口状态

<div class="cnblogs_code">
<pre><span style="color: #0000ff;">Write-Host</span> <span style="color: #800000;">"</span><span style="color: #800000;">这是一个简单的 TCP 服务器，用于监听指定的端口，并接收来自客户端的数据。</span><span style="color: #800000;">"</span>
<span style="color: #0000ff;">Write-Host</span> <span style="color: #800000;">"</span><span style="color: #800000;">客户端请使用telnet IP + 端口的方式连接至服务器</span><span style="color: #800000;">"</span>
<span style="color: #0000ff;">Write-Host</span> <span style="color: #800000;">"</span><span style="color: #800000;">目前同时只支持单个客户端，请勿连接多个客户端，会导致程序运行异常</span><span style="color: #800000;">"</span>
<span style="color: #0000ff;">Write-Host</span> <span style="color: #800000;">"</span><span style="color: #800000;">作者：ID404</span><span style="color: #800000;">"</span>
<span style="color: #0000ff;">Write-Host</span> <span style="color: #800000;">"</span><span style="color: #800000;">版本：1.0</span><span style="color: #800000;">"</span>
<span style="color: #0000ff;">Write-Host</span> <span style="color: #800000;">""</span>
<span style="color: #0000ff;">Write-Host</span> <span style="color: #800000;">"</span><span style="color: #800000;">按任意键继续执行程序...</span><span style="color: #800000;">"</span>
<span style="color: #800080;">$null</span> = <span style="color: #800080;">$Host</span>.UI.RawUI.ReadKey(<span style="color: #800000;">"</span><span style="color: #800000;">NoEcho,IncludeKeyDown</span><span style="color: #800000;">"</span><span style="color: #000000;">)


</span><span style="color: #008000;">#</span><span style="color: #008000;"> 监听端口</span>
<span style="color: #800080;">$port</span> = <span style="color: #0000ff;">Read-Host</span> -Prompt <span style="color: #800000;">"</span><span style="color: #800000;">请输入监听的TCP端口</span><span style="color: #800000;">"</span>
<span style="color: #0000ff;">Write-Host</span> <span style="color: #800000;">"</span><span style="color: #800000;">当前监听接口为TCP $port</span><span style="color: #800000;">"</span>

<span style="color: #008000;">#</span><span style="color: #008000;"> 获取本机IPv4地址</span>
<span style="color: #800080;">$ipAddresses</span> = (<span style="color: #0000ff;">Get-NetIPAddress</span> -AddressFamily IPv4 | <span style="color: #0000ff;">Where-Object</span> { <span style="color: #800080;">$_</span>.InterfaceAlias <span style="color: #008080;">-notlike</span> 'Loopback*<span style="color: #000000;">' }).IPAddress
</span><span style="color: #0000ff;">Write-Host</span> <span style="color: #800000;">"</span><span style="color: #800000;">当前电脑的 IP 地址是：$ipAddresses</span><span style="color: #800000;">"</span>

<span style="color: #008000;">#</span><span style="color: #008000;"> 创建 TcpListener 对象并开始监听</span>
<span style="color: #800080;">$listener</span> = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, <span style="color: #800080;">$port</span><span style="color: #000000;">)
</span><span style="color: #800080;">$listener</span><span style="color: #000000;">.Start()

</span><span style="color: #008000;">#</span><span style="color: #008000;"> 等待客户端连接</span>
<span style="color: #0000ff;">Write-Host</span> <span style="color: #800000;">"</span><span style="color: #800000;">等待客户端连接...</span><span style="color: #800000;">"</span><span style="color: #000000;">

try {
    </span><span style="color: #0000ff;">while</span> (<span style="color: #0000ff;">$true</span><span style="color: #000000;">) {
        </span><span style="color: #008000;">#</span><span style="color: #008000;"> 接受客户端连接并获取客户端的网络流对象</span>
        <span style="color: #800080;">$client</span> = <span style="color: #800080;">$listener</span><span style="color: #000000;">.AcceptTcpClient()
        </span><span style="color: #800080;">$stream</span> = <span style="color: #800080;">$client</span><span style="color: #000000;">.GetStream()

        </span><span style="color: #008000;">#</span><span style="color: #008000;"> 获取客户端的 IP 地址</span>
        <span style="color: #800080;">$clientIP</span> = <span style="color: #800080;">$client</span><span style="color: #000000;">.Client.RemoteEndPoint.Address
        </span><span style="color: #0000ff;">Write-Host</span> <span style="color: #800000;">"</span><span style="color: #800000;">客户端 $clientIP 连接成功</span><span style="color: #800000;">"</span>

        <span style="color: #008000;">#</span><span style="color: #008000;"> 循环接收客户端发送的数据</span>
        <span style="color: #0000ff;">while</span> (<span style="color: #0000ff;">$true</span><span style="color: #000000;">) {
            </span><span style="color: #008000;">#</span><span style="color: #008000;"> 接收客户端发送的数据</span>
            <span style="color: #800080;">$bufferSize</span> = 1024
            <span style="color: #800080;">$buffer</span> = <span style="color: #0000ff;">New-Object</span> byte[] <span style="color: #800080;">$bufferSize</span>
            <span style="color: #800080;">$bytesRead</span> = <span style="color: #800080;">$stream</span>.Read(<span style="color: #800080;">$buffer</span>, 0, <span style="color: #800080;">$bufferSize</span><span style="color: #000000;">)
            </span><span style="color: #800080;">$data</span> = [System.Text.Encoding]::ASCII.GetString(<span style="color: #800080;">$buffer</span>, 0, <span style="color: #800080;">$bytesRead</span><span style="color: #000000;">)
            </span><span style="color: #0000ff;">Write-Host</span> <span style="color: #800000;">"</span><span style="color: #800000;">接收到客户端发送的数据：$data</span><span style="color: #800000;">"</span>

            <span style="color: #008000;">#</span><span style="color: #008000;"> 回复客户端</span>
            <span style="color: #800080;">$response</span> = <span style="color: #800000;">"</span><span style="color: #800000;">已接收到数据：$data</span><span style="color: #800000;">"</span>
            <span style="color: #800080;">$responseBuffer</span> = [System.Text.Encoding]::ASCII.GetBytes(<span style="color: #800080;">$response</span><span style="color: #000000;">)
            </span><span style="color: #800080;">$stream</span>.Write(<span style="color: #800080;">$responseBuffer</span>, 0, <span style="color: #800080;">$responseBuffer</span><span style="color: #000000;">.Length)
            </span><span style="color: #800080;">$stream</span><span style="color: #000000;">.Flush()

            </span><span style="color: #008000;">#</span><span style="color: #008000;"> 如果客户端发送的数据为 "exit" 或 "quit"，则断开客户端连接</span>
            <span style="color: #0000ff;">if</span> (<span style="color: #800080;">$data</span>.ToLower().Trim() <span style="color: #008080;">-eq</span> <span style="color: #800000;">"</span><span style="color: #800000;">exit</span><span style="color: #800000;">"</span> <span style="color: #008080;">-or</span> <span style="color: #800080;">$data</span>.ToLower().Trim() <span style="color: #008080;">-eq</span> <span style="color: #800000;">"</span><span style="color: #800000;">quit</span><span style="color: #800000;">"</span><span style="color: #000000;">) {
                </span><span style="color: #800080;">$client</span><span style="color: #000000;">.Close()
                </span><span style="color: #0000ff;">Write-Host</span> <span style="color: #800000;">"</span><span style="color: #800000;">客户端 $clientIP 连接已断开</span><span style="color: #800000;">"</span>
                <span style="color: #0000ff;">break</span><span style="color: #000000;">
            }
        }
    }
}
</span><span style="color: #0000ff;">finally</span><span style="color: #000000;"> {
    </span><span style="color: #008000;">#</span><span style="color: #008000;"> 关闭监听器和流</span>
    <span style="color: #800080;">$listener</span><span style="color: #000000;">.Stop()
    </span><span style="color: #800080;">$stream</span><span style="color: #000000;">.Dispose()
    </span><span style="color: #800080;">$client</span><span style="color: #000000;">.Close()
    </span><span style="color: #0000ff;">Read-Host</span> <span style="color: #800000;">"</span><span style="color: #800000;">请按任意键退出程序...</span><span style="color: #800000;">"</span><span style="color: #000000;">
}</span></pre>
</div>
<p>&nbsp;</p>
    
