---
tags:
  - ansible/剧本
---
- ~ 命令行模式

```
ansible nfs_server -m yum -a "name=nfs-utils state=present"

ansible nfs_server -m group -a "name=www gid=1000 state=present"

ansible nfs_server -m user -a "name=www uid=1000 group=www create_home=false shell=/sbin/nologin state=present"

ansible nfs_server -m file -a "path=/data state=directory owner=www group=www"

ansible nfs_server -m copy -a "src=/opt/nfs_server/conf/exports dest=/etc/"

ansible nfs_server -m systemd -a "name=nfs state=started enabled=true"
```

> [!run]- 剧本模式
> 
> 
> ```
> - name: install nfs server
> 
>   hosts: nfs_server
> 
>   tasks:
> 
>   - name: 01-yum
> 
> ​    yum:
> 
> ​      name: nfs-utils
> 
> ​      state: present
> 
> 
> 
>   - name: 02-groupadd
> 
> ​    group:
> 
> ​      name: www
> 
> ​      gid: 1000
> 
> ​      state: present
> 
> 
> 
>   - name: 03-useradd
> 
> ​    user:
> 
> ​      name: www
> 
> ​      uid: 1000
> 
> ​      group: www
> 
> ​      create_home: false
> 
> ​      shell: /sbin/nologin
> 
> ​      state: present
> 
> ​    
> 
>   - name: 04-data
> 
> ​    file:
> 
> ​      path: /data 
> 
> ​      state: directory 
> 
> ​      owner: www 
> 
> ​      group: www
> 
> ​          
> 
>   - name: 05-config
> 
> ​    copy:         
> 
> ​      src: /opt/nfs_server/conf/exports
> 
> ​      dest: /etc/
> 
> 
> 
>   - name: 06-start
> 
> ​    systemd:      
> 
> ​      name: nfs
> 
> ​      state: started 
> 
> ​      enabled: true
> ```
> 

- ~ 模拟执行

ansible-playbook -C nfs_server.yaml

- ~ 真正执行

ansible-playbook nfs_server.yaml
