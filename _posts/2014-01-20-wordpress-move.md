---
    title: wordpress  搬家
    date: 2014-01-20 21:03:00
    updated: 2014-01-20 21:03:00
    abbrlink: 4306915
    tags:
    categories:
    ---
    <div><div><div id="sina_keyword_ad_area2"  class="articalContent   "  >
			<p>网站原空间是放在3owl,由于最近经常提示带宽限制无法访问于是决定迁移空间.</P>
<p>以下为搬家过程:</P>
<p>1.在3owl后台备份空间所有文件和数据库</P>
<p>2.将备份的数据库和文件导入到新空间</P>
<p>3.修改网站根目录下wp-config.php文件相关的数据库参数，如下：</P>
<p>define('DB_NAME', '你的数据库名称');</P>
<p>define('DB_USER', '你的数据库用户名');</P>
<p>define('DB_PASSWORD', '你的数据库密码')</P>
<p>define('DB_HOST','localhost');</P>
<p>4.修改域名A记录指向新空间.</P>
<p>&nbsp;</P>
<p>若要更换域名,还需进行以下操作:</P>
<p>5.在新空间后台进入phpMyAdmin</P>
<p>执行以下sql语句(注意将old.com改为原域名，将new.com改为新域名):</P>
<p>UPDATE wp_posts SET post_content = replace( post_content,
'old.com','new.com') ;</P>
<p>UPDATE wp_comments SET comment_content =
replace(comment_content,&nbsp;'old.com','new.com') ;</P>
<p>UPDATE wp_comments SET comment_author_url =
replace(comment_author_url,&nbsp;'old.com','new.com') ;</P>
<p>&nbsp;</P>
<p>6.修改网站根目录文件.htaccess</P>
<p>将old.com改为新域名</P>
<p>RewriteEngine on<br />
RewriteCond %{HTTP_REFERER} !^http://old.com/.*$ [NC]<br />
RewriteCond %{HTTP_REFERER} !^http://old.com$ [NC]<br />
RewriteCond %{HTTP_REFERER} !^http://www.old.com/.*$ [NC]<br />
RewriteCond %{HTTP_REFERER} !^http://www.old.com$ [NC]</P>							
		</div></div></div>
    