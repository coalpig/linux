## 1.介绍

```
percona公司研发 
xtrabackup  --> C  C++
innobackupex  --> perl语言
8.0之前，2.4.x 
8.0之后，8.0
物理备份工具，类似于cp文件。
支持：全备和增量备份
pt
```

## 2.安装

```
yum -y install perl perl-devel libaio libaio-devel perl-Time-HiRes perl-DBD-MySQL libev
wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.12/binary/redhat/7/x86_64/percona-xtrabackup-24-2.4.12-1.el7.x86_64.rpm
yum -y localinstall percona-xtrabackup-24-2.4.12-1.el7.x86_64.rpm
```

## 3.全量备份数据

全备命令

```
innobackupex -uroot -p123 /backup/
```

自定义目录名备份

```
innobackupex -uroot -p123 --no-timestamp /backup/full_$(date +%F)
```

查看备份完成的目录

```
[root@db-51 ~]# ll /data/backup/test/2020-09-14_22-06-11/
总用量 12348
-rw-r----- 1 root root      487 9月  14 22:06 backup-my.cnf
drwxr-x--- 2 root root       48 9月  14 22:06 gtdb
-rw-r----- 1 root root    10056 9月  14 22:06 ib_buffer_pool
-rw-r----- 1 root root 12582912 9月  14 22:06 ibdata1
drwxr-x--- 2 root root       52 9月  14 22:06 ku
drwxr-x--- 2 root root       52 9月  14 22:06 linux5
drwxr-x--- 2 root root       76 9月  14 22:06 linux6
drwxr-x--- 2 root root     4096 9月  14 22:06 mysql
drwxr-x--- 2 root root       90 9月  14 22:06 man
drwxr-x--- 2 root root      134 9月  14 22:06 man2
drwxr-x--- 2 root root     8192 9月  14 22:06 performance_schema
drwxr-x--- 2 root root      160 9月  14 22:06 school
drwxr-x--- 2 root root     8192 9月  14 22:06 sys
drwxr-x--- 2 root root       54 9月  14 22:06 test
drwxr-x--- 2 root root      144 9月  14 22:06 world
-rw-r----- 1 root root       63 9月  14 22:06 xtrabackup_binlog_info
-rw-r----- 1 root root      117 9月  14 22:06 xtrabackup_checkpoints
-rw-r----- 1 root root      546 9月  14 22:06 xtrabackup_info
-rw-r----- 1 root root     2560 9月  14 22:06 xtrabackup_logfile
```

相关文件

```
1.xtrabackup_binlog_info
记录binlog位置点， 截取binlog起点位置

2.xtrabackup_checkpoints
from_lsn = 0         # 一般增量备份会关注，一般上次备份的to_lsn的位置
to_lsn = 180881595   # CKPT-LSN 最近的内存数据落地到磁盘上的LSN号
last_lsn = 180881604 # xtrabackup_logfile LSN

3.xtrabackup_info         
备份总览信息

4.xtrabackup_logfile      
备份期间产生的redo变化
```

## 4.全量备份恢复

第0步：模拟删除

```
pkill mysqld 
rm -rf /data/mysql_3306/*
```

第1步: prepare 准备备份阶段

```
innobackupex --apply-log /backup/2024-01-10_14-51-59
```

命令解释：

这条 `innobackupex --apply-log /backup/2024-01-10_14-51-59` 命令是用来处理之前创建的备份，使其准备好用于恢复的一个过程。以下是详细解释：

### 命令功能

- `--apply-log` 是 `innobackupex` 工具的一个选项，用于准备（也称为“重放”）备份。
- 这个过程涉及应用事务日志（redo log）到备份数据中。这意味着它将所有在备份进行时还未提交到数据库文件的事务应用（重放）到备份文件中。

### 过程详解

1. **事务日志重放**：当 `innobackupex` 进行备份时，它同时会复制事务日志。使用 `--apply-log` 时，`innobackupex` 会读取这些日志文件，并将所有从备份开始到备份结束期间的数据库变更应用到备份数据文件中。
2. **数据一致性**：此步骤确保备份数据在恢复时的一致性。没有执行这个步骤，备份数据可能处于不一致的状态，恢复后的数据库可能包含不完整或损坏的数据。
3. **备份准备**：只有在执行了 `--apply-log` 后，备份才被视为“准备好”状态，可以用于恢复操作。

### 使用场景

- 在恢复之前，应总是对备份执行 `--apply-log` 操作，以确保数据的一致性和完整性。
- 在执行增量备份的情况下，`--apply-log` 还可以用来合并基础备份和一系列增量备份，生成一个可直接恢复的完整备份。

这个命令对于数据库的维护和灾难恢复计划是非常关键的，保证了数据可以从任何备份时刻安全、完整地恢复。

第2步: 恢复数据-任选一个方法即可方法1): 使用命令复制全备文件到数据目录

```
innobackupex --copy-back /backup/2024-01-10_14-51-59/
innobackupex --move-back /backup/2024-01-10_14-51-59/
```

方法2): 修改配置文件,数据目录指向备份文件目录

```
[root@db-52 ~]# cat /etc/my.cnf 
[mysqld]
port=3306
user=mysql
basedir=/opt/mysql
#直接修改为备份文件的目录
datadir=/backup/2024-01-10_14-51-59/

#主从复制参数
server_id=51
log_bin=/data/mysql_3306/mysql-bin
```

方法3): 创建备份目录的软链接到数据目录

