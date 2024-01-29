---
layout: post
title: ocserv 配置
keywords: ocserv
description: 记录一些ocserv容易踩坑的配置
categories: linux,ocserv
---

记录一些ocserv容易踩坑的配置

# 1、证书认证

```conf
#只启用证书认证
auth = "certificate"

#服务器ssl证书
server-cert = /opt/certs/server_cert/ssl-cert.pem
server-key = /opt/certs/server_cert/ssl-key.pem

#CA根证书
ca-cert = /opt/certs/ca_cert/ca-cert.pem

#证书用户识别
cert-user-oid = 2.5.4.3

#证书用户组识别，这个需要注释掉，否则证书认证不成功
#cert-group-oid = 2.5.4.11

#兼容思科anyconnect 客户端
cisco-client-compat = true
```

以上为只启用证书认证的配置，若优先用户为密码认证，备用证书认证，则
```conf
auth = "plain[passwd=/etc/ocserv/ocpasswd]"
enable-auth = "certificate"

#auth = "radius[config=/etc/ocserv/radiusclient.conf]"
#auth = "radius[config=/etc/radiusclient/radiusclient.conf,groupconfig=true]"
#auth = "radius [config=/etc/radcli/radiusclient.conf,groupconfig=false]"
#acct = "radius [config=/etc/radcli/radiusclient.conf,groupconfig=false]"
#acct = "radius [config=/etc/ocserv/radiusclient.conf]"
# Specify alternative authentication methods that are sufficient
# for authentication. That is, if set, any of the methods enabled
# will be sufficient to login.
#enable-auth = "gssapi"
#enable-auth = "gssapi[keytab=/etc/key.tab,require-local-user-map=true,tgt-freshness-time=900]"
```

## 1.2 证书生成
写了一个证书生成的脚本，将脚本保存至gen_cert文件,执行命令`bash gen_cert`运行

脚本默认检测当前目录下是否存在`ca_cert` `server_cert` `user_cert` 三个文件，不存在则创建

脚本执行后有如下提示，可根据提示选择

* 1、生成CA根证书
* 2、生成服务器SSL证书
* 3、生成用户证书
* 4、吊销用户证书 
```bash
1) Generate CA Certificate	4) Revoke User Certificate
2) Generate Server Certificate	5) Quit
3) Generate User Certificate
Please enter your choice:
```

以下为脚本的内容 ：


```bash
#!/bin/bash
function generate_ca() {
    # Generate a CA Private Key
    certtool --generate-privkey --rsa --bits 4096 --outfile ./ca_cert/ca-key.pem

    # Generate a CA Certificate
    cat > ca-temp.txt <<EOF
cn = "Root CA"
organization = "vpn.test.cn"
serial = 001
expiration_days = -1
ca
signing_key  
cert_signing_key  
crl_signing_key  
EOF

    certtool --generate-self-signed --load-privkey ./ca_cert/ca-key.pem --template ca-temp.txt --outfile ./ca_cert/ca-cert.pem
    rm ca-temp.txt
    exit 1
}

function generate_server_cert() {
    read -p "Enter Domain Name: " domain_name

    # Server Private Key
    certtool --generate-privkey --rsa --bits 4096  --outfile ./server_cert/$domain_name-key.pem

    # Server Certificate
    echo "organization = $domain_name" > server-temp.txt

    cat <<EOF >server-temp.txt
cn = $domain_name
organization = $domain_name
serial = 2
expiration_days = 360
signing_key
encryption_key 
tls_www_server
dns_name = $domain_name
EOF

    certtool --generate-certificate --hash SHA256 --load-privkey ./server_cert/$domain_name-key.pem --load-ca-certificate ./ca_cert/ca-cert.pem --load-ca-privkey ./ca_cert/ca-key.pem --template server-temp.txt --outfile ./server_cert/$domain_name-cert.pem
    rm server-temp.txt
    exit 1
}

function generate_user_cert() {
    read -p "Enter Username: " username
    read -p "Enter Group: " group

    # User Private Key
    certtool --generate-privkey --rsa --bits 4096 --outfile ./user_cert/$username-key.pem

    # User Certificate
    echo "cn = $username" > user-temp.txt
    #echo "uid = $username" >> user-temp.txt
    echo "organization = vpn.test.cn" >> user-temp.txt
    echo "unit = $group" >> user-temp.txt
    echo "signing_key" >> user-temp.txt
    echo "tls_www_client" >> user-temp.txt
    certtool --generate-certificate --hash SHA256 --load-privkey ./user_cert/$username-key.pem --load-ca-certificate ./ca_cert/ca-cert.pem --load-ca-privkey ./ca_cert/ca-key.pem --template user-temp.txt --outfile ./user_cert/$username-cert.pem
    rm user-temp.txt

    # User Certificate in PKCS#12 Format
    openssl pkcs12 -export -in ./user_cert/$username-cert.pem -inkey ./user_cert/$username-key.pem -certfile ./ca_cert/ca-cert.pem -out ./user_cert/$username.p12 -name "$username User Certificate"

    #certtool --to-p12 --load-privkey ./user_cert/$username-key.pem --load-certificate ./user_cert/$username-cert.pem --pkcs-cipher 3des-pkcs12 --outfile ./user_cert/$username-ios.p12 --outder

    exit 1
}

function revoke_user_cert() {
    read -p "Enter Username to Revoke: " username

    # Revoke Certificate
    echo "crl_next_update = 365" > revoke-temp.txt
    echo "crl_number = 1" >> revoke-temp.txt
    certtool --generate-crl --hash SHA256 --load-ca-privkey ./ca_cert/ca-key.pem --load-ca-certificate ./ca_cert/ca-cert.pem --load-certificate ./user_cert/$username-cert.pem --template revoke-temp.txt --outfile crl.pem
    rm revoke-temp.txt
    exit 1
}

dirs=("ca_cert" "server_cert" "user_cert")

# 遍历目录名
for dir in "${dirs[@]}"
do
    # 如果目录不存在，则创建它
    if [[ ! -d $dir ]]; then
        echo "Directory $dir does not exist. Creating now..."
        mkdir $dir
        echo "Directory $dir created."
    else
        echo "Directory $dir exists."
    fi
done


PS3='Please enter your choice: '

options=("Generate CA Certificate" "Generate Server Certificate" "Generate User Certificate" "Revoke User Certificate" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Generate CA Certificate")
            generate_ca
            ;;
        "Generate Server Certificate")
            generate_server_cert
            ;;
        "Generate User Certificate")
            generate_user_cert
            ;;
        "Revoke User Certificate")
            revoke_user_cert
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

```


