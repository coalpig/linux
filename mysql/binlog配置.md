

配置参数

```
vim /etc/my.cnf
[mysqld]
#新增加参数
server_id=51
log_bin=/data/mysql_3306/logs/mysql-bin
```

配置完记得要重启服务

```
systemctl restart mysqld
```

查看是否已经生成binlog文件

```
[root@db-51 ~]# ll /data/mysql_3306/logs/mysql-bin.*
-rw-r----- 1 mysql mysql 157 Jan  8 21:19 /data/mysql_3306/logs/mysql-bin.000001
-rw-r----- 1 mysql mysql  34 Jan  8 21:19 /data/mysql_3306/logs/mysql-bin.index
```

查看当前生效的binlog模式

```
SHOW VARIABLES LIKE 'binlog_format';
```
