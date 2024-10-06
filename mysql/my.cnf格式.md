```
[mysqld]                     # 服务端标签
user=mysql                   # MySQL内置管理用户
basedir=/data/app/mysql      # 软件目录
datadir=/data/3306/data      # 数据目录
socket=/tmp/mysql.sock       # socket文件生成目录
port=3306                    # 端口号
server_id                    # 主机编号（主从使用）

[mysql]
socket=/tmp/mysql.sock       # mysql 连接数据库自动读取的socket位置

[标签项]
服务端标签： 
[server]        所有服务端的程序
[mysqld]        mysqld 程序运行时读取的配置
[mysqld_safe]   mysqld_safe 程序运行时读取的配置

客户端标签： 
[clinet]    所有本地客户端的程序
[mysql]     mysql命令在本地执行时读取的配置
[mysqldump] mysqldump .....................
```