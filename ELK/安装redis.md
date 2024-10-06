```

#安装
yum install redis -y

#修改配置
vim /etc/redis.conf
bind 10.0.0.7

#重启redis
systemctl restart redis

#测试访问
redis-cli -h 10.0.0.7

```