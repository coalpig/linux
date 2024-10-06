mysql容器命令

```
docker run --name mysql \
-p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=123 \
-e MYSQL_DATABASE=wordpress \
-e MYSQL_USER=wordpress \
-e MYSQL_PASSWORD=wordpress \
-v /data/docker_mysql:/var/lib/mysql \
-d mysql:5.7 \
--character-set-server=utf8 --collation-server=utf8_bin
```

wordpress容器命令

```
docker run --name wordpress \
--link mysql \
-e WORDPRESS_DB_HOST="mysql" \
-e WORDPRESS_DB_USER="wordpress" \
-e WORDPRESS_DB_PASSWORD="wordpress" \
-e WORDPRESS_DB_NAME="wordpress" \
-p 80:80 \
-d wordpress
```
