
这里使用了官方的documentation
https://www.zabbix.com/documentation

![](attachments/Pasted%20image%2020240823152255.png)


创建zabbix 的net模式网络
```
docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/20 zabbix-net
```

![](attachments/Pasted%20image%2020240823152419.png)
```
docker run --name mysql-server -t \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix" \
      -e MYSQL_ROOT_PASSWORD="root" \
      --network=zabbix-net \
      --restart unless-stopped \
      -d abc.com/base/mysql:8.0 \
      --character-set-server=utf8 --collation-server=utf8_bin \
      --default-authentication-plugin=mysql_native_password
```
	  
	  
```
docker run --name zabbix-server-mysql -t \
      -e DB_SERVER_HOST="mysql-server" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix" \
      -e MYSQL_ROOT_PASSWORD="root" \
      -e ZBX_JAVAGATEWAY="zabbix-java-gateway" \
      --network=zabbix-net \
      -p 10051:10051 \
      --restart unless-stopped \
      -d abc.com/zabbix/zabbix/zabbix-server-mysql:alpine-5.4-latest
```


```
docker run --name zabbix-web-nginx-mysql -t \
      -e ZBX_SERVER_HOST="zabbix-server-mysql" \
      -e DB_SERVER_HOST="mysql-server" \
      -e MYSQL_DATABASE="zabbix" \
      -e MYSQL_USER="zabbix" \
      -e MYSQL_PASSWORD="zabbix" \
      -e MYSQL_ROOT_PASSWORD="root" \
      --network=zabbix-net \
      -p 80:8080 \
      --restart unless-stopped \
      -d abc.com/zabbix/zabbix/zabbix-web-nginx-mysql:alpine-5.4-latest
```


