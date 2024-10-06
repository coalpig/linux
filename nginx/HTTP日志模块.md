---
tags:
  - Nginx/模块
---


- ~ 官方文档

https://nginx.org/en/docs/http/ngx_http_log_module.html

- ~ 关键指令

Syntax:	**access_log** path [format [buffer=size] [gzip[=level]] [flush=time] [if=condition]];

​                **access_log off**;

Default:	access_log logs/access.log combined;

Context:	http, server, location, if in location, limit_except

- ~ 默认配置

log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '

​                    '$status $body_bytes_sent "$http_referer" '

​                    "$http_user_agent" "$http_x_forwarded_for"';



access_log  /var/log/nginx/access.log  main;

- ~ 日志字段变量解释
```shell

$remote_addr 		#记录客户端 IP 地址

$remote_user 			#记录客户端用户名

$time_local 			#记录通用的本地时间

$time_iso8601 		#记录 ISO8601 标准格式下的本地时间

$request 				#记录请求的方法以及请求的 http 协议

$status 				#记录请求状态码(用于定位错误信息)

$body_bytes_sent 		#发送给客户端的资源字节数，不包括响应头的大小

$bytes_sent 			#发送给客户端的总字节数

$msec 				#日志写入时间。单位为秒，精度是毫秒。

$http_referer 			#记录从哪个页面链接访问过来的

$http_user_agent 		#记录客户端浏览器相关信息

$http_x_forwarded_for 	#记录客户端 IP 地址

$request_length 		#请求的长度（包括请求行， 请求头和请求正文）。

$request_time 		#请求花费的时间，单位为秒，精度毫秒
```

\# 注:如果 Nginx 位于负载均衡器， nginx 反向代理之后， web 服务器无法直接获取到客 户端真实的 IP 地址。

\# $remote_addr 获取的是反向代理的 IP 地址。 反向代理服务器在转发请求的 http 头信息中，

\# 增加 X-Forwarded-For 信息，用来记录客户端 IP 地址和客户端请求的服务器地址。

- ~ 参考的json日志配置

精简版

```
​    log_format json '{ "time_local": "$time_local", '

​                          '"remote_addr": "$remote_addr", '

​                          '"referer": "$http_referer", '

​                          '"request": "$request", '

​                          '"status": $status, '

​                          '"bytes": $body_bytes_sent, '

​                          '"user_agent": "$http_user_agent", '

​                          '"x_forwarded": "$http_x_forwarded_for", '

​                          '"up_addr": "$upstream_addr",'

​                          '"up_host": "$upstream_http_host",'

​                          '"upstream_time": "$upstream_response_time",'

​                          '"request_time": "$request_time"'

​    ' }';

​    access_log  /var/log/nginx/access.log  json;
```

完整版-解析IP地址需要将**geoip模块**编译进去

```
​        log_format json_analytics escape=json '{'

​                   '"msec": "$msec", ' # request unixtime in seconds with a milliseconds resolution

​                   '"connection": "$connection", ' # connection serial number

​                   '"connection_requests": "$connection_requests", ' # number of requests made in connection

​                   '"pid": "$pid", ' # process pid

​                   '"request_id": "$request_id", ' # the unique request id

​                   '"request_length": "$request_length", ' # request length (including headers and body)

​                   '"remote_addr": "$remote_addr", ' # client IP

​                   '"remote_user": "$remote_user", ' # client HTTP username

​                   '"remote_port": "$remote_port", ' # client port

​                   '"time_local": "$time_local", '

​                   '"time_iso8601": "$time_iso8601", ' # local time in the ISO 8601 standard format

​                   '"request": "$request", ' # full path no arguments of the request

​                   '"request_uri": "$request_uri", ' # full path and arguments of the request

​                   '"args": "$args", ' # args

​                   '"status": "$status", ' # response status code

​                   '"body_bytes_sent": "$body_bytes_sent", ' # the number of body bytes exclude headers sent to a client

​                   '"bytes_sent": "$bytes_sent", ' # the number of bytes sent to a client

​                   '"http_referer": "$http_referer", ' # HTTP referer

​                   '"http_user_agent": "$http_user_agent", ' # user agent

​                   '"http_x_forwarded_for": "$http_x_forwarded_for", ' # http_x_forwarded_for

​                   '"http_host": "$http_host", ' # the request Host: header

​                   '"server_name": "$server_name", ' # the name of the vhost serving the request

​                   '"request_time": "$request_time", ' # request processing time in seconds with msec resolution

​                   '"upstream": "$upstream_addr", ' # upstream backend server for proxied requests

​                   '"upstream_connect_time": "$upstream_connect_time", ' # upstream handshake time incl. TLS

​                   '"upstream_header_time": "$upstream_header_time", ' # time spent receiving upstream headers

​                   '"upstream_response_time": "$upstream_response_time", ' # time spent receiving upstream body

​                   '"upstream_response_length": "$upstream_response_length", ' # upstream response length

​                   '"upstream_cache_status": "$upstream_cache_status", ' # cache HIT/MISS where applicable

​                   '"ssl_protocol": "$ssl_protocol", ' # TLS protocol

​                   '"ssl_cipher": "$ssl_cipher", ' # TLS cipher

​                   '"scheme": "$scheme", ' # http or https

​                   '"request_method": "$request_method", ' # request method

​                   '"server_protocol": "$server_protocol", ' # request protocol, like HTTP/1.1 or HTTP/2.0

​                   '"pipe": "$pipe", ' # "p" if request was pipelined, "." otherwise

​                   '"gzip_ratio": "$gzip_ratio"'

​                   '}';

```