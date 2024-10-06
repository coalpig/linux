---
tags:
  - NFS
---

> [!install]- 安装软件
> 
> 
> ```
> yum install nfs-utils -y
> ```

> [!run]- 通讯测试
> 
> 
> ```
> showmount -e 172.16.1.31
> ```
> 

> [!run]- 挂载测试
> 
> 
> ```
> mkdir /data -p
> mount -t nfs 172.16.1.31:/data /data
> df -h
> echo "man" > /data/man.txt
> cat /data/man.txt
> ```

> [!config]
> 配置开机自动挂载
> 
> ```
> vim /etc/fstab 
> 172.16.1.31:/data     /data     nfs     defaults   0 0
> 
> mount -a
> df -h
> ```

> [!run]- umount卸载测试
> 
> 
> ```
> umount /data/
> ```
