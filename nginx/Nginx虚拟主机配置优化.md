---
tags:
  - Nginx
---
> [!info]- 什么是虚拟主机
> 
> 
> 多个子配置，多个域名就是虚拟主机
> 
> 
> 规范做法就是主配置文件+子配置文件
> 
> 一个域名使用一个子配置

> [!config]- Nginx主配置文件
> 
> 
> ```shell
> 
> [root@web-7 /etc/nginx/conf.d]# cat /etc/nginx/nginx.conf 
>  
>  user  nginx;
>  worker_processes  1;
>  
>  error_log  /var/log/nginx/error.log warn;
>  pid        /var/run/nginx.pid;
>  
>  
>  events {
>      worker_connections  1024;
>  }
>  
>  
>  http {
>      include       /etc/nginx/mime.types;
>      default_type  application/octet-stream;
>  
>      log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
>                        '$status $body_bytes_sent "$http_referer" '
>                        '"$http_user_agent" "$http_x_forwarded_for"';
>  
>      access_log  /var/log/nginx/access.log  main;
>  
>      sendfile        on;
>      tcp_nopush     on;
>  
>      keepalive_timeout  65;
>  
>      gzip  on;
>  
>      include /etc/nginx/conf.d/*.conf;
>  }
> 
> ```
> 

> [!config]- 子配置文件www
> 
> 
> ```shell
> 
> [root@web-7 /etc/nginx/conf.d]# cat /etc/nginx/conf.d/www.conf 
>  server   {
>      listen       80;
>      server_name  www.abc.com;
>      location / {
>          root   /usr/share/nginx/html/www;
>          index  index.html index.htm;
>      }
>  }
> 
> ```
> 

> [!info]
> 子配置文件blog
> 
> ```shell
> [root@web-7 /etc/nginx/conf.d]# cat /etc/nginx/conf.d/blog.conf 
>  server   {
>      listen       80;
>      server_name  blog.abc.com;
>      location / {
>          root   /usr/share/nginx/html/blog;
>          index  index.html index.htm;
>      }
>  }
> ```
> 

> [!info]- 创建代码目录及首页
> 
> 
> ```shell
> mkdir /usr/share/nginx/html/{www,blog}
> echo "www" > /usr/share/nginx/html/www/index.html
> echo "blog" > /usr/share/nginx/html/blog/index.html
> ```

> [!test]- 检查语法重启服务
> 
> 
> ```shell
> [root@web-7 ~]# nginx -t
>  nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
>  nginx: configuration file /etc/nginx/nginx.conf test is successful
>  [root@web-7 ~]# systemctl restart nginx
> 
> ```
> 

> [!test]- 访问测试
> 
> 
> ```shell
> [root@web-7 ~]# tail -1 /etc/hosts  
> 10.0.0.7 www.abccity.com blog.abccity.com
> [root@web-7 ~]# curl www.abccity.com
> www
> [root@web-7 ~]# curl blog.abccity.com
> blog
> ```

