

## 1.配置读写组编号

1）查询分组信息

```
mysql -uadmin -padmin .0.0.1 -P6032
select * from mysql_replication_hostgroups;
```

2）写入分组

```
mysql -uadmin -padmin -h127.0.0.1 -P6032
insert into mysql_replication_hostgroups
(writer_hostgroup, reader_hostgroup, comment)
values (10,20,'abc');
```

3）再次查看

```
mysql -uadmin -padmin -h127.0.0.1 -P6032
mysql> select * from mysql_replication_hostgroups;
+------------------+------------------+------------+---------+
| writer_hostgroup | reader_hostgroup | check_type | comment |
+------------------+------------------+------------+---------+
| 10               | 20               | read_only  | abc   |
+------------------+------------------+------------+---------+
1 row in set (0.00 sec)
```

4）生效配置

```
load mysql servers to runtime;
save mysql servers to disk;
```

命令解释：

```
load 立刻生效
save 保存到磁盘
```

5）check_type字段说明

```
ProxySQL会根据数据库的read_only的值对服务器进行分组
read_only=0的会被分到10号的writer组
read_only=1的会被分到20号的reader组
```

## 2.添加主机到PorxySQL

1）添加主机到读写组

```
mysql -uadmin -padmin -h127.0.0.1 -P6032
insert into mysql_servers(hostgroup_id,hostname,port) values
(10,'10.0.0.51',3306);
insert into mysql_servers(hostgroup_id,hostname,port) values
(20,'10.0.0.52',3306);
insert into mysql_servers(hostgroup_id,hostname,port) values
(20,'10.0.0.53',3306);
```

2）保存配置

```
load mysql servers to runtime;
save mysql servers to disk;
```

3）检查

```
select * from mysql_servers;
```

## 3.MySQL主库创建监控用户

```
grant replication client on *.* to monitor@'%' identified by '123';
select user,host from mysql.user;
```

## 4.ProxySQL修改variables表：

```
mysql -uadmin -padmin -h127.0.0.1 -P6032
set mysql-monitor_username='monitor';
set mysql-monitor_password='123';
```

生效配置

```
load mysql variables to runtime;
save mysql variables to disk;
```

## 5.ProxySQL查询监控日志

```
mysql -uadmin -padmin -h127.0.0.1 -P6032
select * from mysql_server_connect_log;
select * from mysql_server_ping_log;
select * from mysql_server_read_only_log;
select * from mysql_server_replication_lag_log;
```

## 6.MySQL主库配置应用用户

```
create user admin_user@'%' identified with mysql_native_password by 'admin_user';
grant all on *.* to admin_user@'%';
```

## 7.ProxySQL配置应用用户

```
mysql -uadmin -padmin -h127.0.0.1 -P6032
insert into mysql_users(username,password,default_hostgroup)
values('admin_user','admin_user',10);
select * from mysql_users\G
```

应用配置

```
load mysql users to runtime;
save mysql users to disk;
```

## 8.ProxySQL配置读写规则

```
mysql -uadmin -padmin -h127.0.0.1 -P6032
insert into
mysql_query_rules(rule_id,active,match_pattern,destination_hostgroup,apply)
values(1,1,'^select.*for update$',10,1);

insert into
mysql_query_rules(rule_id,active,match_pattern,destination_hostgroup,apply)
values(2,1,'^select',20,1);
```

应用配置

```
load mysql query rules to runtime;
save mysql query rules to disk;
```

## 9.测试

```
mysql -uadmin_user -padmin_user -h10.0.0.51 -P6033 -e 'select@@server_id;'
mysql -uadmin_user -padmin_user -h10.0.0.52 -P6033 -e 'select@@server_id;'
mysql -uadmin_user -padmin_user -h10.0.0.53 -P6033 -e 'select@@server_id;'

mysql -uadmin_user -padmin_user -h10.0.0.51 -P6033 -e 'begin;select@@server_id;commit;'
mysql -uadmin_user -padmin_user -h10.0.0.52 -P6033 -e 'begin;select@@server_id;commit;'
mysql -uadmin_user -padmin_user -h10.0.0.53 -P6033 -e 'begin;select@@server_id;commit;'
```