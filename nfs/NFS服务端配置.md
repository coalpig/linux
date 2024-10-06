---
tags:
  - NFS
---

> [!install]- 安装软件
> 
> 
> ```
>  yum install nfs-utils -y
> ```

> [!config]- 修改配置文件
> 
> 
> 配置文件格式：
> 
> 举例：
> /data 172.16.1.0/24(rw,sync,all_squash)
> 
> 解释：
> NFS共享目录路径  允许NFS客户端访问的IP地址(挂载参数)
> 
> 注意：
> 访问地址和参数之间没有空格
> 
> 配置文件解释：
> 
> 执行 man exports 命令，然后切换到文件结尾，可以快速查看如下样例格式：
> ```
>  rw                              #读写权限
>  ro                               #只读权限
>  root_squash               #当NFS客户端以root管理员访问时，映射为NFS服务器的匿名用户(不常用)
>  no_root_squash         #当NFS客户端以root管理员访问时，映射为NFS服务器的root管理员(不常用)
>  all_squash                  #无论NFS客户端使用什么账户访问，均映射为NFS服务器的匿名用户(常用)
>  no_all_squash            #无论NFS客户端使用什么账户访问，都不进行压缩
>  sync                           #同时将数据写入到内存与硬盘中，保证不丢失数据
>  async                         #优先将数据保存到内存，然后再写入硬盘；这样效率更高，但可能会丢失数据
>  anonuid                     #配置all_squash使用,指定NFS的用户UID,必须存在系统
>  anongid                     #配置all_squash使用,指定NFS的用户GID,必须存在系统
> ```
> 
> 配置命令：
> 
> ```
> cat > /etc/exports << EOF
> /data 172.16.1.0/24(rw,sync,all_squash)
> EOF
> ```
> 

> [!run]- 创建www用户
> 
> 
> ```
> useradd -u 1000 -M -s /sbin/nologin www
> ```

> [!info]- 创建数据目录并授权
> 
> ```
> 
> mkdir /data -p
> chown -R www:www /data/
> ```

> [!systemd]- 启动NFS服务
> 
> 
> ```
> systemctl start nfs-server.service
> ```

> [!test]- 检查服务状态
> 
> 
> ```
> showmount -e 172.16.1.31
> ```

> [!systemd]- 添加开机自启动
> 
> ```
> systemctl enable rpcbind nfs-server
> ```
