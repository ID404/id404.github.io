---
    title: 解决 WordPress“正在执行例行维护，请一分钟后回来”[转]
    date: 2014-02-07 16:47:00
    updated: 2015-03-02 23:00:00
    abbrlink: 4306901
    tags:
    categories:
    ---
    <div>
<div>
<div id="sina_keyword_ad_area2" class="articalContent   ">
<p>摘自：http://www.wpdaxue.com/briefly-unavailable-for-scheduled-maintenance.html</p>
<p>&nbsp;</p>
<p>WordPress在升级程序、主题、插件时，都会先切换到维护模式，也就是显示 &ldquo;正在执行例行维护，请一分钟后回来（Briefly unavailable for scheduled maintenance. Check back in a minute）&rdquo;，如果升级顺利，也就几秒左右就恢复正常；但是如果由于网速不佳等原因导致升级中断，WordPress就会一直停留在维护模式，不论前台还是后台，都一直显示&ldquo;正在执行例行维护，请一分钟后回来&ldquo;。</p>
<p>如何解决这个问题呢？</p>
<p>1.马上通过FTP登录你的网站，删除WordPress根目录下的 .maintenance ，刷新网页即可。</p>
<p>2.但是有时候你会发现，根目录根本就没有 .maintenance！倡萌最近就遇到这个问题，最初以为是隐藏了，所以使用SSH登录服务器，但是依旧没有看到，怎么办？其实有一个比较简单的办法，直接新建一个空的txt文本，上传到主机空间中，然后重命名为 .maintenance，然后你会发现 .maintenance 居然不见了！不用担心，重新刷新你的网站，是不是正常了？！</p>
<p>3.如果还是不行，或者你想让它以后可以显示 .maintenance ，那就打开 /wp-admin/includes/class-wp-filesystem-direct.php</p>
<p>找到下面的代码：<br />
[php]function mkdir($path, $chmod = false, $chown = false, $chgrp =
false) {<br />
// safe mode fails with a trailing slash under certain PHP
versions.<br />
$path = untrailingslashit($path);<br />
if ( empty($path) )<br />
return false;</p>
<p>if ( ! $chmod )<br />
$chmod = FS_CHMOD_DIR;</p>
<p>if ( ! @mkdir($path) )<br />
return false;<br />
$this-&amp;gt;chmod($path, $chmod);<br />
if ( $chown )<br />
$this-&amp;gt;chown($path, $chown);<br />
if ( $chgrp )<br />
$this-&amp;gt;chgrp($path, $chgrp);<br />
return true;<br />
}[/php]</p>
<p>&nbsp;</p>
<p><span style="line-height: 1.714285714; font-size: 1rem;">将其改为：[php]function
mkdir($path, $chmod = false, $chown = false, $chgrp = false)
{<br />
// safe mode fails with a trailing slash under certain PHP
versions.<br />
if ( ! $chmod )<br />
$chmod = $this-&gt;permission;</span></p>
<p>if(ini_get('safe_mode') &amp;&amp;
substr($path, -1) == '/')<br />
{<br />
$path = substr($path, 0, -1);<br />
}</p>
<p>if ( ! @mkdir($path) )<br />
return false;<br />
$this-&gt;chmod($path, $chmod);<br />
if ( $chown )<br />
$this-&gt;chown($path, $chown);<br />
if ( $chgrp )<br />
$this-&gt;chgrp($path, $chgrp);<br />
return true;<br />
}[/php]</p>
<p>然后刷新FTP目录，是不是看到.maintenance了，删除它吧！<br />
<br />
查看原文：<a href="http://imjc.tk/archives/202.html" rel="nofollow">http://imjc.tk/archives/202.html</a></p>
							
		</div>
</div>
</div>
    