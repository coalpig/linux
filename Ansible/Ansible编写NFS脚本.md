---
tags:
  - ansible/基础
---

- ~ 编写NFS安装服务

```
ansible nfs_server -m yum -a "name=nfs-utils state=present"

ansible nfs_server -m group -a "name=www gid=1000 state=present"

ansible nfs_server -m user -a "name=www uid=1000 group=www create_home=false shell=/sbin/nologin state=present"

ansible nfs_server -m file -a "path=/data state=directory owner=www group=www"

ansible nfs_server -m copy -a "src=exports dest=/etc/"

ansible nfs_server -m systemd -a "name=nfs state=started enabled=true"

ansible nfs_server -m shell -a "showmount -e 172.16.1.31"

ansible web -m yum -a "name=nfs-utils state=present"

ansible web -m group -a "name=www gid=1000 state=present"

ansible web -m user -a "name=www uid=1000 group=www create_home=false shell=/sbin/nologin state=present"

ansible web -m file -a "path=/data state=directory owner=www group=www"

ansible web -m mount -a "src=172.16.1.31:/data path=/data state=mounted fstype=nfs"
```