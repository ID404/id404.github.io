---
layout: post
title: freeipa docker compose部署
keywords: freeipa, docker
description: freeipa docker compose部署
categories: linux
---
docker compose文件

    version: "3.3"
    services:
      freeipa:
        image: freeipa/freeipa-server:centos-7
        container_name: freeipa
        domainname: freeipa.default.cn
        container_name: freeipa_idc
        networks:
          my_macvlan_net:
            ipv4_address: 10.0.0.10
        ports:
          - "80:80/tcp"
          - "443:443/tcp"
          # DNS
          - "53:53/tcp"
          - "53:53/udp"
          # LDAP(S)
          - "389:389/tcp"
          - "636:636/tcp"
          # Kerberos
          - "88:88/tcp"
          - "88:88/udp"
          - "464:464/tcp"
          - "464:464/udp"
          # NTP
          - "123:123/udp"
        dns:
          - 114.114.114.114
        tty: true
        stdin_open: true
        environment:
          IPA_SERVER_HOSTNAME: freeipa.deafult.cn
          #IPA_SERVER_IP: 10.0.4.52
          TZ: "Asia/Shanghai"
        command:
          - --domain=freeipa.default.cn
          - --realm=freeipa.default.cn
          - --admin-password=123456.com  #freeapi的admin管理员账号
          - --http-pin=123456
          - --dirsrv-pin=123456
          - --ds-password=12345678
          - --no-dnssec-validation
          - --no-host-dns
          - --setup-dns
          - --auto-forwarders
          - --allow-zone-overlap
          - --unattended  # 自动无人工干预安装
        cap_add:
          - SYS_TIME
          - NET_ADMIN
        restart: unless-stopped
        volumes:
          - /etc/localtime:/etc/localtime:ro
          - /sys/fs/cgroup:/sys/fs/cgroup:ro
          - /root/freeipa/data/free-ipa/data:/data
          - /root/freeipa/data/free-ipa/logs:/var/logs
        sysctls:
          - net.ipv6.conf.all.disable_ipv6=0
          - net.ipv6.conf.lo.disable_ipv6=0
        security_opt:
          - "seccomp:unconfined"
        labels:
          - idc-freeipa
    #    extra_hosts:
    #      - "xxxx.xxxx.com:10.0.4.52 "

    networks:
        my_macvlan_net:
          driver: macvlan
          driver_opts:
            parent: ens192
          ipam:
            driver: default
            config:
              - subnet: 10.0.0.0/24
                gateway: 10.0.0.254


注意事项：

freeipa需要使用域名访问不能使用IP，需要将域名freeipa.default.cn指向对应的IP

443端口不能修改，freeipa默认使用443端口 若映射其它端口会自动跳转回443端口 目前暂无修改选项

若重新部署，需删除挂载目录data下的文件
    
