---
tags:
  - Nginx/模块
---

- ~ 官方文档

http://nginx.org/en/docs/http/ngx_http_limit_req_module.html

- ~ 配置语法

Syntax: limit_req_zone key zone=name:size rate=rate;

Default: —

Context: http



Syntax: limit_conn zone number [burst=number] [nodelay];

Default: —

Context: http, server, location

- ~ 参数解释

定义一条规则

```shell
limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;



limit_req_zone 				#引用限速模块

$binary_remote_addr 			#客户端 IP 地址，以二进制形式存储，用于标识来源。

zone=one:10m 				#共享内存中创建名为“one”的存储区，大小为10MB，用于记录IP地址和请求时间。

rate=1r/s;					#允许的请求率为每秒1次请求。



引用一条限速规则

limit_req zone=two burst=5 nodelay;



limit_req 						#引用限速规则语法

zone=one 					#引用哪一条规则

burst=5 						#允许突发请求量最多5个请求。超过这个数量的请求将被延迟处理或返回错误。

nodelay;						#即使突发请求量已满，也立即处理请求，而不是延迟它们

```
### 配置实验

```
cat >/etc/nginx/conf.d/01-www.conf <<EOF

limit_req_zone $binary_remote_addr zone=req_zone:10m rate=1r/s;

server   {

​    listen       80;

​    server_name  www.abc.com;

​    limit_req zone=req_zone burst=3 nodelay;

​    access_log  /var/log/nginx/www.access.log  main;

​    location / {

​        root   /usr/share/nginx/html/www;

​        index  index.html index.htm;

​    }

}

EOF

```
- ~ 访问测试

ab压测

yum install httpd-tools -y
ab -n 20 -c 2 http://www.man.com/

for循环

一秒1次
for i in {1..10000};do curl -I 10.0.0.7;sleep 1;done

一秒2次
for i in {1..10000};do curl -I 10.0.0.7;sleep 0.5;done

一秒5次
for i in {1..10000};do curl -I 10.0.0.7;sleep 0.2;done

