---
    title: Upgrade bank is empty or corrupted for FPC 0, please do standard upgrade sequence 错误解决&juniper 交换机系统升级
    date: 2016-01-07 20:47:00
    updated: 2016-01-07 20:53:00
    abbrlink: 5111148
    tags:
    categories:
    ---
    <p><span lang="zh-CN">解决juniper交换机&nbsp;<span lang="en-US">show system alarm <span lang="zh-CN">报<span lang="en-US">"<span lang="zh-CN">Upgrade bank is empty or corrupted for FPC 0, please do standard upgrade sequence<span lang="en-US">"<span lang="zh-CN">错误</span></span></span></span></span></span></span></p>
<p>&nbsp;</p>
<p lang="en-US">&nbsp;</p>
<p>解决思路来自 &lt;<a href="http://forums.juniper.net/t5/Junos/Upgrade-bank-is-empty-or-corrupted-for-FPC-0-please-do-standard/m-p/153884#M6404">http://forums.juniper.net/t5/Junos/Upgrade-bank-is-empty-or-corrupted-for-FPC-0-please-do-standard/m-p/153884#M6404</a>&gt;</p>
<p>同样可以用于系统升级</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>保证电脑和交换机可能通讯</p>
<p><span lang="en-US"># "<span lang="zh-CN">配置<span lang="en-US">MGT<span lang="zh-CN">管理口<span lang="en-US">IP<span lang="zh-CN">地址<span lang="en-US">"</span></span></span></span></span></span></span></p>
<p lang="en-US">[edit]</p>
<p lang="en-US">lab@EX4200-1# set interfaces me0 unit 0 family inet address&nbsp; 192.168.1.1/24</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p><span lang="zh-CN">打开<span lang="en-US">ftp<span lang="zh-CN">服务</span></span></span></p>
<p lang="en-US">lab@EX4200-1# edit system service</p>
<p lang="en-US">[edit system services]</p>
<p lang="en-US">lab@EX4200-1# set ftp</p>
<p lang="en-US">lab@EX4200-1# set ftp connection-limit 5&nbsp;</p>
<p lang="en-US">lab@EX4200-1# set ftp rate-limit 5</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p><span lang="zh-CN">新建一个非<span lang="en-US">root<span lang="zh-CN">用户</span></span></span></p>
<p lang="en-US">lab@EX4200-1# edit system login</p>
<p lang="en-US">[edit system login]</p>
<p><span lang="en-US">lab@EX4200-1#<span lang="en-US"> edit user zte&nbsp;&nbsp;&nbsp; #"<span lang="zh-CN">编辑<span lang="en-US">zte<span lang="zh-CN">用户属性，如果不存在<span lang="en-US">zte<span lang="zh-CN">用户系统会新建一个<span lang="en-US">"</span></span></span></span></span></span></span></span></p>
<p lang="en-US">[edit system login user zte]</p>
<p><span lang="en-US">lab@EX4200-1#<span lang="en-US"> set class super-user&nbsp; #"<span lang="zh-CN">设置<span lang="en-US">zte<span lang="zh-CN">为超级用户，<span lang="en-US">"</span></span></span></span></span></span></p>
<p><span lang="en-US">lab@EX4200-1#<span lang="en-US"> set full-name "<span lang="zh-CN">中兴通讯<span lang="en-US">"&nbsp;&nbsp; #"<span lang="zh-CN">设置用户全名，支持中文<span lang="en-US">"</span></span></span></span></span></span></p>
<p><span lang="en-US">lab@EX4200-1#<span lang="en-US"> set uid 101&nbsp;&nbsp; #"<span lang="zh-CN">设置用户<span lang="en-US">uid<span lang="zh-CN">，可以设置的范围是<span lang="en-US">(100..64000)<span lang="en-US"> <span lang="en-US">"</span></span></span></span></span></span></span></span></p>
<p><span lang="en-US">lab@EX4200-1#<span lang="en-US"> set authentication plain-text-password&nbsp;&nbsp; #"<span lang="zh-CN">明文方式设置密码<span lang="en-US">"</span></span></span></span></p>
<p lang="en-US">New password:</p>
<p lang="en-US">Retype new password:</p>
<p>&nbsp;</p>
<p><span lang="zh-CN">上传<span lang="en-US">OS<span lang="zh-CN">文件</span></span></span></p>
<p><span lang="zh-CN">打开<span lang="en-US">cmd<span lang="zh-CN">，用新建的用户登陆<span lang="en-US">ftp</span></span></span></span></p>
<p><span lang="zh-CN">传输模式改为<span lang="en-US">bin<span lang="zh-CN">二进制模式，直接输入bin即可，上传到<span lang="en-US">/var/tmp<span lang="zh-CN">目录</span></span></span></span></span></p>
<p><span lang="zh-CN">可以先将需要上传的文件复制到系统用户文件夹下，在<span lang="en-US">ftp<span lang="zh-CN">下直接<span lang="en-US">put+<span lang="zh-CN">文件名即可上传而不用输入要地路径</span></span></span></span></span></p>
<p><img src="/images/blog/725676-20160107204448918-1451574002.png" alt="" /></p>
<p lang="en-US">&nbsp;</p>
<p lang="en-US">&nbsp;</p>
<p>用新建的用户登陆交换机</p>
<p><span lang="zh-CN">安装<span lang="en-US">jloader</span></span></p>
<p lang="en-US">Test&gt;request system software add /var/tmp/jloader</p>
<p><span lang="zh-CN">更新<span lang="en-US">OS</span></span></p>
<p lang="en-US">Test&gt;request system software add /var/tmp/jinstall</p>
<p>重新启动</p>
<p lang="en-US">Test&gt;request system reboot</p>
    