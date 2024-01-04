---
layout: post
title: freeipa docker compose部署
keywords: freeipa, docker
description: freeipa docker compose部署
categories: linux
---
<p>docker compose文件</p>
<div class="cnblogs_code">
<pre>version: <span style="color: #800000;">"</span><span style="color: #800000;">3.3</span><span style="color: #800000;">"</span><span style="color: #000000;">
services:
  freeipa:
    image: freeipa</span>/freeipa-server:centos-7<span style="color: #000000;">
    container_name: freeipa
    domainname: freeipa.default</span><span style="color: #000000;">.cn
    container_name: freeipa_idc
    networks:
      my_macvlan_net:
        ipv4_address: </span>10.0.0.10<span style="color: #000000;">
    ports:
      </span>- <span style="color: #800000;">"</span><span style="color: #800000;">80:80/tcp</span><span style="color: #800000;">"</span>
      - <span style="color: #800000;">"</span><span style="color: #800000;">443:443/tcp</span><span style="color: #800000;">"</span>
      <span style="color: #008000;">#</span><span style="color: #008000;"> DNS</span>
      - <span style="color: #800000;">"</span><span style="color: #800000;">53:53/tcp</span><span style="color: #800000;">"</span>
      - <span style="color: #800000;">"</span><span style="color: #800000;">53:53/udp</span><span style="color: #800000;">"</span>
      <span style="color: #008000;">#</span><span style="color: #008000;"> LDAP(S)</span>
      - <span style="color: #800000;">"</span><span style="color: #800000;">389:389/tcp</span><span style="color: #800000;">"</span>
      - <span style="color: #800000;">"</span><span style="color: #800000;">636:636/tcp</span><span style="color: #800000;">"</span>
      <span style="color: #008000;">#</span><span style="color: #008000;"> Kerberos</span>
      - <span style="color: #800000;">"</span><span style="color: #800000;">88:88/tcp</span><span style="color: #800000;">"</span>
      - <span style="color: #800000;">"</span><span style="color: #800000;">88:88/udp</span><span style="color: #800000;">"</span>
      - <span style="color: #800000;">"</span><span style="color: #800000;">464:464/tcp</span><span style="color: #800000;">"</span>
      - <span style="color: #800000;">"</span><span style="color: #800000;">464:464/udp</span><span style="color: #800000;">"</span>
      <span style="color: #008000;">#</span><span style="color: #008000;"> NTP</span>
      - <span style="color: #800000;">"</span><span style="color: #800000;">123:123/udp</span><span style="color: #800000;">"</span><span style="color: #000000;">
    dns:
      </span>- 114.114.114.114<span style="color: #000000;">
    tty: true
    stdin_open: true
    environment:
      IPA_SERVER_HOSTNAME: freeipa.deafult</span><span style="color: #000000;">.cn
      </span><span style="color: #008000;">#</span><span style="color: #008000;">IPA_SERVER_IP: 10.0.4.52</span>
      TZ: <span style="color: #800000;">"</span><span style="color: #800000;">Asia/Shanghai</span><span style="color: #800000;">"</span><span style="color: #000000;">
    command:
      </span>- --domain=freeipa.default<span style="color: #000000;">.cn
      </span>- --realm=freeipa.default<span style="color: #000000;">.cn
      </span>- --admin-password=123456.com  <span style="color: #008000;">#</span><span style="color: #008000;">freeapi的admin管理员账号</span>
      - --http-pin=123456
      - --dirsrv-pin=123456
      - --ds-password=12345678
      - --no-dnssec-<span style="color: #000000;">validation
      </span>- --no-host-<span style="color: #000000;">dns
      </span>- --setup-<span style="color: #000000;">dns
      </span>- --auto-<span style="color: #000000;">forwarders
      </span>- --allow-zone-<span style="color: #000000;">overlap
      </span>- --unattended  <span style="color: #008000;">#</span><span style="color: #008000;"> 自动无人工干预安装</span>
<span style="color: #000000;">    cap_add:
      </span>-<span style="color: #000000;"> SYS_TIME
      </span>-<span style="color: #000000;"> NET_ADMIN
    restart: unless</span>-<span style="color: #000000;">stopped
    volumes:
      </span>- /etc/localtime:/etc/<span style="color: #000000;">localtime:ro
      </span>- /sys/fs/cgroup:/sys/fs/<span style="color: #000000;">cgroup:ro
      </span>- /root/freeipa/data/free-ipa/data:/<span style="color: #000000;">data
      </span>- /root/freeipa/data/free-ipa/logs:/var/<span style="color: #000000;">logs
    sysctls:
      </span>- net.ipv6.conf.all.disable_ipv6=<span style="color: #000000;">0
      </span>- net.ipv6.conf.lo.disable_ipv6=<span style="color: #000000;">0
    security_opt:
      </span>- <span style="color: #800000;">"</span><span style="color: #800000;">seccomp:unconfined</span><span style="color: #800000;">"</span><span style="color: #000000;">
    labels:
      </span>- idc-<span style="color: #000000;">freeipa
</span><span style="color: #008000;">#</span><span style="color: #008000;">    extra_hosts:</span><span style="color: #008000;">
#</span><span style="color: #008000;">      - "xxxx.xxxx.com:10.0.4.52 "</span>
<span style="color: #000000;">
networks:
    my_macvlan_net:
      driver: macvlan
      driver_opts:
        parent: ens192
      ipam:
        driver: default
        config:
          </span>- subnet: 10.0.0.0/24<span style="color: #000000;">
            gateway: </span>10.0.0.254</pre>
</div>
<p>&nbsp;</p>
<p>注意事项：</p>
<p>freeipa需要使用域名访问不能使用IP，需要将域名freeipa.default.cn指向对应的IP</p>
<p>443端口不能修改，freeipa默认使用443端口 若映射其它端口会自动跳转回443端口 目前暂无修改选项</p>
<p>若重新部署，需删除挂载目录data下的文件</p>
<p>&nbsp;</p>
    
