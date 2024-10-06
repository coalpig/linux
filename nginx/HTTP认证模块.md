---
tags:
  - Nginx/模块
---


- ~ 官方文档

http://nginx.org/en/docs/http/ngx_http_auth_basic_module.html

- ~ 配置语法

Syntax: auth_basic string| off;

Default: auth_basic off;

Context: http, server, location, limit_except



Syntax: auth_basic_user_file file;

Default: -

Context: http, server, location, limit_except

- ~ 配置实验

安装生成密码工具:

yum install httpd-tools -y

创建新的密码文件, -c 创建新文件 -b 允许命令行输入密码：

htpasswd -b -c /etc/nginx/auth_conf abc abc

nginx子配置：

```
cat >/etc/nginx/conf.d/01-www.conf <EOF

server   {

​    listen       80;

​    server_name  www.abc.com;

​    location / {

​        auth_basic "Auth access Blog Input your Passwd!";

​        auth_basic_user_file auth_conf;

​        root   /usr/share/nginx/html/www;

​        index  index.html index.htm;

​    }

}

EOF
```
