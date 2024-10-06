```
1.下载软件
https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.28-linux-glibc2.12-x86_64.tar.gz

2.创建目录
mkdir -p /data/mysql_3306/

3.下载并解压软件
tar zxf mysql-5.7.28-linux-glibc2.12-x86_64.tar.gz -C /opt/
mv /opt/mysql-5.7.28-linux-glibc2.12-x86_64 /opt/mysql-5.7.28
ln -s /opt/mysql-5.7.28 /opt/mysql

# 4.写入环境变量
sudo echo 'export PATH=$PATH:/opt/mysql/bin' >> /etc/profile
sudo source /etc/profile
mysql -V

5.清除遗留环境
rpm -qa|grep mariadb
yum remove mariadb-libs -y
rm -rf /etc/my.cnf

6.安装mysql依赖包
yum install -y libaio-devel

7.创建mysql普通用户并授权
useradd -s /sbin/nologin -M mysql
chown -R mysql:mysql /data/mysql_3306
chown -R mysql:mysql /opt/mysql*

8.初始化数据库
注意：初始化的时候，数据目录必须为空
mysqld --initialize-insecure --user=mysql --basedir=/opt/mysql --datadir=/data/mysql_3306/

9.编辑mysql配置文件
cat> /etc/my.cnf <<EOF
[mysqld]
port=3306
user=mysql
basedir=/opt/mysql
datadir=/data/mysql_3306
EOF

10.准备启动脚本并启动数据库
脚本启动：
cp /opt/mysql/support-files/mysql.server  /etc/init.d/mysqld
chkconfig --add mysqld
systemctl start mysqld
netstat -lntup|grep 3306

命令启动：
mysqld_safe
mysqld
```