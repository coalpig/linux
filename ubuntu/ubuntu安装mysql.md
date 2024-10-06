

```

#下载软件
https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.28-linux-glibc2.12-x86_64.tar.gz

#创建目录
sudo mkdir -p /data/mysql_3306/

#下载并解压软件
tar zxf mysql-5.7.28-linux-glibc2.12-x86_64.tar.gz -C /opt/
mv /opt/mysql-5.7.28-linux-glibc2.12-x86_64 /opt/mysql-5.7.28
ln -s /opt/mysql-5.7.28 /opt/mysql



#写入环境变量
sudo echo 'export PATH=$PATH:/opt/mysql/bin' >> /etc/profile
sudo source /etc/profile
mysql -V
安装依赖


#创建mysql普通用户并授权
sudo useradd -s /sbin/nologin -M mysql
sudo chown -R mysql:mysql /data/mysql_3306
sudo chown -R mysql:mysql /opt/mysql*

#初始化数据库
注意：初始化的时候，数据目录必须为空
mysqld --initialize-insecure --user=mysql --basedir=/opt/mysql --datadir=/data/mysql_3306/

#编辑mysql配置文件
cat> /etc/my.cnf << EOF
[mysqld]
port=3306
user=mysql
basedir=/opt/mysql
datadir=/data/mysql_3306
EOF

#mysql安装5.7出现报错问题

#当初始化失败的时候可以执行以下命令
sudo ln -s /usr/lib/x86_64-linux-gnu/libncursesw.so.6 /usr/lib/x86_64-linux-gnu/libncurses.so.5


sudo ln -s /usr/lib/x86_64-linux-gnu/libncursesw.so.6 /usr/lib/x86_64-linux-gnu/libtinfo.so.5


curl -O http://launchpadlibrarian.net/646633572/libaio1_0.3.113-4_amd64.deb

sudo dpkg -i libaio1_0.3.113-4_amd64.deb 


#脚本启动：
cp /opt/mysql/support-files/mysql.server  /etc/init.d/mysqld
chkconfig --add mysqld
systemctl start mysqld
netstat -lntup|grep 3306

#命令启动：
mysqld_safe
mysqld



```
