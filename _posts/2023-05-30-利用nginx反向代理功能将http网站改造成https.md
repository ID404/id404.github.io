---
    layout: post
    title: 利用nginx反向代理功能将http网站改造成https
    tags:
    categories:
    ---
    <p>内网服务器10.0.0.4使用web应用是http，由于各种原因无法在10.0.0.4上将http升级至https</p>
<p>此时可以在另一台服务器10.0.0.3上部署nginx ,利用nginx的反向代理功能，将访问10.0.0.3的流量转发至10.0.0.4 同时将访问80端口的流量自动跳转至443</p>
<p>当然也可以在10.0.0.4这台服务器上部署nginx，但nginx监听的端口不能和原来的应用一样，需要换一个端口</p>
<p>&nbsp;</p>
<p>nginx配置如下</p>
<div class="cnblogs_code">
<pre><span style="color: #000000;">worker_processes  1;

events {
    worker_connections  1024;
}

http {
    server {
        listen 80;
        server_name example.com www.example.com;
        return 301 https://$host$request_uri;
    }
    server {
        listen       443 ssl;

        server_name  example.com www.example.com;

        ssl_certificate /etc/nginx/ssl/www.webside.cer;
        ssl_certificate_key /etc/nginx/ssl/www.website.key;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
        ssl_prefer_server_ciphers on;


        location / {
            proxy_pass http://10.0.0.4;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            #root   /usr/share/nginx/html;
            #index  index.html index.htm;
        }
    }
}</span></pre>
</div>
<p>&nbsp;</p>
    
