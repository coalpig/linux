
```
systemctl stop nginx
> /var/log/nginx/access.log
vim /etc/nginx/nginx.conf
access_log  /var/log/nginx/access.log  main;
----------------------------------------------
nginx -t
systemctl restart nginx 
curl 127.0.0.1 
tail -f /var/log/nginx/access.log
```