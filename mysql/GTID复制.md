

## 1.GITD复制介绍

```
功能：主从之间自动校验GTID一致性: 主库binlog，从库binlog ，relay-log 

没有备份：
自动从主库的第一个gtid对应的pos号开始复制

有备份：    
SET @@GLOBAL.GTID_PURGED='2386f449-98a0-11ea-993c-000c298e182d:1-10';
从库会自动从第11个gtid开始复制。
```

## 2.清理环境

```
pkill mysqld  
rm -rf /data/mysql_3306/* 
rm -rf /binlog/* 
mkdir /binlog/
```

## 3.准备配置文件

db01配置

```
cat > /etc/my.cnf <<EOF
[mysqld]
user=mysql
datadir=/data/mysql_3306
basedir=/opt/mysql/
socket=/tmp/mysql.sock
port=3306
log_error=/var/log/mysql/mysql.err
server_id=51
log_bin=/binlog/mysql-bin
autocommit=0
binlog_format=row
gtid-mode=on
enforce-gtid-consistency=true
log-slave-updates=1

[mysql]
socket=/tmp/mysql.sock

[client]
socket=/tmp/mysql.sock
EOF
```

db02配置

```
cat > /etc/my.cnf <<EOF
[mysqld]
user=mysql
datadir=/data/mysql_3306
basedir=/opt/mysql/
socket=/tmp/mysql.sock
port=3306
log_error=/var/log/mysql/mysql.err
server_id=52
autocommit=0
gtid-mode=on
enforce-gtid-consistency=true
log-slave-updates=1

[mysql]
socket=/tmp/mysql.sock

[client]
socket=/tmp/mysql.sock
EOF
```

## 4.初始化数据

```
mysqld --initialize-insecure --user=mysql --basedir=/opt/mysql --datadir=/data/mysql_3306/
```

## 5.启动数据库

```
/etc/init.d/mysqld start
```

## 6.创建用户

```
grant replication slave on *.* to repl@'10.0.0.%' identified by '123';
```

## 7.构建主从

52和53操作:

```
change master to 
master_host='10.0.0.51',
master_user='repl',
master_password='123' ,
MASTER_AUTO_POSITION=1;
start slave;
```

