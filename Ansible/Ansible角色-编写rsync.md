---
tags:
  - ansible/角色
---
> [!info]- 编写思路
> 
> 
> 1.先写好剧本
> 2.创建角色目录
> 3.拷贝需要发送的文件到指定目录
> 4.拆分剧本

> [!run]- 编写剧本
> 
> 
> ```
> - hosts: backup
>   vars:
>     user_id: '666'
>     rsync_user: 'www'
> 
>   tasks:
>   #1.创建www组和www用户
>   - name: 01-create_group
>     group:
>       name: "{{ rsync_user }}"
>       gid: "{{ user_id }}"
>       
>   #2.创建www用户  
>   - name: 02-create_user
>     user:
>       name: "{{ rsync_user }}"
>       uid: "{{ user_id }}"
>       group: "{{ rsync_user }}"
>       create_home: no
>       shell: /sbin/nologin
>   
>   #3.创建数据目录并更改授权
>   - name: 03-create_data
>     file: 
>       path: "{{ item }}" 
>       state: directory 
>       owner: "{{ rsync_user }}" 
>       group: "{{ rsync_user }}" 
>       mode: '755'
>     loop:
>       - /data/
>       - /backup/
> 
>   #4.安装rsync软件
>   - name: 04-install_rsync
>     yum:
>       name: rsync
>       state: latest
> 
>   #5.复制配置文件和密码文件
>   - name: 05-copy pwd&conf
>     copy:
>       src: "{{ item.src }}"
>       dest: /etc/
>       mode: "{{ item.mode }}"
>     notify:
>       - restart rsyncd
>     loop:
>       - { src: /root/script/rsync/rsyncd.conf,  mode: '644'}
>       - { src: /root/script/rsync/rsync.passwd, mode: '600'}
>   
>   #6.启动服务
>   - name: 06-start 
>     systemd:
>       name: rsyncd
>       state: started
>       enabled: yes
>       
>   #7.重启服务
>   handlers:
>     - name: restart rsyncd
>       systemd:
>         name: rsyncd
>         state: restarted
> ```
> 

> [!run]- 创建角色目录
> 
> 
> ```
> [root@m-61 ~]# cd /etc/ansible/roles/
> [root@m-61 /etc/ansible/roles]# mkdir rsync_server/{tasks,handlers,files,templates,vars} -p
> [root@m-61 /etc/ansible/roles]# tree rsync_server/
> rsync_server/
> ├── files
> ├── handlers
> ├── tasks
> ├── templates
> └── vars
> ```

> [!run]- 把剧本复制到tasks目录
> 
> 
> ```
> ├── tasks
> │   └── main.yaml
> ```

> [!run]- 把配置文件复制到file目录
> 
> 
> ```
> cp script/rsync/* /etc/ansible/roles/rsync_server/files/
> ```

> [!run ]- 拆分handlers
> 
> 
> ```
> [root@m-61 ~]# cat /etc/ansible/roles/rsync_server/handlers/main.yaml 
> - name: restart rsyncd
>   systemd:
>     name: rsyncd
>     state: restarted
> ```

> [!run]- 拆分vars
> 
> 
> ```
> [root@m-61 ~]# cat /etc/ansible/roles/rsync_server/vars/main.yaml 
> user_id: '666'
> rsync_user: 'www'
> ```

> [!run]- 精简tasks任务文件
> 
> ```
> 
> [root@m-61 ~]# cat /etc/ansible/roles/rsync_server/tasks/main.yaml 
> #1.创建www组和www用户
> - name: 01-create_group
>   group:
>     name: "{{ rsync_user }}"
>     gid: "{{ user_id }}"
>     
> #2.创建www用户  
> - name: 02-create_user
>   user:
>     name: "{{ rsync_user }}"
>     uid: "{{ user_id }}"
>     group: "{{ rsync_user }}"
>     create_home: no
>     shell: /sbin/nologin
> 
> #3.创建数据目录并更改授权
> - name: 03-create_data
>   file: 
>     path: "{{ item }}" 
>     state: directory 
>     owner: "{{ rsync_user }}" 
>     group: "{{ rsync_user }}" 
>     mode: '755'
>   loop:
>     - /data/
>     - /backup/
> 
> #4.安装rsync软件
> - name: install_rsync
>   yum:
>     name: 04-rsync
>     state: latest
> 
> #5.复制配置文件和密码文件
> - name: 05-copy pwd&conf
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
> #6.启动服务
> - name: start 
>   systemd:
>     name: rsyncd
>     state: started
>     enabled: yes
> ```
> 

> [!run]- 编写调用文件
> 
> 
> ```
> [root@m-61 ~]# cat /etc/ansible/rsync_server.yaml 
> - hosts: rsync_server 
>   roles:
>     - rsync_server
> ```

> [!run]- 编写主机清单
> 
> 
> ```
> [root@m-61 ~]# cat /etc/ansible/hosts 
> [rsync_server]
> 172.16.1.41
> ```

> [!run]- 调试运行
> 
> 
> ```
> cd /etc/ansible/
> ansible-playbook -C rsync_server.yaml 
> ansible-playbook rsync_server.yaml
> ```
