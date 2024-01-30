---
layout: post
title: outline wiki 部署
keywords: outline, wiki
description: 私有化部署outline wiki系统
categories: linux
---

公司技术部门不同同事之间负责各自的客户，忙的时候经常需要帮其它同事处理客户的问题。此时新处理的同事并不熟悉客户的现状，口头或文档交接经常不全。于是萌生部署知识库系统的想法，用于在部门内容共享客户信息。

前期测试了大部分的开源或免费的wiki系统.outline、bookstack、mediawiki、dokuwiki、wiki.js、MrDoc这些基本都测试过，最后符合要求的基本就是bookstack、wiki.js、outline这三个。bookstack的样式不太好看，而且更像是管理图书而不是文档;wiki.js功能十分全，唯一不满意的就是编辑器无法直接粘贴图片，最后决定选用outline

outline的私有化部署比较麻烦,网上教程较旧，大部分教程都要求部署S3存储。outling新版本支持使用本地存储，可参考以下链接

[部署脚本](https://github.com/vicalloy/outline-docker-compose)

部署脚本基本可以做到开箱即用，只需要修改简单几个配置。遗憾的是脚本自带的账号认证OIDC服务器只支持账号密码，不支持OTP认证。

# 一、部署步骤
## 1.1 初始化配置
```bash
git clone https://github.com/vicalloy/outline-docker-compose.git
cd outline-docker-compose
cp scripts/config.sh.sample scripts/config.sh
```
编辑config.sh,修改以下信息：

```config
URL=http://wiki.test.cn:8888
HTTP_IP=192.200.0.1
HTTP_PORT_IP=8888
TIME_ZONE=Asia/Shanghai
```
其中

URL需要填写客户端真实的访问地址+端口，如域名需填写域名

HTTP信息为outline容器映射的外部IP和端口,配置映射至docker compose文件中的ports配置中

## 1.2 编辑安装
系统需提前安装好make、make-guile
```
make
make install
```

## 1.3 初始化账号信息

安装最后无报错的话要求输入管理员账号、密码、邮箱
输入完毕后完成安装

账号密码修改或账号增加可通过访问以下URL
http://wiki.test.cn:8888/uc/admin/auth/user/

# 二、配置修改
若需要修改映射的端口、IP、域名,可直接修改./script/config.sh文件，保存后执行命令重启docker 镜像
```bash
make
make restart
```


# 三、其它命令
可cat Makefile 查看详细，以下举几个例子
`make start`  启动outline所有docker镜像
`make stop`   停止outline所有docker镜像
`make restart`  重启outline所有docker镜像
`make clean` 清除所有通过脚本生成的配置文件
`make clean-data `⚠️ 清除所有数据
`make clean-docker` 清除docker容器
`make clean-conf` 清除配置文件

#  四、https改造
outline默认使用http访问，若需改造成https可使用以下三种方式：
* 方式一 nginx
* 方式二 长亭雷池WAF
* 方式三 nginx proxy manager
  
## 4.1 通过nginx改造为https

⚠️ 注意，此方式有问题，部署后无法编辑文档内容，暂未找到原因。

通过docker compose部署nginx容器，docker-compose.yaml文件如下：
```yaml
version: '3'
services:
  https_nginx:
    image: nginx
    container_name: nginx_https
    hostname: nginx
    volumes:
      - ./data/nginx.conf:/etc/nginx/nginx.conf
      - ./data/conf.d:/etc/nginx/conf.d
      - ./data/certs:/etc/nginx/certs
      - ./data/logs:/var/log/nginx
      - ./data/html:/usr/share/nginx/html
    ports:
      - 443:443/tcp
      - 80:80/tcp
    restart: always
```
将nginx的配置文件及证书目录映射出来

修改./data/conf.d/default.conf文件

其中 `server_name` 后面改为需要访问的域名
`proxy_pass`后面改为outline映射出来的url

```conf
server {
        listen 80;
        server_name  wiki.test.com;
        return 301 https://$host$request_uri;
    }
    server {
        listen       443 ssl;

        server_name  wiki.test.com;

        ssl_certificate /etc/nginx/certs/wiki.test.com_bundle.crt;
        ssl_certificate_key /etc/nginx/certs/wiki.test.com.key;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
        ssl_prefer_server_ciphers on;


        location / {
            proxy_pass http://192.200.0.1:8888;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            #root   /usr/share/nginx/html;
            #index  index.html index.htm;
        }
    }
```
## 4.2 通过长亭雷池WAF改造为https
使用长亭的雷池WAF主要是考虑在outline前端做一层安全防护同时又能改造成https

雷池WAF的详细文档可参考 [链接](https://waf-ce.chaitin.cn/docs/guide/install)

一条命令安装 雷池WAF
```bash
bash -c "$(curl -fsSLk https://waf-ce.chaitin.cn/release/latest/setup.sh)"
```
安装后访问https://IP:9443 访问控制台

通过长亭WAF改造HTTPS比较简单，新建站点的时候勾选SSL和添加域名对应的证书就可以了

![WAF](/images/blog/20240126-WAF.png)

我将linux主机的docker网络接口IP改为192.200.0.1，outline的http接口只暴露给192.200.0.1，长亭WAF上游直接填写映射出来的docker接口的端口，避免外部可以访问到http接口，现在从外部扫描这台服务器，只能扫描到https接口

## 4.3 通过nginx proxy manager改造为https
略

# 五、遇到的问题
## 5.1 图片upload failed
在编辑器粘贴图片提示upload failed

* 处理方式一
  
  进入outline目录,修改upload文件夹权限
   ```bash
    mkdir ./data/outline/uploads
    chown 1001:65533 ./data/outline/uploads
    chmod 700 ./data/outline/uploads
   ```
* 处理方式二 
   
  修改docker compose 文件，在wk-outline:增加一行
      user: 0:0 // add this line
      restart: always

## 5.2 新增加的账号无法登录
账号需要添加邮箱，如果邮箱的域名和管理员域名不一至，需要在script/conf.sh中将`ALLOWED_DOMAINS=`添加对应的域名
然后执行
```bash
make
make restart
```

## 5.3 忘记重置密码
* 方式一：将账号删除后重新添加
		
* 方式二：修改./data/uc/db/db.sqlite3 
  
   确保已经安装sqlite3命令行工具，
   ```bash
   sqlite3 db.sqlite3   
   .tables
   select * from auth_user;
   UPDATE auth_user
   SET password='pbkdf2_sha256$150000$cJFz2adCPeYA$nx0Jq2rqgnsqARE/HhJmym8vgyk+xGLzO9R0/f65hBY='
   WHERE username='user1';
   .quit
   ```
	此时用户user1的密码修改为123456.com

## 5.4 会话超时问题
当退出outline后，重新打开wiki网页登录会直接登录成功，不需要输入账号密码。这是由于提供账号密码验证的OIDC服务登录状态并没有退出，要彻底退出的话需要同时在outline和OIDC(http://wiki.test.com/uc/admin)中退出才行。测试发现OIDC服务账号状态没有会话超时，这个暂时无解，除非更换OIDC服务。

# 六、备份
将/wiki目录下的所有数据打包并压缩放到/backup目录下，并删除大于14天的备份，同时将备份文件同步至NAS服务器



```bash
#!/bin/bash
echo "----------------------------"
# 设置要ping的IP地址

backup_time=`date +%Y%m%d%H%M`
IP_A="10.0.0.1"

echo "开始执行脚本 $(date +%Y%m%d%H%M)"


# 定义备份的源目录和目标路径
SOURCE_DIR="/wiki"
TARGET_DIR="/backup/wiki-backup-$backup_time.tar.gz"

# 打包并压缩
tar -czvf $TARGET_DIR $SOURCE_DIR

# 输出结果
echo "Backup $SOURCE_DIR to $TARGET_DIR completed!"

echo "删除大于14天的备份"
find /backup/ -type f -mtime +14 -delete


# 检查IP地址A是否可以ping通
ping -c 1 $IP_A > /dev/null
if [ $? -eq 0 ]; then
  echo "NAS可以ping通"
else
  echo "NAS无法ping通,退出程序"
  exit 1
fi


# 如果两个IP地址都可以ping通  执行下一步操作
echo "两个IP地址都可以ping通，开始检查备份目录挂载"

mount -a
sleep 10

# 检查/backup目录是否存在
if [ ! -d "/mnt/backup-wiki" ]; then
  echo "/backup目录不存在,退出程序"
  exit 1
fi

# 检查/backup目录是否为空
if [ -z "$(ls -A /mnt/backup-wiki)" ]; then
  echo "/backup目录为空,退出程序"
  exit 1
fi

# 检查/backup目录是否为挂载点
if ! mountpoint -q /mnt/backup-wiki; then
  echo "/backup目录不是挂载点,退出程序"
  exit 1
fi

echo "/backup目录已正确挂载,开始同步备份"


rsync -avz --ignore-existing   --no-owner --no-perms --no-group --include 'wiki*'  /backup  /mnt/backup-wiki/



echo "备份完成"

echo "删除大于14天的备份"
find /mnt/backup-wiki/ -type f -mtime +14 -delete


#卸载备份目录
umount /mnt/backup-wiki

echo "备份操作完成 $(date +%Y%m%d%H%M)"
echo " "
```

