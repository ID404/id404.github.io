---
layout: post
title: 让wordpress首页不显示指定分类文章
keywords: wordpress
description: 让wordpress首页不显示指定分类文章
categories: wordpress
---
让wordpress首页不显示指定分类文章
<div><div><div id="sina_keyword_ad_area2"  class="articalContent   "  >
			<p>本站有一个类微博的页面<a rel="nofollow" HREF="http://imjc.tk/?cat=2"  >http://imjc.tk/?cat=2</A>，这里主要记录本人平时乱七八糟的想法。由于以后这个页面会频繁更新，如果把更新的内容放的首页的话会显得首页过于混乱。在首页将这一分类屏蔽十分有必要。</P>
<p>首先进入wordpress后台当前主题的编辑界面，找到index.php</P>
<p>找到以下代码</P>
<pre>
&lt;?php if (have_posts()) : while (have_posts()) : the_post(); update_post_caches($posts); ?&gt;
</PRE>
<p><span style="line-height: 1.714285714; font-size: 1rem;"  >在这段代码前增加</SPAN></P>
<pre>
&lt;?php if (is_home()) {query_posts("cat=-1,-2");}?&gt;
</PRE>
<p>这段代码主要的目的是在首页排除ID为1、2的分类目录</P>
<p>&nbsp;<br />
<br />
查看原文：<a rel="nofollow" HREF="http://imjc.tk/archives/100.html"  >http://imjc.tk/archives/100.html</A></P>							
		</div></div></div>
    
