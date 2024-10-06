---
tags:
  - java微架构
---
>项目地址

https://gitee.com/mindskip/xzs-mysql/tree/master


>重要配置解释



>MySQL 8.0安装部署

```plain
mkdir -p /data/soft
mkdir -p /data/mysql_3306/

tar -xf mysql-8.0.37-linux-glibc2.12-x86_64.tar.xz -C /opt/
mv /opt/mysql-8.0.37-linux-glibc2.12-x86_64 /opt/mysql-8.0.37
ln -s /opt/mysql-8.0.37 /opt/mysql
echo 'export PATH=$PATH:/opt/mysql/bin' >>/etc/profile
source /etc/profile
mysql -V

rpm -qa|grep mariadb
yum remove mariadb-libs -y
rm -rf /etc/my.cnf

yum install -y libaio-devel
useradd -s /sbin/nologin -M mysql
chown -R mysql.mysql /data/
chown -R mysql.mysql /opt/mysql*

cat> /etc/my.cnf << EOF
[mysqld]
port=3306
user=mysql
basedir=/opt/mysql
datadir=/data/mysql_3306
default_authentication_plugin = mysql_native_password
EOF

mysqld --initialize-insecure --user=mysql --basedir=/opt/mysql --datadir=/data/mysql_3306/

cp /opt/mysql/support-files/mysql.server  /etc/init.d/mysqld
chkconfig --add mysqld
systemctl start mysqld

netstat -lntup|grep 3306

mysqladmin password 123

mysql -uroot -p123 -e "create user 'root'@'%' identified by 'root';"
mysql -uroot -p123 -e "grant all privileges on *.* to 'root'@'%';"
```

>导入项目的SQL文件

```plain
unzip xzs-sql-v3.9.0.zip
mysql -uroot -p123 -e "create database xzs;"
mysql -uroot -p123 -e "show databases;"
mysql -uroot -p123 xzs < xzs-mysql.sql
```

>修改后端源码的MySQL连接信息

```plain
vim /xzs-mysql-master/source/xzs/src/main/resources/application-prod.yml
logging:
  path: /usr/log/xzs/

spring:
  datasource:
    url: jdbc:mysql://10.0.0.41:3306/xzs?useSSL=false&useUnicode=true&serverTimezone=Asia/Shanghai&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&allowMultiQueries=true
    username: root
    password: root
    driver-class-name: com.mysql.cj.jdbc.Driver
```

>编译后端代码

```plain
cd /xzs-mysql-master/source/xzs/
mvn clean package
```

>>构建后的jar包运行

>构建机器发送到web服务器

```plain
scp target/xzs-3.9.0.jar 10.0.0.7:/opt/
```

>在web服务器上执行

```plain
cd /opt/
java -Duser.timezone=Asia/Shanghai -jar -Dspring.profiles.active=prod  xzs-3.9.0.jar
```

>使用默认账号密码登录页面

```plain
10.0.0.7/admin/
admin/123456

10.0.0.8/student/
student/123456
```
