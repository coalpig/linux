使用控制多个进程

supervisor介绍：

```
supervisor是一款可以控制/监控多个进程运行的软件
当supervisor监控的服务进程意外退出时，supervisor可以自动重启服务进程
但是有个前提，由supervisor控制的进程必须是前台启动的，否则会启动失败
在容器中使用时supervisor自己本身可以修改配置文件设置为前台启动
```

supervisor配置解释：

```
[program:服务名称]
command=nginx -g 'daemon off;'	#服务前台运行命令
autostart=true   				#启动supervisor立刻启动服务进程
autorestart=true				#如果服务进程意外退出，由supervisor重新拉起
startsecs = 5					#启动5秒没退出，就认为程序启动正常，默认1秒
startretries=3    				#启动失败自动重试次数，默认是3
user=nginx        				#启动进程的用户，默认root
redirect_stderr = true			#记录错误日志
stdout_logfile_maxbytes = 20MB	#日志最大大小，默认50M
stdout_logfile_backups = 20		#日志文件备份数量，默认10个
stdout_logfile = /var/log/supervisor/nginx.log	#日志路径
```

举例：

```
#1.安装软件
yum -y install supervisor

#2.编写进程配置文件
[root@b7757c17bf36 ~]# cat /etc/supervisord.d/nginx_php.ini 
[program:nginx]
command=nginx -g 'daemon off;'
autostart=true
autorestart=true
startsecs = 5
redirect_stderr = true
stdout_logfile_maxbytes = 20MB
stdout_logfile_backups = 20
stdout_logfile = /var/log/supervisor/nginx.log

[program:php-fpm]
command=php-fpm -c /etc/php.ini -y /etc/php-fpm.conf
autostart=true
autorestart=true
startsecs = 5
redirect_stderr = true
stdout_logfile_maxbytes = 20MB
stdout_logfile_backups = 20
stdout_logfile = /var/log/supervisor/php-fpm.log

#3.修改supervisord配置文件放在前台启动
sed -i "s#nodaemon=false#nodaemon=true#g" /etc/supervisord.conf

#4.启动supervisord程序
supervisord -c /etc/supervisord.conf 

#5.使用命令
supervisorctl update
supervisorctl status
supervisorctl start nginx
supervisorctl restart nginx
supervisorctl stop nginx
```
