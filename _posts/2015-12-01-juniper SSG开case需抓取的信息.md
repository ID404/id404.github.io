---
    layout: post
    title: juniper SSG开case需抓取的信息
    tags:
    categories:
    ---
    <p>get tech-support</p>
<p>get event</p>
<p>get log sys</p>
<p>get log sys saved</p>
<p>get performance&nbsp;cpu&nbsp;all detail</p>
<p>get performance session detail</p>
<p>get session info</p>
<p>get&nbsp;dbuf&nbsp;stream</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>将相关信息通过相应接口保存到tftp名为&lt;filename&gt;的文件</p>
<p>get system &gt; tftp 172.0.3.2 &nbsp;&lt;filename&gt; &nbsp;from e0/0</p>
<p>&nbsp;</p>
<p>获取memory dump</p>
<p>格式化U盘为FAT16后接入设备</p>
<p>一般U盘超过4G无法格式化为FAT16格式，可以使用diskgenius等分区软件分一个小于4G的分区，格式化为FAT6</p>
<p>set core-dump usb full memory_dump 1200</p>
<p>&nbsp;</p>
<div class="cnblogs_Highlighter">
<pre class="brush:csharp;gutter:true;">please take the setp for memory dump again.

inster  usb driver in ssg320m

run

set core-dump usb full memory_dump 1200

and DO NOT pull out usb driver.

wait crash happens.

 
when box finished reboot. remove usb driver. and send us the

"memory_dump" file and "get log sys save".

 
</pre>
</div>
<p>附上官网链接</p>
<p><a href="http://kb.juniper.net/InfoCenter/index?page=content&amp;id=KB12496&amp;actp=search" target="_blank">http://kb.juniper.net/InfoCenter/index?page=content&amp;id=KB12496&amp;actp=search</a></p>
<p>　</p>
<p><img src="/images/blog/725676-20151217140632162-396922512.png" alt="" /></p>
<p>&nbsp;</p>
<p class="reader-word-layer reader-word-s1-1">取出USB存储设备前操作:&nbsp;</p>
<p class="reader-word-layer reader-word-s1-2">exec usb-deivce&nbsp;stop</p>
    
