---
    title: No user specified nor available for SSH client
    date: 2016-04-17 11:51:00
    updated: 2016-04-17 11:51:00
    abbrlink: 5400667
    tags:
    categories:
    ---
    <p>ASA防火墙配置好ssh后，从另一个直连的路由器ssh登陆提示：No user specified nor available for SSH client</p>
<p>ASA IP 192.168.1.1 用户名admin</p>
<p>在路由器ssh登陆时添加参数 -l 指定用户名：</p>
<p>R# ssh -l admin 192.168.1.1</p>
    