# 2、其它配置
## 2.1 记录用户登录注销日志
配置文件修改：
```conf
connect-script = /etc/ocserv/connect-script
disconnect-script = /etc/ocserv/connect-script
```
connect-script 文件内容
```bash
#!/bin/bash

export LOGFILE=/etc/ocserv/login.log

#echo $USERNAME : $REASON : $DEVICE
case "$REASON" in
  connect)
echo `date` $USERNAME "connected" >> $LOGFILE
echo `date` $REASON $USERNAME $DEVICE $IP_LOCAL $IP_REMOTE $IP_REAL >> $LOGFILE
    ;;
  disconnect)
echo `date` $USERNAME "disconnected" >> $LOGFILE
    ;;
esac
exit 0
```

⚠️ 一定要通过`chmod +x connect-script`给这个配置文件可执行权限，否则脚本无法执行同时用户登录会报错

用户登录、注销日志记录在 `/etc/ocserv/login.log`

## 2.2 启用occtl命令行工具
修改配置文件
```conf
use-occtl = true
```

具体的命令可执行occtl ?查看

```
disconnect user [NAME]	Disconnect the specified user
disconnect id [ID]	    Disconnect the specified ID
     unban ip [IP]	    Unban the specified IP
           reload       Reloads the server configuration
      show status	    Prints the status and statistics of the server
       show users       Prints the connected users
     show ip bans  	    Prints the banned IP addresses
 show ip ban points	    Prints all the known IP addresses which have points
     show iroutes     	Prints the routes provided by users of the server
 show sessions all    	Prints all the session IDs
 show sessions valid  	Prints all the valid for reconnection sessions
 show session [SID]	    Prints information on the specified session
    show user [NAME]	Prints information on the specified user
      show id [ID]	    Prints information on the specified ID
      show events	    Provides information about connecting users
         stop now	    Terminates the server
            reset	    Resets the screen and terminal
         help or ?	    Prints this help
             exit     	Exits this application
```


## 2.3 密码登录的用户按组别划分权限
修改配置文件
```conf
auth = "plain[passwd=/etc/ocserv/ocpasswd]"
#auth = "certificate"
#auth = "radius[config=/etc/ocserv/radiusclient.conf]"
#auth = "radius[config=/etc/radiusclient/radiusclient.conf,groupconfig=true]"
#auth = "radius [config=/etc/radcli/radiusclient.conf,groupconfig=false]"
#acct = "radius [config=/etc/radcli/radiusclient.conf,groupconfig=false]"
#acct = "radius [config=/etc/ocserv/radiusclient.conf]"
#enable-auth = "certificate"
#enable-auth = "gssapi"
#enable-auth = "gssapi[keytab=/etc/key.tab,require-local-user-map=true,tgt-freshness-time=900]"

config-per-group = /etc/ocserv/group/
default-group-config = /etc/ocserv/group/users
default-select-group = users
auto-select-group = false
```

在用户密码保存文件`/etc/ocserv/ocpasswd`中配置用户组,用户组配置在用户名和密码之间，中间用:分隔.组名可以自定义，和/etc/ocserv/group/里面的文件对应即可

```
user1:group1:$5$124fVO/ctAyf.azb$ZR4GUQNtScnL3lPdSJqVUaAKNGb7
user2:group2:$5$bINdojFGGgzv0G84$YkPB5P.fZIZnH1uWr7IjapI4A
user3:group3:$5$WHVrqmSibrwtIayE$6tM9DNm9fIfzrVYqi4.nPBBO7
user4:$5$WHVrqmSibrwtIayE$6tM9DNm9fIfzrVYqi4.nPBBO7
```
user4没有分配至用户组，则默认按ocserv.conf配置文件里的路由

另外划分了三个组，分别为
* group1
* group2
* group3

需要分别为这三个组赋予用户可访问的网络资源
分别新建三个文件

 `/etc/ocserv/group/group1`

 `/etc/ocserv/group/group2`
 
 `/etc/ocserv/group/group3`

group1 文件内容为:
```conf
route = 10.0.1.0/255.255.255.0
route = 10.0.0.0/255.255.255.0
```
则属于group1的用户可以访问10.0.0.0/24 和10.0.1.0/24的内容


group2 文件内空如下：
```conf
dns=223.5.5.5
```
则属于group2的用户，所有流量都会转发至ocserv服务器

group3的文件内容如下
```conf
route = 10.0.0.2/255.255.255.255
route = 10.0.0.1/255.255.255.255
restrict-user-to-ports = "tcp(8080), tcp(80), udp(53), icmp()"
```
则属于group3组的用户只能访问10.0.0.1、10.0.0.2两个IP的tcp8080、tcp80、udp53端口和icmp
