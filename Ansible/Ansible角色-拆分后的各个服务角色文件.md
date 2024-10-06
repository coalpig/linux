---
tags:
  - ansible/角色
---

> [!run]- 拆分后的rsync角色
> 
> 
> ```
> [root@m-61 ~]# cat /etc/ansible/roles/rsync_server/tasks/main.yaml 
> #1.复制配置文件和密码文件
> - name: copy pwd&conf
>   copy:
>     src: "{{ item.src }}"
>     dest: /etc/
>     mode: "{{ item.mode }}"
>   notify:
>     - restart rsyncd
>   loop:
>     - { src: rsyncd.conf,  mode: '644'}
>     - { src: rsync.passwd, mode: '600'}
> 
> #2.启动服务
> - name: start 
>   systemd:
>     name: rsyncd
>     state: started
>     enabled: yes
> ```
> 

> [!run]- 拆分后的nfs角色
> 
> 
> ```
> [root@m-61 ~]# cat /etc/ansible/roles/nfs_server/tasks/main.yaml 
> #1.复制配置文件和密码文件
> - name: copy_exports
>   template:
>     src: exports.j2
>     dest: /etc/exports
>   notify:
>     - restart nfs
> 
> #2.启动服务
> - name: start 
>   systemd:
>     name: nfs 
>     state: started
>     enabled: yes
> ```

拆分后的lsyncd角色



> [!run]- 调用文件
> 
> ```
> ###rsync
> 
> [root@m-61 ~]# cat /etc/ansible/rsync_server.yaml 
> - hosts: rsync_server 
>   roles:
>     - init
>     - rsync_server
> 
> ###nfs
> 
> [root@m-61 ~]# cat /etc/ansible/nfs_server.yaml 
> - hosts: nfs
>   roles:
>     - init
>     - nfs_server
> ```








