## 1.MySQL多实例介绍

多实例是指一台服务器上运行多个Mysql实例  
每个实例可以拥有自己的配置文件和独立的数据目录  
每个实例可以单独的被管理，比如启动，关闭，登陆等操作

## 2.创建数据目录并更改授权

```
mkdir -p /data/mysql_3307/
mkdir -p /data/mysql_3308/
chown -R mysql.mysql /data/
```

## 3.初始化多实例数据

```
mysqld --initialize-insecure --user=mysql --basedir=/opt/mysql --datadir=/data/mysql_3307/
mysqld --initialize-insecure --user=mysql --basedir=/opt/mysql --datadir=/data/mysql_3308/
```

## 4.创建配置文件

```
cat > /data/mysql_3307/my.cnf <<EOF
[mysqld]
basedir=/opt/mysql/
datadir=/data/mysql_3307/
socket=/data/mysql_3307/mysql.sock
log_error=/data/mysql_3307/mysql.log
port=3307
EOF

cat > /data/mysql_3308/my.cnf <<EOF
[mysqld]
basedir=/opt/mysql/
datadir=/data/mysql_3308/
socket=/data/mysql_3308/mysql.sock
log_error=/data/mysql_3308/mysql.log
port=3308
EOF
```

## 5.创建多实例启动脚本

```
cat >/etc/systemd/system/mysqld_3307.service <<EOF
[Unit]
Description=MySQL Server
Documentation=man:mysqld(8)
Documentation=http://dev.mysql.com/doc/refman/en/using-systemd.html
After=network.target
After=syslog.target
[Install]
WantedBy=multi-user.target
[Service]
User=mysql
Group=mysql
ExecStart=/opt/mysql/bin/mysqld --defaults-file=/data/mysql_3307/my.cnf
LimitNOFILE = 5000
EOF

cat >/etc/systemd/system/mysqld_3308.service <<EOF
[Unit]
Description=MySQL Server
Documentation=man:mysqld(8)
Documentation=http://dev.mysql.com/doc/refman/en/using-systemd.html
After=network.target
After=syslog.target
[Install]
WantedBy=multi-user.target
[Service]
User=mysql
Group=mysql
ExecStart=/opt/mysql/bin/mysqld --defaults-file=/data/mysql_3308/my.cnf
LimitNOFILE = 5000
EOF
```

## 6.启动多实例

```
systemctl daemon-reload 
systemctl start mysqld_3307.service
systemctl start mysqld_3308.service
```

## 7.检查多实例

```
[root@db-51 ~]# netstat -lntup|grep mysqld
tcp6       0      0 :::3307                 :::*                    LISTEN      17019/mysqld        
tcp6       0      0 :::3308                 :::*                    LISTEN      17053/mysqld
```

## 8.多实例创建密码

```
mysqladmin -S /data/mysql_3307/mysql.sock password 
mysqladmin -S /data/mysql_3308/mysql.sock password
```

## 9.登陆多实例

```
mysql -S /data/mysql_3307/mysql.sock -uroot -p123456
mysql -S /data/mysql_3308/mysql.sock -uroot -p123456
```