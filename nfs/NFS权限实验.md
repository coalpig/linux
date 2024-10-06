---
tags:
  - NFS
---

> [!info]- root_squash
> 权限实验：root_squash
> 
>> NFS服务端配置
> 
> 第一步：创建data目录并更改权限
> 
> ```
> mkdir /data
> 
> chown -R nfsnobody:nfsnobody /data/
> ```
> 
> 第二步：编写配置文件
> 
> ```
> cat > /etc/exports << 'EOF'
> 
> /data 10.0.0.0/24(rw,root_squash,sync)
> 
> EOF
> ```
> 
> 第三步：启动NFS服务端
> 
> ```
> systemctl start nfs
> 
> systemctl status nfs
> ```
> 第四步：检查
> ```
> showmount -e 10.0.0.31
> ```
> 
>>NFS客户端配置
>
>
> 第一步：安装NFS
> 
> ```
> yum install nfs-utils -y
> ```
> 
> 第二步：创建数据目录
> 
> ```
> mkdir /data
> ```
> 
> 第三步：挂载NFS服务端的数据目录
> 
> ```
> mount -t nfs 10.0.0.31:/data /data
> ```
> 
> 第四步：检查挂载情况
> 
> ```
>  df -h|grep data
> ```
> 第五步：写入测试

> [!info]- all_squash
> 权限实验：all_squash
> 
> NFS服务端和NFS客户端的用户UID和GID统一：
> 
> ```
> Nginx --> www 1000
> 
> NFS Server --> www 1000
> 
> NFS Client --> www 1000
> ```
> 
> >NFS服务端配置：
> 
> 第一步：创建www用户并更改用户
> ```
> groupadd www -g 1000
> 
> useradd www -u 1000 -g 1000 -M -s /sbin/nologin 
> 
> chown -R www:www /data
> ```
> 
> 第二步：修改配置文件
> 
> ```
> cat > /etc/exports << 'EOF'
> 
> /data 10.0.0.0/24(rw,all_squash,sync,anonuid=1000,anongid=1000)
> 
> EOF
> ```
> 
> 第三步：重启服务
> 
> ```
> systemctl restart nfs
> ```
> 
> 第四步：检查
> 
> ```
> showmount -e 10.0.0.31
> ```
> 
> > NFS客户端配置：
> 
> 第零步：卸载已经挂载的目录
> 
> ```
> umount /data
> ```
> 
> 第一步：创建www用户并更改用户
> 
> ```
> groupadd www -g 1000
> 
> useradd www -u 1000 -g 1000 -M -s /sbin/nologin 
> 
> chown -R www:www /data
> ```
> 
> 第二步：挂载
> 
> ```
> mount -t nfs 10.0.0.31:/data /data
> 
> ```
> 第三步：写入测试
> 
> ```
> cd /data
> 
> touch web7.txt
> 
> ll
> ```
> 
> 第四步：写入开机自启动挂载
> 
> ```
> cat /etc/fstab|grep nfs
> 
> 10.0.0.31:/data /data nfs defaults        0 0
> 
>  mount -a
> 
> df -h|grep data
> 
> ```

> [!info]- 多个目录不同权限实验
> 
> 权限实验：多个目录不同权限实验
> 
> > NFS服务端配置：
> 
> ```
> mkdir /data
> 
> mkdir /data1
> 
> mkdir /data2
> 
> chown -R www:www /data*
> 
> cat > /etc/exports << 'EOF'
> 
> /data 10.0.0.0/24(rw,all_squash,sync,anonuid=1000,anongid=1000)
> 
> /data1 10.0.0.7/32(rw,all_squash,sync,anonuid=1000,anongid=1000)
> 
> /data2 10.0.0.7/32(ro,all_squash,sync,anonuid=1000,anongid=1000)
> 
> /data1 10.0.0.8/32(ro,all_squash,sync,anonuid=1000,anongid=1000)
> 
> /data2 10.0.0.8/32(rw,all_squash,sync,anonuid=1000,anongid=1000)
> 
> EOF
> 
> systemctl restart nfs
> 
> showmount -e 10.0.0.31
> ```
> 
> > 客户端配置：
> 
> web-7和web-8服务器相同的操作：
> 
> ```
> mkdir /data
> 
> mkdir /data1
> 
> mkdir /data2
> 
> mount -t nfs 10.0.0.31:/data /data
> 
> mount -t nfs 10.0.0.31:/data1 /data1
> 
> mount -t nfs 10.0.0.31:/data2 /data2
> ```
> 