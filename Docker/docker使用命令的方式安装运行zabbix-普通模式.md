容器命令

```
docker run --name mysql \
-p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=123 \
-e MYSQL_DATABASE=zabbix \
-e MYSQL_USER=zabbix \
-e MYSQL_PASSWORD=zabbix \
-v /data/docker_mysql:/var/lib/mysql \
-d mysql:5.7 \
--character-set-server=utf8 --collation-server=utf8_bin

docker run --name zabbix-server-mysql \
--link mysql \
-e DB_SERVER_HOST="mysql" \
-e MYSQL_USER="zabbix" \
-e MYSQL_PASSWORD="zabbix" \
-p 10051:10051 \
-d zabbix/zabbix-server-mysql

docker run --name zabbix-web-nginx-mysql \
--link mysql \
--link zabbix-server-mysql \
-e DB_SERVER_HOST="mysql" \
-e MYSQL_USER="zabbix" \
-e MYSQL_PASSWORD="zabbix" \
-e ZBX_SERVER_HOST="zabbix-server-mysql" \
-e PHP_TZ="Asia/Shanghai" \
-p 80:8080 \
-d zabbix/zabbix-web-nginx-mysql
```

容器注释

mysql容器注释：

```
docker run \
#mysql服务
--name mysql \

#映射端口 宿主机端口:容器内端口	
-p 3306:3306 \	

#启动Mysql初始化的时候设置root的密码			
-e MYSQL_ROOT_PASSWORD=123 \

#初始化时创建的数据库名称		
-e MYSQL_DATABASE=zabbix \

#初始化时创建的的普通用户，此用户对刚才创建的数据库拥有所有权限			
-e MYSQL_USER=zabbix \	

#普通用户的密码			
-e MYSQL_PASSWORD=zabbix \			

#将容器内的数据持久化到宿主机，如果已经有数据了，用户传递的变量就失效了
-v /data/docker_mysql:/var/lib/mysql \	

#后台启动，使用镜像名称
-d mysql:5.7 \

#设置数据库的字符集
--character-set-server=utf8 --collation-server=utf8_bin
```

zabbix-server-mysql容器注释：

```
docker run \
#给zabbix服务端容器起个名字
--name zabbix-server-mysql \

#连接到mysql容器，连接后可以直接使用容器名进行通讯
--link mysql \

#后端mysql的连接地址，这里因为Link了mysql容器，所以可以直接使用容器名通讯
-e DB_SERVER_HOST="mysql" \

#告诉zabbix-server连接mysql使用什么用户
-e MYSQL_USER="zabbix" \

#告诉zabbix-server连接mysql的用户的密码
-e MYSQL_PASSWORD="zabbix" \

#将zabbix-server的服务端口暴露出来，方便客户端连接
-p 10051:10051 \

#使用镜像名称
-d zabbix/zabbix-server-mysql
```

zabbix-web-nginx-mysql容器注释:

```
docker run \
--name zabbix-web-nginx-mysql \
--link mysql \
--link zabbix-server-mysql \

#连接数据库的地址，因为link了mysql容器，所以可以直接使用容器名通讯
-e DB_SERVER_HOST="mysql" \

#mysql连接的用户
-e MYSQL_USER="zabbix" \

#mysql连接的用户密码
-e MYSQL_PASSWORD="zabbix" \

#zabbix-server的地址，因为link了zabbix-server的容器，所以可以直接使用容器名通讯
-e ZBX_SERVER_HOST="zabbix-server-mysql" \

#修改php的时区为上海
-e PHP_TZ="Asia/Shanghai" \

#映射web网页端口，通过查看镜像信息得知容器内是8080
-p 80:8080 \

#镜像名称
-d zabbix/zabbix-web-nginx-mysql
```



