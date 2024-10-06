

## 1.前提说明

创建或导入数据库之前就配置并开启了binlog，否则前期修改的数据就记录不到了

## 2.故障演练流程

```
1.开启binlog记录
2.创建数据库
3.创建表
4.写入数据
5.误删除数据或批量修改
6.分析binlog日志
7.截取binlog数据
8.通过binlog恢复
9.检查数据是否已经恢复
```

## 3.故障操作流程

1）开启binlog记录

```
[root@db-51 ~]# cat /etc/my.cnf 
[mysqld]
port=3306
user=mysql
basedir=/opt/mysql
datadir=/data/mysql_3306

#binlog参数
server_id=51
log_bin=/data/mysql_3306/logs/mysql-bin
```

2）创建数据库

```
create database abc;
```

3）创建表

```
use abc;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(10) NOT NULL COMMENT 'name',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

4）写入数据

```
insert into user(name) values ('user1');
insert into user(name) values ('user2');
insert into user(name) values ('user3');
```

5）误删除数据或批量修改

```
drop database abc;
```

## 4.恢复流程

1）恢复思路

先洗把脸，看看从卫生间跳下去会不会摔断腿，如果超过3层，建议别跳了

binlog还在不在

binlog是否完整

如何找到要恢复的起点和终点

如何截取相应的Binlog

汲取后的binlog如何恢复

恢复后如何检查数据是否完整

2）第一步：查看当前处于什么哪个binlog：

```
mysql> show master status;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000001 |     1133 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)
```

3）第二步：找到binlog起点

```
mysql>  show binlog events in 'mysql-bin.000001';
...
| mysql-bin.000001 |  219 | Query          |        52 |         316 | create database abc  
...
```

4）第三步：找到终止位置点

```
...
| mysql-bin.000001 | 1038 | Query          |        52 |        1133 | drop database abc 
...
```

5）截取binlog

```
mysqlbinlog --start-position=219 --stop-position=1038 /data/mysql_3306/logs/mysql-bin.000001 > /tmp/backup.sql
```

6）查看恢复的binlog

注意查看是否包含drop语句

```
[root@db-52 ~]# grep "drop" /tmp/backup.sql 
```

7）恢复数据

```
[root@db-52 ~]# mysql -uroot -p123 < /tmp/backup.sql
```

8）检查数据是否恢复正常

```
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| abc              |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.00 sec)

mysql> select * from abc.user;
+----+-------+-----+
| id | name  | age |
+----+-------+-----+
|  1 | user1 |  21 |
|  2 | user2 |  22 |
|  3 | user3 |  23 |
+----+-------+-----+
3 rows in set (0.00 sec)
```
