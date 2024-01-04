---
    title: macOS 通过RouterOS VM和strongswan 部署 site to site IPSec VPN
    date: 2022-02-15 14:21:00
    updated: 2022-02-28 20:48:00
    abbrlink: 15877921
    tags:
    categories:
    ---
    <h1>&nbsp;</h1>
<p>由于需要远程接入客户的网络进行维护，但客户的出口设备没有sslvpn授权，无法通过sslvpn接入至客户网络。除了sslvpn外，还有其它方式可以接入客户网络进行维护：</p>
<p>向日葵、teamviewer这种远程桌面方式就<a href="https://www.cnblogs.com/id404/" target="_blank">不说了</a></p>
<p>最开始想到的方式是在出口网关做端口映射，将需要维护的资源映射出来。</p>
<p>　　优点就是方便，在任何可以上网的地方都可以访问，不需要任何的拨号客户端。</p>
<p>　　缺点就是不安全，公网任何无关人员都可以访问;如果维护设备的数量特别多时，需要映射大量的端口，增加出口设备配置量、出口设备维护难度增加。</p>
<p>&nbsp;</p>
<p>对于注重安全角度来说，端口映射方式确实不适合。</p>
<p>&nbsp; &nbsp; &nbsp; 远程维护要整个网段打通的除了sslvpn 当然就是site to site IPSec VPN了。由于平时都是在公司维护比较多，所以就直接在公司出口设备和客户设备对接做了site to site 的IPSec VPN了。</p>
<p>这时需要说一点的是，由于都是我自己一个人做维护，但site to site 的IPSec VPN是打通的整个网段。若只需要我自己的电脑能访问对端网段，可以通过以下几个方式做限制：</p>
<p>　　1、安全策略限制 指定IP才可访问对端网段，这是最简单和最容易想的到。</p>
<p>　　2、做策略路由，只有指定IP访问对端网段的流量才引入至VPN 隧道</p>
<p>　　3、做site to site IPSec VPN时 proxy ID指定的本端网段是这边内网不存在的IP(例如172.20.10.4/32)，将需要访问对端的IP做源NAT，目的地为VPN对端网段，将流量源地址转换成172.20.10.4</p>
<p><img src="/images/blog/725676-20220214222257415-459670434.png" alt="" width="498" height="489" /></p>
<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</p>
<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 这样就基本满足要求了。</p>
<p>&nbsp;&nbsp;</p>
<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;但后来发现一个问题，如果在公司正常使用当然是没有问题的，一旦外出时就无法使用公司的site to site IPSec VPN 了。如果要沿用IPSec VPN的话这个问题好解决，macbook上装个虚拟机做IPSec VPN就可以了。刚开始用的是Juniper Vsrx，但后面觉得VSRX启动时间太慢了，改成mikrotik 的RouterOS。</p>
<p>　　RouterOS上主要用到两张网卡，网卡1做WAN口，配置为桥接模式并且自动检测。这样不论我的macbook到不同的网段获取到不同的IPRouterOS都可以自动识别到并获取到IP上网。网卡2作为RouterOS的LAN口，做专有模式，仅供macbook和RouterOS通讯。具体通讯方式如下图。</p>
<p><img src="/images/blog/725676-20220214230902919-298495552.png" alt="" /></p>
<p>&nbsp;</p>
<p>RouterOS VM网卡1 配置</p>
<p><img src="/images/blog/725676-20220214230226477-1888859657.png" alt="" /></p>
<p>RouterOS VM网卡2配置</p>
<p><img src="/images/blog/725676-20220214230242191-1714264917.png" alt="" /></p>
<p>Macbook 桥接接口的IP为默认，安装完vmware后自动生成的</p>
<p><img src="/images/blog/725676-20220214230651354-7346284.png" alt="" /></p>
<p>&nbsp;</p>
<p>以下为RouterOS的配置</p>
<p>WAN口DHCP及LAN口IP地址</p>
<p><img src="/images/blog/725676-20220214231711198-1819083287.png" alt="" /></p>
<p><img src="/images/blog/725676-20220214231720017-1154314852.png" alt="" /></p>
<p>&nbsp;其它的就是IPSec VPN的配置了</p>
<p>需要注意一点的是由于RouterOS内网网段固定为192.168.210.0/24网段，如果和IPSec VPN对端网段存在冲突时，proxy ID可配置为其它不冲突的网段，在NAT处配置snat,将源为192.168.210.0/24 目的地址为VPN对端网网段的数据包转换为不冲突的网段即可</p>
<p>如：</p>
<p>&nbsp;</p>
<p><img src="/images/blog/725676-20220214232418478-864796292.png" alt="" /></p>
<p>此时192.168.210.0/24和对端网段是能正常通讯的，但在macbook上却无法ping通、telnet 、ssh或通过web访问。主要原因是macbook的路由表中没有前往对端网段的路由，数据包直接从无线网卡获取到的默认网关直接出去了。</p>
<p>macbook可以在终端里输入netstat -rn 查看当前的路由表</p>
<p><img src="/images/blog/725676-20220214232943781-636374686.png" alt="" /></p>
<p>要想正常访问对端网段，需要通过route add 命令添加路由，比如对端网段是192.168.3.0/24</p>
<p>则命令为&nbsp;&nbsp;sudo route add 192.168.3.0/24 192.168.210.124</p>
<p>如果要删除路由则通过命令 sudo route delete 192.168.3.0/24</p>
<p>至此，已可以通过RouterOS的VM正常访问对端网络了。</p>
<p>&nbsp;</p>
<p>------------------------------------------</p>
<p>RouterOS VM使用了很长一段时间，每次启动时间都觉得有点长。于是找到strongswan代为替代</p>
<p>macbook 安装strongswan只需要在终端界面执行命令即可：</p>
<p>　　brew install strongswan</p>
<p>&nbsp;</p>
<p>strongswan 需要配置两个文件</p>
<p>ipsec.secrets 文件，文件在/usr/local/etc/ 目录下，用于存放vpn的共享密钥</p>
<p>ipsec.conf 文件，文件在/usr/local/etc/ 目录下，用于存放vpn的配置信息</p>
<p>&nbsp;</p>
<p>假设VPN对端的公网IP为1.1.1.1 预共享密钥为123456，则ipsec.secrets文件的内容为：</p>
<div class="cnblogs_Highlighter">
<pre class="brush:bash;gutter:true;">1.1.1.1 : PSK 123456
</pre>
</div>
<p>&nbsp;</p>
<p>ipsec.conf文件的配置内容：</p>
<div class="cnblogs_Highlighter">
<pre class="brush:bash;gutter:true;"># ipsec.conf - strongSwan IPsec configuration file

