思路
使用Linux的root权限，修改MySQL的配置文件
跳过账号密码检查的流程 --> 无密码登录
无密码登录后修改密码
修改密码后将无密码登录的配置修改回来

要注意!!!!!!!!
需要关闭远程端口监听

```
打开MySQL的配置文件my.cnf。这个文件通常位于/etc/my.cnf或者/etc/mysql/my.cnf。

在[mysqld]部分添加以下配置项以禁用网络连接：

skip-networking
```
配置文件
```
[mysqld]
#port = 3306
```

防止引发安全问题

2.先停止MySQL
```
systemctl stop mysqld
```

3.命令行启动跳过安全检查
```
mysqld_safe --skip-grant-tables
```

4.新开一个窗口无密码登录
```
mysql
```

5.修改密码
```
UPDATE mysql.user SET authentication_string=PASSWORD("root") WHERE user='root' and host='localhost';
```

6.停止无密码登录状态的mysql
```
mysql> shutdown;
```

7.正常启动mysql
```
systemctl start mysqld
```

8.使用密码验证
```
mysql -uroot -proot
```