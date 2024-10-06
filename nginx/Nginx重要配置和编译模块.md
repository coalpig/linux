---
tags:
  - Nginx
---
- ~ Nginx重要配置文件说明

> [!info]- 配置文件安装位置
> 
> 
> ```shell
> [root@web-7 ~]# rpm -ql nginx 
>  /etc/logrotate.d/nginx                       #nginx日志切割的配置文件
>  /etc/nginx/nginx.conf                        #nginx主配置文件 
>  /etc/nginx/conf.d                               #子配置文件
>  /etc/nginx/conf.d/default.conf          #默认展示的页面一样 
>  /etc/nginx/mime.types                      #媒体类型 （http协议中的文件类型）
>  /etc/sysconfig/nginx                          #systemctl 管理 nginx的使用的文件
>  /usr/lib/systemd/system/nginx.service     #systemctl 管理nginx（开 关 重启 reload)配置文件       
>  /usr/sbin/nginx                                  #nginx命令
>  /usr/share/nginx/html                       #站点目录 网站的根目录 
>  /var/log/nginx                                   #nginx日志 access.log 访问日志
> ```

> [!config]- 配置文件注解
> 
> 
> Nginx 主配置文件/etc/nginx/nginx.conf 是一个纯文本类型的文件，整个配置文件是以区块的形式组织的。
> 每个区块以一对大括号{}来表示开始与结束。
> Nginx 主配置文件整体分为三块进行学习
>  
> CoreModule(核心模块)
> EventModule(事件驱动模块)
> HttpCoreModule(http 内核模块)
> 
> 第一部分：配置文件主区域配置
> 
> ```shell
>  user  nginx;                              #定义运行Nginx进程的用户
>  worker_processes  auto;                   #Nginx运行的work进程数量(建议与CPU数量一致或 auto)
>  error_log  /var/log/nginx/error.log warn; #nginx错误日志
>  pid        /var/run/nginx.pid;            #nginx运行pid
> ```
> 
> 第二部分：配置文件事件区域
> 
> ```shell
> events {
>      worker_connections  1024;          #每个 worker 进程支持的最大连接数
>  }
> ```
> 
> 第三部分：配置http区域
> 
> ```shell
> http {
>      include       /etc/nginx/mime.types;     #Nginx支持的媒体类型库文件
>      default_type  application/octet-stream;  #默认的媒体类型，以二进制文件下载的形式保存文件
>      
>      log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '#日志格式
>                        '$status $body_bytes_sent "$http_referer" '
>                        '"$http_user_agent" "$http_x_forwarded_for"';
>                        
>      access_log  /var/log/nginx/access.log  main;    #访问日志保存路径
>  
>      sendfile        on;       #开启高效传输模式
>      #tcp_nopush     on;      #必须配合tcp_nopush使用，当数据包累计到一定大小后就发送
>      keepalive_timeout  65;   #连接超时时间，单位是秒
>      #gzip  on;               #开启文件压缩
>      include /etc/nginx/conf.d/*.conf;    #包含子配置文件
>  }
> ```
> 
> **第四部分：子配置文件内容**
> 
> ```
> server {
>      listen       80;                         #指定监听端口
>      server_name  localhost;                  #指定监听的域名
>      location / {                             #匹配URL地址
>          root   /usr/share/nginx/html;        #定义站点的目录
>          index  index.html index.htm;         #定义首页文件
>      }
>  }
> ```
> 

> [!info]- 查看已经编译的模块
> 
> 
> ```shell
> [root@web-7 ~]# nginx -V
> ```