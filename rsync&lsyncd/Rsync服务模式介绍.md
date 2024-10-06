---
tags:
  - rsync
---
# 第3章 Rsync服务模式介绍

## 1.rsync命令行模式有哪些问题

1）每次都需要输Linux系统用户的密码

2）目录随便传

## 2.rsync服务模式可以做什么？

1）限制传输的目录，你不需要知道具体的路径

2）不需要知道系统用户密码，可以配置rsync服务专属的密码

## 3.rsync服务模式配置文件解读

```shell
cat > /etc/rsyncd.conf << 'EOF'

uid = www			#用来写入文件的用户

gid = www			#用来写入文件的用户组

port = 873			#端口号

fake super = yes             #启用时，允许在不具有root权限的情况下存储文件的所有权和权限信息。这对于备份操作非常有用。

use chroot = no             #如果设置为**yes**，rsync将在传输开始前改变根目录到模块的路径。这增加了安全性，但在某些配置中可能导致问题。这里设置为**no**。

max connections = 200   #设置同时可以连接到rsync服务器的最大客户端数量。

timeout = 600                #如果在指定的时间（秒）内没有收到任何数据，rsync将断开连接。这里设置为600秒。

ignore errors                  #这个设置会使rsync在遇到某些IO错误时仍然继续运行

read only = false            #指定rsync模块是可读写的。设置为**false**意味着客户端可以上传文件到服务器。

list = false                       #这个设置防止了rsync在没有相应认证的情况下被列出。提高了安全性。

auth users = rsync_backup		#rsync的虚拟账号

secrets file = /etc/rsync.passwd	#rsync的虚拟账号的密码

log file = /var/log/rsyncd.log		#日志存放路径



[backup]			         #模块名称

path = /backup		#模块对应的真实绝对路径



[data]

path = /data

EOF
```