```
mkdir /backup/2024-01-10_14-51-59/logs
touch /backup/2024-01-10_14-51-59/logs/mysql.err
chown -R mysql:mysql /backup/2024-01-10_14-51-59
ln -s /backup/2024-01-10_14-51-59/ /data/mysql_3306
```

第3步: 小坑-恢复数据后记得更改权限1)备份恢复的时候不会把日志目录一起备份，比如错误日志和Binlog日志，恢复完成后需要手动创建2)恢复后数据目录的用户权限都是root，需要手动更改权限

```
mkdir /data/mysql_3306/logs/
touch /data/mysql_3306/logs/mysql.err
chown -R mysql:mysql /data/mysql_3306
systemctl start mysqld
```

## 5.增量备份数据

### 5.1 介绍

```
自带的功能。
每次增量一般是将最近一次备份作为参照物。
自动读取参照物cat xtrabackup_checkpoints中to_lsn值，与当前CKPT的LSN对比，备份变化过page。
备份期间新的数据变化，通过redo自动备份。
恢复数据时，需要把所有需要的增量合并到FULL中。无法通过增量单独恢复数据，依赖与全备。
```

### 5.2 增量备份演练 FULL(周日)+inc1(周一)+inc2(周二)+inc3(周三)

第1步: 实验数据准备

```
create database xbk charset utf8mb4;
use xbk
create table full (id int);
insert into full values(1),(2),(3);
```

第2步: 模拟周日 23:00 全备

```
innobackupex -uroot -p123 --no-timestamp /backup/full_$(date +%F)
```

第3步: 模拟周一白天数据变化

```
use xbk
create table inc1 (id int);
insert into  inc1 values(1),(2),(3);
```

第4步: 第一次增量备份

```
innobackupex -uroot -p123 --no-timestamp --incremental --incremental-basedir=/backup/full_2022-01-13  /backup/inc1_$(date +%F)
```

第5步: 模拟周二白天数据变化

```
use xbk
create table inc2 (id int);
insert into  inc2 values(1),(2),(3);
```

第6步: 第二次增量备份

```
innobackupex -uroot -p123 -S /tmp/mysql.sock --no-timestamp --incremental --incremental-basedir=/backup/inc1_2022-01-13  /backup/inc2_$(date +%F)
```

第7步: 模拟周三白天数据变化

```
use xbk
create table inc3 (id int);
insert into  inc3 values(1),(2),(3);
```

第8步: 第三次增量备份

```
innobackupex -uroot -p123 -S /tmp/mysql.sock --no-timestamp --incremental --incremental-basedir=/backup/inc2_2022-01-13  /backup/inc3_$(date +%F)
```

第9步: 模拟周四白天数据变化

```
use xbk
create table inc4(id int);
insert into  inc4 values(1),(2),(3);
commit;
```

第10步: 周四下午出现数据损坏。如何恢复到误删除之前。

```
pkill mysqld
rm -rf /data/mysql_3306/*
```

第11步: 截取binlog位置点全备-增量1-增量2-增量3-binlog

备份的数据:全备-增量1-增量2-增量3

binlog起始和终止点起始点:

```
cat /backup/inc3_2022-01-13/xtrabackup_binlog_info 
mysql-bin.000001  21105729
```

终止点:

at 21106154

截取命令:

```
mysqlbinlog --start-position=21105729 --stop-position=21106154 /opt/logs/mysql-bin.000001 > /tmp/backup.sql 
```

第12步: 处理全备,将临时文件整合到磁盘里

```
innobackupex --apply-log --redo-only /backup/full_2022-01-13/
```

第13步: inc1合并到full中，并且prepare

```
innobackupex --apply-log --redo-only --incremental-dir=inc1_2022-01-13 full_2022-01-13
```

检验合并结果:

```
cat /backup/full_2022-01-13/xtrabackup_checkpoints |grep "to_lsn"
cat /backup/inc1_2022-01-13/xtrabackup_checkpoints |grep "to_lsn"
```

第14步: inc2合并到full中，并且prepare

```
innobackupex --apply-log --redo-only --incremental-dir=inc2_2022-01-13 full_2022-01-13
```

检验合并结果:

```
cat /backup/full_2022-01-13/xtrabackup_checkpoints |grep "to_lsn"
cat /backup/inc2_2022-01-13/xtrabackup_checkpoints |grep "to_lsn"
```

第15步: inc3合并到full中，并且prepare

```
innobackupex --apply-log --redo-only --incremental-dir=inc3_2022-01-13 full_2022-01-13
```

检验合并结果:

```
cat /backup/full_2022-01-13/xtrabackup_checkpoints |grep "to_lsn"
cat /backup/inc3_2022-01-13/xtrabackup_checkpoints |grep "to_lsn"
```

第16步:将合并后全备再次prepare

```
innobackupex --apply-log  /backup/full_2022-01-13
```

第17步:恢复数据

```
innobackupex --copy-back /backup/full_2022-01-13
mkdir /data/mysql_3306/logs/
touch /data/mysql_3306/logs/mysql.err
chown -R mysql:mysql /data/mysql_3306
systemctl start mysqld
mysql -uroot -p123 < /backup/backup.sql
```

第18步:检查数据t100wxbk inc1 inc2 inc3 inc4

第19步:立刻做一次全备

```
innobackupex -uroot -p123 -S /tmp/mysql.sock --no-timestamp /backup/full_OK_$(date +%F)
```

