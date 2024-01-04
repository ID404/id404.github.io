---
    title: docker部署toughradius服务器
    date: 2022-03-14 14:27:00
    updated: 2022-03-14 14:34:00
    abbrlink: 16003934
    tags:
    categories:
    ---
    <p>#Author https://cnblogs.com/id404</p>
<p>由于需要测试基本radius认证的wifi和pppoe拨号需要先搭建radius服务器，找了一圈开源的radius服务器，toughradius感觉比较适合</p>
<p>toughradius主页&nbsp;<a title="https://www.toughradius.net" href="https://www.toughradius.net" target="_blank">https://www.toughradius.net</a>&nbsp; github地址：<a title="https://github.com/talkincode/ToughRADIUS" href="https://github.com/talkincode/ToughRADIUS" target="_blank">https://github.com/talkincode/ToughRADIUS</a></p>
<p>首先安装好docker和docker compose</p>
<p>&nbsp;</p>
<p>新建好tradiusdata目录</p>
<p>&nbsp;</p>
<p>在tradiusdata新建docker-compose.yml文件，文件内容如下：</p>
<div class="cnblogs_code">
<pre><span style="color: #000000;">version: "3"
services:
  mysql:
    image: mysql
    container_name: "mysql"
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: myroot
    command:
      --default-authentication-plugin=mysql_native_password
      --character-set-server=utf8mb4
      --collation-server=utf8mb4_unicode_ci
      --explicit_defaults_for_timestamp=true
      --lower_case_table_names=1
      --max_allowed_packet=128M;
    volumes:
      - /root/tradiusdata/mysql_data:/var/lib/mysql
      - /root/tradiusdata/vardata/mysql:/var/log/mysql
    ports:
      - 127.0.0.1:3306:3306
    expose:
      - 3306
    networks:
      tradius_network:

  toughradius:
    depends_on:
      - 'mysql'
    image: talkincode/toughradius:latest
    container_name: "toughradius"
    restart: always
    ports:
      - "1816:1816"
      - "1812:1812/udp"
      - "1813:1813/udp"
    expose:
      - 1816
      - 1812/udp
      - 1813/udp
    volumes:
      - /root/tradiusdata/vardata:/var/toughradius
    environment:
      - RADIUS_DBURL=jdbc:mysql://mysql:3306/toughradius?serverTimezone=Asia/Shanghai</span><span style="color: #ff0000;">&amp;useUnicode</span>=true<span style="color: #ff0000;">&amp;characterEncoding</span>=utf-8<span style="color: #ff0000;">&amp;allowMultiQueries</span><span style="color: #000000;">=true
      - RADIUS_DBUSER=root
      - RADIUS_DBPWD=myroot
      - RADIUS_DBPOOL=120
      - RADIUSD_AUTH_ENABLED=true
      - RADIUSD_ACCT_ENABLED=true
      - RADIUSD_AUTH_PORT=1812
      - RADIUSD_ACCT_PORT=1813
      - RADIUSD_DEBUG=true
      - RADIUSD_AUTH_POOL=32
      - RADIUSD_ACCT_POOL=32
      - RADIUSD_MAC_AUTH_EXPIRE=86400
      - RADIUSD_TICKET_DIR=/var/toughradius/data/ticket
      - RADIUSD_STAT_DIR=/var/toughradius/data/stat
      - RADIUSD_ALLOW_NAGATIVE=false
      - RADSEC_ENABLED=true
      - RADSEC_PORT=2083
      - RADSEC_POOL=32
      - PORTAL_ENABLED=true
      - PORTAL_LISTEN=50100
      - PORTAL_DEBUG=true
      - PORTAL_PAPCHAP=1
      - PORTAL_TIMEOUT=30
      - PORTAL_POOL=32
      - PORTAL_TEMPLATE_DIR=classpath:/portal/
    networks:
      tradius_network:

networks:
  tradius_network:<br /><br /></span></pre>
