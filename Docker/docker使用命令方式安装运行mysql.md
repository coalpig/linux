```
docker run --name my_mysql \
-p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=root \
-e MYSQL_DATABASE=xzs \
-e MYSQL_USER=xzs \
-e MYSQL_PASSWORD=xzs \
-v /data/mysql_3306:/var/lib/mysql \
-d mysql:5.7 \
--character-set-server=utf8 --collation-server=utf8_bin

docker cp xzs-mysql.sql b874303a3383:/root
docker exec -it b874303a3383 bash -c "mysql -uxzs -pxzs xzs < /root/xzs-mysql.sql"
```

-v /data/mysql_3306:/var/lib/mysql
验证数据持久化不会因为容器消失而消失

官方的mysql容器启动脚本可以判断是空的数据目录还是已经存在数据。
- 如果是空的数据目录，就按照用户传递的变量初始化数据库
- 如果数据目录已经有数据了，直接使用原来的数据，用户传递的变量失效了


