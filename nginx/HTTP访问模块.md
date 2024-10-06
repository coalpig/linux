---
tags:
  - Nginx/模块
---

- ~ 官方文档

http://nginx.org/en/docs/http/ngx_http_access_module.html

- ~ 配置语法

Syntax: allow address | CIDR | unix: | all;

Default: —

Context: http, server, location, limit_except



Syntax: deny address | CIDR | unix: | all;

Default: —

Context: http, server, location, limit_except

- ~ 配置实验

实验1：拒绝windows访问www域名

```
cat > /etc/nginx/conf.d/01-www.conf <<EOF

server   {

​    listen       80;

​    server_name  www.abc.com;

​    location / {

​        root   /usr/share/nginx/html/www;

​        index  index.html index.htm;

​        deny 10.0.0.1;

​        allow all;

​    }

}

EOF
```

实验2：只允许windows访问，其他全部拒绝

```
cat >/etc/nginx/conf.d/01-www.conf<<EOF

server   {

​    listen       80;

​    server_name  www.man.com;

​    location / {

​        root   /usr/share/nginx/html/www;

​        index  index.html index.htm;

​        allow 10.0.0.1;

​        deny all;

​    }

}

EOF
```
