## 1.什么是事务

原子性 一致性 隔离性 持久性

## 2.手动提交事务演示

手动开启事务并提交：

```
begin;
insert into user(name) values("user1");
insert into user(name) values("user2");
insert into user(name) values("user3");
commit;
```

手动开启事务并回滚：

```
begin;
insert into user(name) values("user1");
insert into user(name) values("user2");
insert into user(name) values("user3");
rollback;
```

## 3.什么是GTID

全局事务ID

对每个事务，进行单独编号。连续不断进行增长。

表示方法：server_uuid:N

## 4.手动提交事务和GTID的关系

```
手动执行事务与是否开启GTID（全局事务标识符）在MySQL中并没有直接的关系。这两个概念是相对独立的，但都与事务处理有关。

手动执行事务:
手动执行事务涉及显式地使用BEGIN或START TRANSACTION来开启一个事务，然后执行一系列的数据库操作，最后通过COMMIT来提交事务，或使用ROLLBACK来撤销事务。
这个过程是独立于GTID的。无论是否启用GTID，都可以在MySQL中手动执行事务。

GTID（全局事务标识符）:
GTID是MySQL在复制过程中用于标识事务的一种机制。每个事务都会被分配一个唯一的标识符，这使得复制过程中的事务管理更加简单和可靠。
启用GTID的主要优势在于它提高了主从复制和故障转移的易用性和一致性。它确保了即使在复杂的复制拓扑中，每个事务也都是唯一且一致的。

因此，手动执行事务是一种独立于复制机制的数据库操作方法，而GTID主要用于复制环境中事务的追踪和同步。即使在启用GTID的系统中，手动执行事务的方式不会改变，也不会受到GTID设置的影响。相反，GTID的存在可以帮助保证在复制过程中事务的一致性和完整性。
```

## 5.GTID配置

查看参数

```
show variables like '%GTID%';
```

设置参数

```
vim /etc/my.cnf 
gtid_mode=ON                  #开关
enforce_gtid_consistency=ON   #强制GTID一致性
log_slave_updates=ON          #强制从库更新binlog
```

建议： 5.7版本以后，都开启GTID。最好是搭建环境就开启。

## 6.模拟环境

```
create database gtdb charset utf8mb4;
show master status ;
use gtdb;
create table t1(id int);
show master status ;
begin;
insert into t1 values(1);
insert into t1 values(2);
insert into t1 values(3);
commit;
show master status ;
```

## 7.通过GTID方式截取日志

以下截取方式会出现问题，为什么？

```
mysqlbinlog --include-gtids='202628e9-9265-11ea-b4a0-000c29248f69:1-3' /data/3306/logs/mysql-bin.000016 >/tmp/gt.sql
```

答案是gtid有“幂等性”检查。GTID的生成，通过Set gtid_next命令实现的。例如： SET @@SESSION.GTID_NEXT= '202628e9-9265-11ea-b4a0-000c29248f69:1'执行Set命令时，自动检查当前系统是否包含这个GTID信息，如果有就跳过。

正确的截取方式:

```
mysqlbinlog --skip-gtids --include-gtids='202628e9-9265-11ea-b4a0-000c29248f69:1-3' /data/3306/logs/mysql-bin.000016 >/tmp/gt1.sql
```

## 8.拓展使用

跳过指定的GTID:

```
mysqlbinlog --skip-gtids --include-gtids='202628e9-9265-11ea-b4a0-000c29248f69:1-10' --exclude-gtids='202628e9-9265-11ea-b4a0-000c29248f69:5'
```

跨文件截取: bin001 bin002 bin003

```
mysqlbinlog --skip-gtids --include-gtids='202628e9-9265-11ea-b4a0-000c29248f69:1-10'  bin001 bin002  bin003
```
