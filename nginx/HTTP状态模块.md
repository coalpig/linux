---
tags:
  - Nginx/模块
---

>官方文档

http://nginx.org/en/docs/http/ngx_http_stub_status_module.html

>配置语法

Syntax:	stub_status;

Default:	—

Context:	server, location

>配置实验

```shell
cat > /etc/nginx/conf.d/status.conf <<EOF

server {

   listen 80;

   server_name  status.abc.com;

   stub_status on;

   access_log off;

}

EOF

```

>状态解释

**Active connections: N**：当前有N个活跃的连接。

**server accepts handled requests**：下一行的三个数字代表：

- Nginx 自启动以来接受的连接总数。
- Nginx 成功处理的连接总数。
- Nginx 自启动以来处理的请求数量。

**Reading: N**：当前有N个连接在读取客户端的请求。

**Writing: N**：当前有N个连接在向客户端发送数据。

**Waiting: N**：当前在等待状态的连接数为N。
