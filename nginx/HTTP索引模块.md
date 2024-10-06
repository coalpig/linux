---
tags:
  - Nginx/模块
---
>官方文档

http://nginx.org/en/docs/http/ngx_http_autoindex_module.html


>配置语法

Syntax: autoindex on | off;

Default: autoindex off;

Context: http, server, location



Syntax:	autoindex_exact_size on | off;

Default:	

autoindex_exact_size on;

Context:	http, server, location



Syntax:	autoindex_format html | xml | json | jsonp;

Default:	

autoindex_format html;

Context:	http, server, location

This directive appeared in version 1.7.9.



Syntax:	autoindex_format html | xml | json | jsonp;

Default:	

autoindex_format html;

Context:	http, server, location

This directive appeared in version 1.7.9.



Syntax:	autoindex_localtime on | off;

Default:	

autoindex_localtime off;

Context:	http, server, location

>配置解释

autoindex_exact_size off;

默认为 on， 显示出文件的确切大小，单位是 bytes。

修改为 off，显示出文件的大概大小，单位是 kB 或者 MB 或者 GB。



autoindex_localtime on;

默认为 off，显示的文件时间为 GMT 时间。

修改为 on， 显示的文件时间为文件的服务器时间。



charset utf-8,gbk;

默认中文目录乱码，添加上解决乱码

>配置实验

```shell
cat >/etc/nginx/conf.d/download.conf <<EOF

server {

​    listen 80;

​    server_name download.man.com;

​    location / {

​        root /usr/share/nginx/html/download;

​        charset utf-8,gbk;

​        autoindex on;

​        autoindex_localtime on;

​        autoindex_exact_size off;

​    }

}

EOF
```