# basic configuration

config setup
    # strictcrlpolicy=yes
    # uniqueids = no
conn %default
    authby=psk
    type=tunnel

conn sangfor
    ikelifetime=60m
    keylife=480m
    rekeymargin=3m
    keyingtries=0
    keyexchange=ikev1   #ike版本
    authby=secret
    left=%defaultroute
    leftid=ljc
    leftsubnet=172.20.10.2/32
    right=1.1.1.1
    rightid=1.1.1.1
    rightsubnet=10.10.10.0/24
    auto=add             #ignore/add/route/start
    type=tunnel
    ike=aes256-sha256-modp1024
    esp=aes256-sha256-modp1024
    aggressive=yes
</pre>
</div>
<p>&nbsp;我配置的是VPN隧道需要手动启动或禁用，需要需要自动连接的话需要将auto=add 改为auto=start</p>
<p>&nbsp;</p>
<p>配置完成后，通过命令启动strongswan</p>
<p>sudo ipsec start</p>
<p>&nbsp;</p>
<p>启用vpn隧道<br />sudo ipsec up sangfor &nbsp;</p>
<p>其中sangfor为配置文件中的隧道名称，可以根据实际修改</p>
<p>查看strongswan状态 ：sudo ipsec status</p>
<p><img src="/images/blog/725676-20220215140352528-1190170033.png" alt="" /></p>
<p>&nbsp;</p>
<p>若macbook 无线网卡获取到的网段为192.168.0.0/24 ，同时VPN配置的本端网段是192.168.0.0/24的话，strongswan VPN建立后就能正常访问对端网段了。</p>
<p>这里就有一个问题，macbook无线获取到的网段是不固定的，若每次无线网段变更后，需要修改strongswan和VPN对端的配置，这样就十分麻烦。</p>
<p>这时可以在macbook上做nat转换，假如对端网段是10.10.10.0/24，任何前往此网段的数据都转换为172.20.10.2/32这个IP，这样不论无线网段怎样改变，strongswan和vpn对端的配置信息都不需要更改</p>
<p>具体做法是执行以下命令：</p>
<p>echo "nat on en0 inet from any to 10.10.10.0/24 -&gt; 172.20.10.2" | sudo pfctl -v -ef -</p>
<p>命令执行后所有前往10.10.10.0/24的数据包都snat转换为 172.20.10.2</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>strongswan<a href="https://www.cnblogs.com/id404/" target="_blank">其它命令</a>：</p>
<p>禁用vpn隧道命令：sudo ipsec down sangfor</p>
<p>若修改过ipsec.conf文件需通过命令 sudo ipsec reload 重新加载配置文件</p>
<p>重启strongswan ：sudo ipsec restart&nbsp;</p>
<p>&nbsp;</p>
    