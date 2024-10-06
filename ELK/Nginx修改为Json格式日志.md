```
#停止filebeat
systemctl stop filebeat.service

#修改Nginx日志
vim /etc/nginx/nginx.conf
access_log  /var/log/nginx/access.log  json;

#重启Nginx
systemctl restart nginx

#清空日志
> /var/log/nginx/access.log

#测试访问
curl 10.0.0.7
tail -f /var/log/nginx/access.log
```