</div>
<p>这个文件主要是mysql和toughradius两个docker镜像的配置信息，其中需要注意的是</p>
<pre><span>MYSQL_ROOT_PASSWORD: myroot</span><br /><br />这一行中，myroot为mysql root的密码，等会需要用到<br /><br /><br />保存docker-compose.yml文件后，在tradiusdata目录下执行命令：<br />docker-compose up -d<br /><br />执行完毕后docker ps查看两个docker镜像的部署情况<br />两个容器正常运行后就可以打开http://ip:1816访问toughradius,但此时发现只可以打开登陆界面，输入密码后并不能登陆<br /><br /><br />下一步进入mysql容器导入初始数据：<br />docker exec -it mysql bash<br /><br />进入mysql窗口后进入mysql<br />mysql -u root -p<br /><br />输入密码后进入mysql<br /><br />首先创建数据库</pre>
<div class="cnblogs_code">
<pre><span style="color: #000000;">create database toughradius DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
FLUSH PRIVILEGES;<br />use </span>toughradius;</pre>
<pre></pre>
</div>
<p>&nbsp;</p>
<p>建表：</p>
<div class="cnblogs_code">
<pre><span style="color: #000000;">create table if not exists tr_bras
(
    id bigint auto_increment primary key,
    identifier varchar(128) null,
    name varchar(64) not null,
    ipaddr varchar(32) null,
    vendor_id varchar(32) not null,
    portal_vendor varchar(32) not null,
    secret varchar(64) not null,
    coa_port int not null,
    ac_port int not null,
    auth_limit int null,
    acct_limit int null,
    status enum('enabled', 'disabled') null,
    remark varchar(512) null,
    create_time datetime not null
);

create index ix_tr_bras_identifier on tr_bras (identifier);

create index ix_tr_bras_ipaddr on tr_bras (ipaddr);

create table if not exists tr_config
(
    id bigint auto_increment primary key,
    type varchar(32) not null,
    name varchar(128) not null,
    value varchar(255) null,
    remark varchar(255) null
);

create table if not exists tr_subscribe
(
    id bigint auto_increment primary key,
    node_id bigint default 0 not null,
    subscriber varchar(32) null,
    realname varchar(32) null,
    password varchar(128) not null,
    domain varchar(128) null,
    addr_pool varchar(128) null,
    policy varchar(512) null,
    is_online int null,
    active_num int null,
    bind_mac tinyint(1) null,
    bind_vlan tinyint(1) null,
    ip_addr varchar(32) null,
    mac_addr varchar(32) null,
    in_vlan int null,
    out_vlan int null,
    up_rate bigint null,
    down_rate bigint null,
    up_peak_rate bigint null,
    down_peak_rate bigint null,
    up_rate_code varchar(32) null,
    down_rate_code varchar(32) null,
    status enum('enabled', 'disabled') null,
    remark varchar(512) null,
    begin_time datetime not null,
    expire_time datetime not null,
    create_time datetime not null,
    update_time datetime null
);

create index ix_tr_subscribe_create_time
    on tr_subscribe (create_time);

create index ix_tr_subscribe_expire_time
    on tr_subscribe (expire_time);

create index ix_tr_subscribe_status
    on tr_subscribe (status);

create index ix_tr_subscribe_subscriber
    on tr_subscribe (subscriber);

create index ix_tr_subscribe_update_time
    on tr_subscribe (update_time);</span></pre>
</div>
<p>导入数据</p>
<div class="cnblogs_code">
<pre><span style="color: #000000;">INSERT INTO toughradius.tr_bras
(identifier, name, ipaddr, vendor_id, portal_vendor,secret, coa_port,ac_port, auth_limit, acct_limit, STATUS, remark, create_time)
VALUES ('radius-tester', 'radius-tester', '127.0.0.1', '14988',"cmccv1", 'secret', 3799,2000, 1000, 1000, NULL, '0', '2019-03-01 14:07:46');

INSERT INTO toughradius.tr_subscribe
(node_id,  subscriber, realname, password, domain, addr_pool, policy, is_online, active_num,
 bind_mac, bind_vlan, ip_addr, mac_addr, in_vlan, out_vlan, up_rate, down_rate, up_peak_rate, 
 down_peak_rate, up_rate_code,down_rate_code, status, remark, begin_time, expire_time, create_time, update_time)
VALUES (0, 'test01', '', '888888',  null, null, null, null, 10, 0, 0, '', '', 0, 0, 10.000, 10.000, 100.000, 100.000,
        '10', '10', 'enabled', '', '2019-03-01 14:13:02', '2019-03-01 14:13:00', '2019-03-01 14:12:59', '2019-03-01 14:12:56');</span></pre>
</div>
<p>导入完毕即可登陆toughradius</p>
<p>通过浏览器打开 http://ip:1816</p>
<p>用户名admin</p>
<p><img src="/images/blog/725676-20220314143406895-61163581.png" alt="" /></p>
<p>&nbsp;</p>
    