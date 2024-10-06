官方文档：

```
https://www.zabbix.com/documentation/5.0/zh/manual/installation/containers
```

使用自定义网络：

```
docker network create -d bridge --subnet 172.16.1.0/24 --gateway 172.16.1.1 zabbix-net
```



```
docker compose rm 

docker compose up -d
```

![](attachments/Pasted%20image%2020240823163752.png)
出现这种情况是搜友compose都使用一个网络，只需要在最后加上

```
networks:
  default:
    external: true
    name: zabbix-net
```

```
services:
  mysql:
    image: abc.com/base/mysql:8.0
    container_name: mysql-server
    environment:
      - MYSQL_DATABASE=zabbix
      - MYSQL_USER=zabbix
      - MYSQL_PASSWORD=zabbix
      - MYSQL_ROOT_PASSWORD=root
    command:
      --character-set-server=utf8 
	  --collation-server=utf8_bin
      --default-authentication-plugin=mysql_native_password
    volumes:
      - /data/mysql_zabbix:/var/lib/mysql
    ports:
      - 3306:3306
 
	  
  zabbix-server: 
    image: abc.com/zabbix/zabbix/zabbix-server-mysql:alpine-latest
    container_name: zabbix-server-mysql
    environment:
      - DB_SERVER_HOST=mysql-server
      - MYSQL_DATABASE=zabbix
      - MYSQL_USER=zabbix
      - MYSQL_PASSWORD=zabbix
      - MYSQL_ROOT_PASSWORD=root
    ports:
      - 10051:10051
    depends_on:
      - mysql

  zabbix-web: 
    image: abc.com/zabbix/zabbix/zabbix-web-nginx-mysql:alpine-latest
    container_name: zabbix-web-nginx-mysql
    environment:
      - ZBX_SERVER_HOST=zabbix-server
      - DB_SERVER_HOST=mysql
      - MYSQL_DATABASE=zabbix
      - MYSQL_USER=zabbix
      - MYSQL_PASSWORD=zabbix
      - MYSQL_ROOT_PASSWORD=root
    ports:
      - 80:8080
    depends_on:
      - mysql
	  
	  
networks:
  default:
    external: true
    name: zabbix-net
```

需要注意的地方

```
ZBX_JAVAGATEWAY=zabbix-java-gateway  #需要删除
```
