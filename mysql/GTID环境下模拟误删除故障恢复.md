

## 1.数据准备

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
drop database gtdb;
show master status ;
```

## 2.截取binlog日志

```
mysqlbinlog --skip-gtids --include-gtids='xxx' /data/3306/logs/mysql-bin.000016 > /tmp/gt1.sql
```

