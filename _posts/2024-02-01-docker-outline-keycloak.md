---
layout: post
title: docker部署基于keycloak服务认证的outline
keywords: outline, docker, keycloak
description: docker部署基于keycloak服务认证的outline
categories: outline
---
之前一篇博文介绍到通过outline的部署，全程使用github上[这个](https://github.com/vicalloy/outline-docker-compose)脚本实现，部署过程自动化程度高。但OIDC服务不支持OTP，同时没有会话超时于是决定更换OIDC服务，在原项目上修改比较麻烦本博文介绍如何单独部署keycloak OIDC服务器和outline

部署过程分二步
* 部署keycloak OIDC服务器
* 部署outline

# 一、keycloak OIDC部署
1.创建keycloak文件夹，新建文件docker-compose.yaml 
```yaml
services:
  keycloak-db:
      container_name: keycloak-db
      image: postgres:15
      restart: always
      volumes:
        - ./data/keycloak-db/:/var/lib/postgresql/data
        - /etc/localtime:/etc/localtime:ro
      environment:
        POSTGRES_DB: keycloak
        POSTGRES_USER: keycloak
        POSTGRES_PASSWORD: 123456.com
      healthcheck:
        test: [ "CMD", "pg_isready", "-q", "-d", "keycloak", "-U", "keycloak" ]
        interval: 10s
        timeout: 5s
        retries: 3
        start_period: 60s
    #   ports:
        # - 5432:5432
      networks:
        - keycloak-nw

  keycloak:
      container_name: keycloak
      image: quay.io/keycloak/keycloak:latest
      restart: always
      environment:
        KC_DB: postgres
        KC_DB_URL: jdbc:postgresql://keycloak-db:5432/keycloak
        KC_DB_USER: keycloak
        KC_DB_SCHEMA: public
        KC_DB_PASSWORD: 123456.com
        KEYCLOAK_ADMIN: ID404
        KEYCLOAK_ADMIN_PASSWORD: 123456.com
      volumes:
        - /etc/localtime:/etc/localtime:ro
      ports:
        - 8080:8080
      depends_on:
        - keycloak-db
      networks:
        - reverseproxy-nw
        - keycloak-nw
      command: start  --proxy edge  --hostname=wiki.test.cn --hostname-port=4430 --hostname-strict-backchannel=true --hostname-admin-url=http://wiki.test.cn:4430/


networks:
    keycloak-nw:
    reverseproxy-nw:
        external: true
```
替换docker-compose.yaml文件中域名www.test.cn自己的域名

执行`docker network create reverseproxy-nw` 创建docker 网络

2.执行`docker compose up -d `运行keycloak

3.登录`http://www.test.cn:4430/` ,进入administratoration Console
![admin console](/images/blog/202402/admin-console.png)

## 1.1 添加client

![add client](/images/blog/202402/create-client.png)

![create client1](/images/blog/202402/create-client1.png)

![create client2](/images/blog/202402/create-client2.png)

![create client3](/images/blog/202402/creata-client3.png)

注意Valid redirect URIs 内容为`http://www.test.cn/auth/oidc.callback` 也可以写成`http://www.test.cn/*`

保存后进入outline 的Credentials 查看并记录下client Secret

![client secret](/images/blog/202402/outline-credentials.png)

## 1.2 添加用户
进入 Users-->Add user
注意需要填写好邮箱，否则outline无法登录。若需要二步验证可在Required user actions选择OTP
![add users](/images/blog/202402/add-user.png)

给用户添加密码
![set-password](/images/blog/202402/set-password.png)


# 2、outline部署
## 配置修改
* 创建outline文件夹，新建.env文件。 文件内容如下
```conf
#secrets/passwords
#Gen by 'openssl rand -hex 32`
SECRET_KEY=e65a91c3e21ab302ba213b642cafff79686ead5ecc7bf57a0301a0c811df94cd
UTILS_SECRET=738c832f466050226896f78b6c3579722218866c458ba6c7eaad2f36ec59abc5


MINIO_ROOT_PASSWORD=
POSTGRES_PASSWORD=

#domains

URL=http://wiki.test.cn
CDN_URL=http://wiki.test.cn

ENABLE_UPDATES=true
DEBUG=cache,presenters,events,emails,mailer,utils,multiplayer,server,services
AWS_S3_ACL=private

LANGUAGE_CODE=en-us
TIME_ZONE=Asia/Shanghai

# See translate.getoutline.com for a list of available language codes and their
# percentage translated.
DEFAULT_LANGUAGE=zh_CN

# Specify what storage system to use. Possible value is one of "s3" or "local".
# For "local", the avatar images and document attachments will be saved on local disk.
FILE_STORAGE=local

# If "local" is configured for FILE_STORAGE above, then this sets the parent directory under
# which all attachments/images go. Make sure that the process has permissions to create
# this path and also to write files to it.
FILE_STORAGE_LOCAL_ROOT_DIR=/var/lib/outline/data

# Maximum allowed size for the uploaded attachment.
FILE_STORAGE_UPLOAD_MAX_SIZE=26214400

PGSSLMODE=disable
#ALLOWED_DOMAINS=
FORCE_HTTPS=false
#oidc information
OIDC_CLIENT_ID=outline
OIDC_CLIENT_SECRET=D8t8KFH6K127GCPW02PvAlbPc2Fo5zp4
OIDC_AUTH_URI=http://wiki.test.cn:4430/realms/master/protocol/openid-connect/auth
OIDC_TOKEN_URI=http://wiki.test.cn:4430/realms/master/protocol/openid-connect/token
OIDC_USERINFO_URI=http://wiki.test.cn:4430/realms/master/protocol/openid-connect/userinfo
OIDC_DISPLAY_NAME=OpenID
OIDC_USERNAME_CLAIM=preferred_username
OIDC_SCOPES=openid profile email
#smtp information
SMTP_HOST=
SMTP_PORT=
SMTP_FROM_EMAIL=
SMTP_REPLY_EMAIL=
SMTP_SECURE=
```

替换www.test.cn域名为你自己的域名
* 修改.env文件中OIDC信息
  
  ![client-secret](/images/blog/202402/oidc-client-secret.png)

  替换OIDC_CLIENT_SECRET 为1.1中生成的client Secret

## 启动outline
创建docker-compose.yaml文件，文件内容如下：
```yaml
services:
  outline_redis:
    image: redis
    restart: always
    container_name: outline_redis
    networks:
      - outline-internal

  outline_postgres:
    image: postgres:15
    restart: always
    container_name: outline_postgres
    security_opt:
      - label:disable
    environment:
      - POSTGRES_PASSWORD=0da68aed6bd2f275749d8750
      - POSTGRES_USER=outline
      - POSTGRES_DB=outline
    networks:
      - outline-internal
    volumes:
      - ./data/outline/db:/var/lib/postgresql/data
      - /etc/localtime:/etc/localtime:ro

  outline:
    image: outlinewiki/outline:latest
    user: root
    restart: always
    container_name: outline
    command: sh -c "yarn start --env=production-ssl-disabled"
    environment:
      - DATABASE_URL=postgres://outline:0da68aed6bd2f275749d8750@outline_postgres:5432/outline
      - DATABASE_URL_TEST=postgres://outline:0da68aed6bd2f275749d8750@outline_postgres:5432/outline-test
      - REDIS_URL=redis://outline_redis:6379
    depends_on:
      - outline_postgres
      - outline_redis
    volumes:
      - ./data/outline/file:/var/lib/outline/data
      - /etc/localtime:/etc/localtime:ro
    env_file:
      - .env
    ports:
      - 3000:3000
    networks:
      - outline-internal
      - reverseproxy-nw
networks:
  outline-internal:
  reverseproxy-nw:
    external: true
```

执行 docker compose up -d 启动outline

# 三、遇到的问题
## 3.1用户修改密码
用户可自行可登录 [http://www.test.cn:4430/admin/outline/console](http://www.test.cn:4430/admin/outline/console) 修改

## 3.2 用户管理界面点击Manage account 时提示failed to initialize keycloak
分别在master、outline中 client\account-console  选项web origin输入+

![failed1](/images/blog/202402/failed1.png)

![failed2](/images/blog/202402/failed2.png)

参考：
[链接1](https://keycloak.discourse.group/t/the-account-console-presents-failed-to-initialize-keycloak-init-request-returns-403/8918)
[链接2](https://keycloak.discourse.group/t/keycloak-17-failed-to-initialize-keycloak/13980/2)


## 3.3 退出outline及会话超时
当退出outline后，重新登录不需要重新输入账号密码，这是由于退出outline退出信息没有同步至keycloak。用户信息在keycloak还是登录状态的所以不需要重新认证。这似乎是一个bug，在outline的Issuse两年前已经有人提及了但一直没有处理好，在Issuse中有人提及其实outline提供OIDC_LOGIN_LOGOUT_URI信息给OIDC服务器既可，但outline开发从员似乎一直没有处理。

目前规避的方式是在keycloak中设置session timeout

在keylocak管理控制台--realm setting--token--sso session idle 设置超时时间

参考 [链接](https://github.com/outline/outline/discussions/3672)