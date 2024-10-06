---
tags:
  - ansible/角色
---
> [!warn]- 编写思路
> 
> 
> 1.先拷贝配置文件到template目录下并重命名为j2
> 2.编写handlers
> 3.编写tasks

> [!run]- 创建角色目录
> 
> 
> ```
> cd /etc/ansible/roles/
> mkdir nfs_server/{tasks,handlers,files,templates,vars} -p
> ```

> [!info]- 编写jinja模版文件
> 
> 
> ```
> [root@m-61 ~]# cat /etc/ansible/roles/nfs_server/templates/exports.j2 
> /data 172.16.1.0/24(rw,sync,all_squash,anonuid=666,anongid=666)
> ```

> [!info]- 编写handlers文件
> 
> 
> ```
> [root@m-61 ~]# cat /etc/ansible/roles/nfs_server/handlers/main.yaml 
> - name: restart nfs 
>   systemd:
>     name: nfs 
>     state: restarted
> ```

> [!info]- 编写主任务文件
> 
> 
> ```
> [root@m-61 ~]# cat /etc/ansible/roles/nfs_server/tasks/main.yaml 
> #1.创建www组和www用户
> - name: create_group
>   group:
>     name: www
>     gid: 666
>     
> #2.创建www用户  
> - name: create_user
>   user:
>     name: www
>     uid: 666
>     group: www
>     create_home: no
>     shell: /sbin/nologin
> 
> #3.创建数据目录并更改授权
> - name: create_data
>   file: 
>     path: "{{ item }}" 
>     state: directory 
>     owner: www
>     group: www
>     mode: '755'
>   loop:
>     - /data/
>     - /backup/
> 
> #4.安装nfs软件
> - name: install_nfs
>   yum:
>     name: nfs-utils 
>     state: latest
> 
> #5.复制配置文件和密码文件
> - name: copy_exports
>   template:
>     src: exports.j2
>     dest: /etc/exports
>   notify:
>     - restart nfs
> 
> #6.启动服务
> - name: start 
>   systemd:
>     name: nfs 
>     state: started
>     enabled: yes
> ```

> [!run]- 编写调用文件
> 
> 
> ```
> [root@m-61 ~]# cat /etc/ansible/nfs_server.yaml 
> - hosts: nfs
>   roles:
>     - nfs_server
> ```


