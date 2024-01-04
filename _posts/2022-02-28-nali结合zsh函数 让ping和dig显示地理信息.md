---
    layout: post
    title: nali结合zsh函数 让ping和dig显示地理信息
    tags:
    categories:
    ---
    <p><a href="https://www.cnblogs.com/id404/" target="_blank">效果如下图所示&nbsp;</a></p>
<p><img src="/images/blog/725676-20220228203502422-1981016632.png" alt="" /></p>
<p>&nbsp;</p>
<p>要实现此效果，需要使用开源项目<a href="https://github.com/zu1k/nali" target="_blank">nali</a> &nbsp;</p>
<p>安装nali</p>
<div class="cnblogs_Highlighter">
<pre class="brush:bash;gutter:true;"> go get -u -v github.com/zu1k/nali
</pre>
</div>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>将文件复制到/usr/local/bin目录下</p>
<div class="cnblogs_Highlighter">
<pre class="brush:bash;gutter:true;"> cp /System/Volumes/Data/Users/&lt;USER_NAME&gt;/go/bin/nali /usr/local/bin
</pre>
</div>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>验证nali 可执行&nbsp;</p>
<p>nali &lt;IP或域名&gt;</p>
<p>例如：</p>
<div class="cnblogs_Highlighter">
<pre class="brush:bash;gutter:true;">nali 114.114.114.114
114.114.114.114 [江苏省南京市 南京信风网络科技有限公司GreatbitDNS服务器]
</pre>
</div>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>添加 zsh函数</p>
<div class="cnblogs_Highlighter">
<pre class="brush:bash;gutter:true;">sudo vi ~/.zshrc
</pre>
</div>
<p>&nbsp;</p>
<p>在末尾添加以下内容</p>
<div class="cnblogs_Highlighter">
<pre class="brush:bash;gutter:true;">ping () {
/sbin/ping $1 $2 $3 | nali
}

dog () {
dig $1 $2 $3 | nali
}
</pre>
</div>
<p>&nbsp;</p>
<p><a href="https://www.cnblogs.com/id404/" target="_blank">保存后即可实现效果&nbsp;</a></p>
    
