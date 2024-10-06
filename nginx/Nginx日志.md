---
tags:
  - Nginx
---

> [!info]- Nginx日志说明
> 
> 
>  Nginx的日志分为访问日志和错误日志两种，其中访问日志的格式我们可以根据自己的需求定义成不同的格式，比如为了方便日后的日志分析，我们可以将Nginx日志设置为json格式。
> 

> [!info]- Nginx日志字段解释
> 
> 
> ```shell
> 
> $remote_addr            #记录客户端 IP 地址
>  $remote_user            #记录客户端用户名
>  $time_local             #记录通用的本地时间
>  $time_iso8601           #记录 ISO8601 标准格式下的本地时间
>  $request                #记录请求的方法以及请求的 http 协议
>  $status                 #记录请求状态码(用于定位错误信息)
>  $body_bytes_sent        #发送给客户端的资源字节数，不包括响应头的大小
>  $bytes_sent             #发送给客户端的总字节数
>  $msec                   #日志写入时间。单位为秒，精度是毫秒。
>  $http_referer           #记录从哪个页面链接访问过来的
>  $http_user_agent        #记录客户端浏览器相关信息
>  $http_x_forwarded_for   #记录客户端 IP 地址
>  $request_length         #请求的长度（包括请求行， 请求头和请求正文）。
>  $request_time           #请求花费的时间，单位为秒，精度毫秒
>  # 注:如果 Nginx 位于负载均衡器， nginx 反向代理之后， web 服务器无法直接获取到客 户端真实的 IP 地址。
>  # $remote_addr 获取的是反向代理的 IP 地址。 反向代理服务器在转发请求的 http 头信息中，
>  # 增加 X-Forwarded-For 信息，用来记录客户端 IP 地址和客户端请求的服务器地址。
> 
> ```

> [!ifno]- 自定义Nginx日志格式
> 
> 
> 转换为json格式日志：
> 
> ```shell
> log_format json '{ "time_local": "$time_local", '
>                            '"remote_addr": "$remote_addr", '
>                            '"referer": "$http_referer", '
>                            '"request": "$request", '
>                            '"status": $status, '
>                            '"bytes": $body_bytes_sent, '
>                            '"agent": "$http_user_agent", '
>                            '"x_forwarded": "$http_x_forwarded_for", '
>                            '"up_addr": "$upstream_addr",'
>                            '"up_host": "$upstream_http_host",'
>                            '"upstream_time": "$upstream_response_time",'
>                            '"request_time": "$request_time"'
>      ' }';
>      access_log  /var/log/nginx/access.log  json;
> ```
> 

> [!test]- Nginx日志切割方法
> 
> 
> 
> > 为什么需要日志切割？
> 
>  nginx日志默认是不切割的，这样当我们运行时间久了之后自然而然的会产生大量的日志，对我们日后分析不是很友好，所以工作中一般都是按天切割日志。
> 
> >第一种方法：自己写脚本切割
> 
> ```shell
> cd /var/log/nginx/
>  tar zcf $(date +%F)-nginx-log.tar.gz access.log 
>  rm -rf access.log
>  systemctl reload nginx
> ```
> 
> >第二种方法：使用logrotate工具切割日志
> 
> logrotate是一款自动切割日志的工具。如果使用了rpm安装nginx，会自动生成logrotate的配置文件
> 
> >查看nginx的logrotate配置文件
> 
> ```shell
> [root@web-7 ~]# rpm -qc nginx|grep logrotate
>  /etc/logrotate.d/nginx
> ```
> 
> >nginx的logrotate配置解释
> 
> ```shell
> 
> [root@web-7 ~]# cat /etc/logrotate.d/nginx
>  /var/log/nginx/*.log {
>          daily                            #按日切割
>          missingok                    #忽略错误
>          rotate 52                     #最多保留多少个存档，超过数量之后删除最久的
>          compress                    #切割完成后将已经切割好的日志打包压缩
>          delaycompress             #将上一个日志文件的压缩推迟到下一个循环周期。仅在与compress结合使用时才有效。
>          notifempty                   #如果日志为空，则不切割
>          create 640 nginx adm        #以指定的权限创建权限的日志文件，同时重命名原始日志
>          sharedscripts               #共享脚本，此处为空
>          postrotate                   #当其他命令完成后执行的命令，这是是重新加载nginx进程的命令
>                  if [ -f /var/run/nginx.pid ]; then
>                          kill -USR1 `cat /var/run/nginx.pid`
>                  fi
>          endscript                   #最后执行的命令，此处为空
>  }
> ```

> [!info]- logrotate切割nginx日志实战
> 
> 
> >1.安装压测生成访问日志
> 
> ```shell
> [root@web-7 ~]# yum install httpd-tools -y 
> [root@web-7 ~]# ab -n 1000 -c 100 http://127.0.0.1/ 
> ```
> 
> >2.查看未切割之前的日志
>  
> ```shell
>  [root@web-7 ~]# ll /var/log/nginx/                           
>  总用量 932
>  -rw-r----- 1 nginx adm 949400 5月   6 21:32 access.log
>  -rw-r----- 1 nginx adm    700 5月   6 21:35 error.log
> ```
>  
> >3.执行logrotate命令
> 
> ```shell
>  [root@web-7 ~]# /usr/sbin/logrotate -f /etc/logrotate.d/nginx
> ```
>  
> >4.查看切割后的文件，会发现只是重命名了，但是没有压缩，只是因为我们设置了本次日志的压缩放在下一次循环执行
>  
> ```shell
>  [root@web-7 ~]# ll /var/log/nginx/                           
>  总用量 932
>  -rw-r----- 1 nginx adm      0 5月   6 21:35 access.log
>  -rw-r----- 1 nginx adm 949400 5月   6 21:32 access.log.1
>  -rw-r----- 1 nginx adm      0 5月   6 21:35 error.log
>  -rw-r----- 1 nginx adm    700 5月   6 21:35 error.log.1
> ```
>  
> >5.手动设置时间到明天
>  
> ```shell
> [root@web-7 ~]# date -s 20210507 
> ```
>  
> >6.再次执行压测命令
>  
> ```shell
>  [root@web-7 ~]# ab -n 1000 -c 100 http://127.0.0.1/ 
> ```
>  
>  >7.重新执行logrotate命令
>  
> ```shell
> [root@web-7 ~]# /usr/sbin/logrotate -f /etc/logrotate.d/nginx
> ```
> 
>  >8.再次查看日志情况
>  
> ```shell
>  [root@web-7 ~]# ll /var/log/nginx/
>  总用量 932
>  -rw-r----- 1 nginx adm      0 5月   6 21:37 access.log
>  -rw-r----- 1 nginx adm 940000 5月   6 21:37 access.log.1
>  -rw-r----- 1 nginx adm   3351 5月   6 21:32 access.log.2.gz
>  -rw-r----- 1 nginx adm    205 5月   6 21:37 error.log
>  -rw-r----- 1 nginx adm    700 5月   6 21:35 error.log.1
>  
> ```
> 
> >9.将切割命令写入定时任务
>  
> ```shell
>  [root@web-7 ~]# crontab -l
>  \#update time
>  \* * * * * /usr/sbin/ntpdate time1.aliyun.com > /dev/null 2>&1
>  
>  \#logrotate nginx log
>  01 00 * * * /usr/sbin/logrotate -f /etc/logrotate.d/nginx >> logrotate_nginx 2>&1x
> 
> 
> ```

 

