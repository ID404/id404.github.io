---
    title: shell深井冰之linux命令行下使用豆瓣FM
    date: 2014-12-27 22:03:00
    updated: 2015-03-03 22:45:00
    abbrlink: 4306891
    tags:
    categories:
    ---
    <div>
<div>
<div id="sina_keyword_ad_area2" class="articalContent   newfont_family">
<p>一直关注之乎上一个问答：你电脑上跑着哪些好玩脚本？<br />
里面有这样一则回答说是用python+shell实现豆瓣FM
http://www.zhihu.com/question/27065450/answer/35658081<br />
觉得挺好玩的于是尝试下来玩玩</p>
<p>首先进入项目主页获取下载地址https://github.com/taizilongxu/douban.fm<br />
终端输入wget
https://github.com/taizilongxu/douban.fm/archive/master.zip下载文件<br />

下载后解压：upzip master.zip</p>
<p>进入安装目录发现有setup.py文件 执行python setup.py<br />
时发现报错ImportError: No module named setuptools<br />
百度发现解决方法：http://pythontab.com/html/2012/pythonhexinbiancheng_1220/21.html</p>
<p>同时发现原来setup.py文件要先编译再安装-_-b<br />
先编译 python setup.py build<br />
安装python setup.py install</p>
<p>安装完后直接输入douban.fm就可以用命令行听豆瓣了<br /><img src="http://images.cnitblog.com/blog/725676/201503/011310145807768.jpg" alt="" /><br />
<br />
<br />
查看原文：<a href="http://imjc.tk/archives/575.html" rel="nofollow">http://imjc.tk/archives/575.html</a></p>





							
		</div>





</div>





</div>
    