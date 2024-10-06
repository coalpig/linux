## 1.场景介绍

刚才的简单场景只是在一个binlog之间截取恢复数据，实际工作中可能会更复杂，以下是几个场景：

1）只恢复相关的库表操作

因为binlog是全局记录的，所以所有的库操作都会被记录，但是我们误操作的可能只是其中一个库，那么如何从一堆的Binlog中只提取我们需要恢复的库就成为了关键。

2）跨多个binlog

但是如果操作的数据时间跨度比较大，涉及到了跨多个binlog记录，那么恢复的时候也得从多个Binlog里恢复数据。

## 2.从binlog文件中只恢复指定的库

构造实验数据:

```
1)创建库A
2)创建库B
3)创建A库的表
4)创建B库的表
5)A库的表插入语句
6)B库的表插入语句
7)删除A库
```

理想的恢复情况: 只导出与A库相关的日志

```
1)创建库A
3)创建A库的表
5)A库的表插入语句
7)删除A库
```

从binlog中截取指定的库

mysqlbinlog -d abc mysql-bin.000001 > /tmp/bin.sql

## 3.从多个binlog中恢复数据

操作流程:

```
flush logs;

#mysql-bin.000002 
show master status ;
create database tongdian charset=utf8mb4;
use tongdian 
create table t1 (id int);
flush logs;

#mysql-bin.000003
show master status ;
insert into t1 values(1),(2),(3);
commit;
flush logs;

#mysql-bin.000004
show master status ;
create table t2(id int);
insert into t2 values(1),(2),(3);
commit;
flush logs;

#mysql-bin.000005
show master status ;
insert into t2 values(11),(22),(33);
commit;
drop database tongdian;
```

查看binlog

```
[root@db-52 ~]# ll /data/mysql_3306/mysql-*
-rw-r----- 1 mysql mysql 2259 Jan  8 23:09 /data/mysql_3306/logs/mysql-bin.000001
-rw-r----- 1 mysql mysql  559 Jan  8 23:09 /data/mysql_3306/logs/mysql-bin.000002
-rw-r----- 1 mysql mysql  472 Jan  8 23:09 /data/mysql_3306/logs/mysql-bin.000003
-rw-r----- 1 mysql mysql  642 Jan  8 23:09 /data/mysql_3306/logs/mysql-bin.000004
-rw-r----- 1 mysql mysql  594 Jan  8 23:09 /data/mysql_3306/logs/mysql-bin.000005
-rw-r----- 1 mysql mysql  170 Jan  8 23:09 /data/mysql_3306/logs/mysql-bin.index
```

恢复方法：

方法1：分段截取

```
--start-position    --stop-position 
```

方法2：按时间戳截取

第一步：找到建库的时间点

```
show binlog events in 'mysql-bin.000002';

| mysql-bin.000002 | 219 | Query          |        52 |         341 | create database tongdian charset=utf8mb4 |
```

第二步：通过位置点过滤出时间戳

```
[root@db-52 ~]# mysqlbinlog /data/mysql_3306/logs/mysql-bin.000002 |grep -A 1 '^\#\ at\ 219'
# at 219
#240108 23:09:39 server id 52  end_log_pos 341 CRC32 0x2f596607 	Query	thread_id=8	exec_time=0	error_code=0
```

第三步：找出删库中止点

```
mysql> show binlog events in 'mysql-bin.000005';
+------------------+-----+----------------+-----------+-------------+---------------------------------------+
| Log_name         | Pos | Event_type     | Server_id | End_log_pos | Info                                  |
+------------------+-----+----------------+-----------+-------------+---------------------------------------+
| mysql-bin.000005 |   4 | Format_desc    |        52 |         123 | Server ver: 5.7.28-log, Binlog ver: 4 |
| mysql-bin.000005 | 123 | Previous_gtids |        52 |         154 |                                       |
| mysql-bin.000005 | 154 | Anonymous_Gtid |        52 |         219 | SET @@SESSION.GTID_NEXT= 'ANONYMOUS'  |
| mysql-bin.000005 | 219 | Query          |        52 |         295 | BEGIN                                 |
| mysql-bin.000005 | 295 | Table_map      |        52 |         344 | table_id: 112 (tongdian.t2)           |
| mysql-bin.000005 | 344 | Write_rows     |        52 |         394 | table_id: 112 flags: STMT_END_F       |
| mysql-bin.000005 | 394 | Xid            |        52 |         425 | COMMIT /* xid=87 */                   |
| mysql-bin.000005 | 425 | Anonymous_Gtid |        52 |         490 | SET @@SESSION.GTID_NEXT= 'ANONYMOUS'  |
| mysql-bin.000005 | 490 | Query          |        52 |         594 | drop database tongdian                |
+------------------+-----+----------------+-----------+-------------+---------------------------------------+
```

第四步：根据位置点找出时间戳

```
[root@db-52 ~]# mysqlbinlog /data/mysql_3306/logs/mysql-bin.000005 |grep -A 1 '^\#\ at\ 490'
# at 490
#240108 23:09:40 server id 52  end_log_pos 594 CRC32 0x4a74e87a   Query thread_id=8 exec_time=0 error_code=0
```


第五步：根据时间戳截取日志范围

```
mysqlbinlog  --start-datetime="2024-01-08 23:09:39"  --stop-datetime="2024-01-08 23:09:40" mysql-bin.000002 mysql-bin.000003 mysql-bin.000004 mysql-bin.000005 >/tmp/data.sql
```

## 4.疑问点

恢复的时候,binlog会不会记录?

```
答案是:会

正确的步骤:
恢复前: 临时关闭binlog记录
恢复后: 再开启

临时关闭方法:
set sql_log_bin=0;
source /tmp/bin.sql;
set sql_log_bin=1;
```

如果同一个库下删了一个表?

全备+binlog --> 测试服务器 --> 导出删除的表 --> 导入到生产服务器

binlog中100w个事件，怎么快速找到drop

通过三剑客命令grep过滤关键词drop database

假如删除的库，建库是在2年前操作的，binlog已经清理了，这种情况怎么办？


binlog -d 过滤字符存在的问题

如果建表中是先use库再create表

而不是create库.表，那么会出现无法过滤建表语句

如果删除了库
可以直接找出建库建表语句
然后截取建表和删除库直接的binlog


根据时间戳截取日志范围
