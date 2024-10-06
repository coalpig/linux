# 1.如果配置了MHA停掉MHA--注意！db-53服务器都操作！

```
masterha_stop  --conf=/etc/mha/app1.cnf 
```

## 2.所有数据库清理旧数据--注意！所有MySQL服务器都操作！

```
systemctl stop mysqld
rm -rf /data/mysql_3306/*
rm -rf /data/binlogs/*
mysqld --initialize-insecure --user=mysql --basedir=/opt/mysql --datadir=/data/mysql_3306/
systemctl start mysqld
mysqladmin password 123
```

## 3.主库配置远程复制账号--注意！db-51服务器都操作！

```
mysql -uroot -p123
grant all privileges on *.* to root@'10.0.0.%' identified by '123';
grant replication slave on *.* to repl@'10.0.0.%' identified by '123';
flush privileges;
```

## 3.从库上配置复制信息--注意！db-52和db-53服务器都操作！

```
mysql -uroot -p123
change master to 
master_host='10.0.0.51',
master_user='repl',
master_password='123' ,
MASTER_AUTO_POSITION=1;
start slave;
show slave status\G
set global read_only=1;
set global super_read_only=on;
```

## 4.相关命令

```
第1章 MySQL主从环境搭建
1.db-51主库清理
systemctl stop mysqld
rm -rf /data/mysql_3306/*
rm -rf /data/binlogs/*

cat> /etc/my.cnf <<EOF
[mysqld]
port=3306
user=mysql
basedir=/opt/mysql
datadir=/data/mysql_3306
server_id=51
log_bin=/data/binlogs/mysql-bin
gtid-mode=on
enforce-gtid-consistency=true
log-slave-updates=1
socket=/tmp/mysql.sock

[mysql]
socket=/tmp/mysql.sock

[client]
socket=/tmp/mysql.sock
EOF

mysqld --initialize-insecure --user=mysql --basedir=/opt/mysql --datadir=/data/mysql_3306/
systemctl start mysqld
mysqladmin password 123
mysql -uroot -p123 -e "reset master;"

2.搭建从库
#db52-操作
systemctl stop mysqld
rm -rf /data/mysql_3306/*
rm -rf /data/binlogs/*

cat> /etc/my.cnf <<EOF
[mysqld]
port=3306
user=mysql
basedir=/opt/mysql
datadir=/data/mysql_3306
server_id=52
log_bin=/data/binlogs/mysql-bin
gtid-mode=on
enforce-gtid-consistency=true
log-slave-updates=1
socket=/tmp/mysql.sock

[mysql]
socket=/tmp/mysql.sock

[client]
socket=/tmp/mysql.sock
EOF

mysqld --initialize-insecure --user=mysql --basedir=/opt/mysql --datadir=/data/mysql_3306/
systemctl start mysqld
mysqladmin password 123
mysql -uroot -p123 -e "reset master;"

#db-53操作
cd /opt/
tar zxf mysql-5.7.28-linux-glibc2.12-x86_64.tar.gz -C /opt/
mv mysql-5.7.28-linux-glibc2.12-x86_64 mysql-5.7.28
ln -s mysql-5.7.28 mysql
echo 'PATH=$PATH:/opt/mysql/bin' >> /etc/profile
source /etc/profile
mysql -V
rpm -qa|grep mariadb
yum remove mariadb-libs -y
rm -rf /etc/my.cnf
yum install -y libaio-devel
mkdir  /data/{mysql_3306,binlogs} -p
useradd -s /sbin/nologin -M mysql
chown -R mysql:mysql /data/
chown -R mysql:mysql /opt/mysql*
cat> /etc/my.cnf <<EOF
[mysqld]
port=3306
user=mysql
basedir=/opt/mysql
datadir=/data/mysql_3306
server_id=53
log_bin=/data/binlogs/mysql-bin
gtid-mode=on
enforce-gtid-consistency=true
log-slave-updates=1
socket=/tmp/mysql.sock

[mysql]
socket=/tmp/mysql.sock

[client]
socket=/tmp/mysql.sock
EOF
mysqld --initialize-insecure --user=mysql --basedir=/opt/mysql --datadir=/data/mysql_3306/
cp /opt/mysql/support-files/mysql.server  /etc/init.d/mysqld
chkconfig --add mysqld
systemctl start mysqld
netstat -lntup|grep 3306
mysqladmin password 123
mysql -uroot -p123 -e "reset master;"
```
