---
tags:
  - ansible/角色
---
> [!info]- 编写思路
> 
> 
> 1.先分析以前写过所有的角色里重复的操作
> 2.把重复的操作内容单独写一个角色，例如：init 
> 3.先备份一份以前写好的角色文件
> 4.精简以前的角色文件，删除重复的内容
> 5.调试，运行，检查

> [!info]- 找出重复的操作
> 
> 
> 1.创建www组和www用户
> 2.创建www用户  
> 3.创建数据目录并更改授权
> 4.安装rsync软件
> 4.安装nfs软件

> [!run]- 创建角色目录
> 
> 
> ```
> cd /etc/ansible/roles/
> mkdir init/{tasks,handlers,files,templates,vars} -p
> ```

3.编写jinja模版文件

4.编写handlers文件


> [!info]- 编写主任务文件
> 
> 
> ```
> [root@m-61 /etc/ansible]# cat /etc/ansible/roles/init/tasks/main.yaml 
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
> - name: install_soft
>   yum:
>     name: "{{ item }}"
>     state: latest
>   loop:
>     - rsync
>     - nfs-utils
> ```
> 