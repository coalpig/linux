---
tags:
  - NFS
---

> [!info]- NFS服务故障导致目录卡住
> 
> 
> 故障现象：
> 
> 如果NFS客户端挂载期间，NFS服务端服务停止了服务，会导致客户端与目录或文件相关的操作卡住。
> 
> 问题解决：
> 
> 第一种方法：修复NFS服务端的服务，使其正常工作
> 第二种方法：强制卸载NFS挂载目录
> 

> [!info]- NFS服务故障导致开机卡住
> 
> 
> 故障现象：
> 
> 如果NFS客户端服务器设置了开机自动挂载，但是NFS客户端系统启动的时候NFS服务端并没有提供服务，就会导致开机自检的时候卡在挂载那一步，至少会卡住1分30秒。
> 
> 问题解决：
> 
> 第一种方法：修复NFS服务端的服务，使其正常工作
> 第二种方法：进入单用户模式，注释掉/etc/fstab里的挂载信息，然后重新启动系统
> 

> [!info]- 防火墙阻挡
> 
> 
> 查看nfs端口：
> ```
> rpcinfo -p
> ```
> 
> firewall防火墙配置：
> 
> ```
> firewall-cmd --add-service=nfs --permanent
> firewall-cmd --add-service=mountd --permanent
> firewall-cmd --add-service=rpc-bind --permanent
> firewall-cmd --reload
> ```
> 
> iptables防火墙配置：
> 
> \# 1.启动NFS会开启如下端口：
> ```
> portmapper 端口：111 udp/tcp；
> nfs/nfs_acl 端口：2049 udp/tcp；
> mountd 端口："32768--65535" udp/tcp
> nlockmgr 端口："32768--65535" udp/tcp
> ```
> 系统 RPC服务在 nfs服务启动时默认会给 mountd 和 nlockmgr 动态选取一个随机端口来进行通讯。
> 
> 2.查看nfs端口
>  
> ```
> rpcinfo -p
> ```
> 
> 3.将随机的端口号设置固定:
> ```
> [root@nfs-31 ~]# vim /etc/sysconfig/nfs
> [root@nfs-31 ~]# tail -5 /etc/sysconfig/nfs
> RQUOTAD_PORT=4001
> LOCKD_TCPPORT=4002
> LOCKD_UDPPORT=4002
> MOUNTD_PORT=4003
> STATD_PORT=4004
> ```
> 4.重启nfs和rpc服务
> ```
> systemctl restart rpcbind.service nfs-server.service
> ```
> 
> 5.再次查看端口信息,发现端口号已经固定了
> ```
> rpcinfo -p
> ```
> 
> 6.设置iptables
> ```
> iptables -A INPUT -p tcp -m tcp --dport 111 -j ACCEPT
> iptables -A INPUT -p udp -m udp --dport 111 -j ACCEPT
> iptables -A INPUT -p tcp -m tcp --dport 2049 -j ACCEPT
> iptables -A INPUT -p udp -m udp --dport 2049 -j ACCEPT
> iptables -A INPUT -p tcp -m tcp --dport 4001:4004 -j ACCEPT
> iptables -A INPUT -p udp -m udp --dport 4001:4004 -j ACCEPT
> ```
> 
> 7.最后别忘记保存配置了
