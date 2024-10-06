---
tags:
  - Ansible/剧本高级特性
---
> [!run]- Ansible剧本高级特性-循环
> 
> 
> 官方地址
> 
> https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html
> 
> 使用场景
> 
> 创建多个目录
> 
> 复制多个目录
> 
> 复制多个文件到不同的目录
> 
> 不同的文件权限不一样
> 
> 不使用循环复制多个文件
> 
> \- name: create_data
> 
> ​    file:
> 
> ​	  path: /data
> 
> ​	  state: directory
> 
> ​	  owner: www
> 
> ​	  group: www
> 
> ​    
> 
> \- name: create_backup
> 
> ​    file:
> 
> ​	  path: /backup
> 
> ​	  state: directory
> 
> ​	  owner: www
> 
> ​	  group: www
> 
> 循环特性语法-单循环
> 
> 第一步：找出需要替换的地方
> 
> 第二步：将需要循环的地方替换成固定格式"{{ item }}"
> 
> 第三步：和模块对其添加循环体loop
> 
> 第四步：填写需要循环的内容
> 
> 举例：
> 
> \- name: 01-create
> 
> ​    file:
> 
> ​	  path: "{{ item }}"
> 
> ​	  state: directory
> 
> ​	  owner: www
> 
> ​	  group: www
> 
> ​    loop:
> 
> ​	  - /data
> 
> ​	  - /backup

> [!run]- 循环特性语法-双循环
> 
> 
> **举例：**
> 
> \- name: Add several users
> 
>   user:
> 
> ​    name: "{{ item.姓名 }}"
> 
> ​    groups: "{{ item.性别 }}"
> 
>   loop:
> 
> ​    \- { 姓名: '李xx', 性别: '男' }
> 
> ​    \- { 姓名: '王xx', 性别: '男' }
> 
> **练习：**
> 
> 命令行写法
> 
> ansible backup -m copy -a "src=rsyncd.conf dest=/etc/"
> 
> ansible backup -m copy -a "src=rsync.passwd dest=/etc/ mode=0600"
> 
> 多循环写法
> 
> \- name: 01-copy
> 
>   copy:
> 
> ​    src: "{{ item.src }}"
> 
> ​	dest: "{{ item.dest }}"
> 
> ​    mode: "{{ item.mode }}"
> 
>   loop:
> 
> ​    \- { src: 'rsyncd.conf',  dest: '/etc/', mode: '0644' }
> 
> ​    \- { src: 'rsync.passwd', dest: '/etc/', mode: '0600' }
> 

> [!run]- Ansible剧本高级特性-变量
> 
> 
> > 应用场景
> 
> 自定义某个变量，在任务中被多次引用
> 
> 从主机收集到系统信息里提取某个变量，比如IP地址，主机名
> 
> > 自定义变量并引用---局部变量
> 
> **命令行写法：**
> 
> ansible backup -m copy -a "src=/root/rsync/conf/rsyncd.conf dest=/etc/"
> 
> ansible backup -m copy -a "src=/root/rsync/conf/rsync.passwd dest=/etc/ mode=0600"
> 
> **剧本写法：**
> 
> \- name: test
> 
>   hosts: web
> 
>   vars:
> 
> ​    data_path: "/data"
> 
> ​    backup_path: "/backup"
> 
>   
> 
>   tasks:
> 
>   \- name: 01-data
> 
> ​    file:
> 
> ​      path: "{{ data_path }}"
> 
> ​      state: directory
> 
> 
> 
>   \- name: 02-backup
> 
> ​    file:
> 
> ​      path: "{{ backup_path }}"
> 
> ​      state: directory
> 
> 
> 
>   \- name: 03-file
> 
> ​    file:
> 
> ​      path: "{{ data_path }}/file1.txt"
> 
> ​      state: touch
> 
> 
> 
>   \- name: 04-file
> 
> ​    file:
> 
> ​      path: "{{ backup_path }}/file2.txt"
> 
> ​      state: touch
> 
> >全局变量--所有yaml都能直接用
> 
> 第一步：在/etc/ansible/hosts里定义变量
> 
> [web]
> 
> 10.0.0.[7:8] data_path="/mnt/data" backup_path="/mnt/backup"
> 
> 第二步：在yaml剧本里直接使用变量
> 
> \- name: test
> 
>   hosts: web
> 
> 
> 
>   tasks:
> 
>   \- name: 01-data
> 
> ​    file:
> 
> ​      path: "{{ data_path }}"
> 
> ​      state: directory
> 
> 
> 
>   \- name: 02-backup
> 
> ​    file:
> 
> ​      path: "{{ backup_path }}"
> 
> ​      state: directory
> 
> 
> 
>   \- name: 03-file
> 
> ​    file:
> 
> ​      path: "{{ data_path }}/file1.txt"
> 
> ​      state: touch
> 
> 
> 
>   \- name: 04-file
> 
> ​    file:
> 
> ​      path: "{{ backup_path }}/file2.txt"
> 
> ​      state: touch
> 
> 第三步：在loop循环里引用变量
> 
> \- name: test
> 
>   hosts: web
> 
>   tasks:
> 
>   \- name: 01-loop
> 
> ​    file:
> 
> ​      path: "{{ item.path }}"
> 
> ​      mode: "{{ item.mode }}"
> 
> ​      state: touch
> 
> ​    loop:
> 
> ​      \- { path: "{{ data_path }}/file1.txt", mode: '0600' }
> 
> ​      \- { path: "{{ backup_path }}/file2.txt", mode: '0644' }
> 
> >内置变量--直接可以用
> 
> 查看内置变量
> 
> ansible 10.0.0.31 -m setup
> 
> 使用变量获取主机的eth1地址和主机名
> 
> \- hosts: web
> 
>   tasks:
> 
>   \- name: get IP
> 
> ​    shell: "echo {{ ansible_default_ipv4.address }} >> /tmp/ip.txt"
> 
>   \- name: get hostname
> 
> ​    shell: "echo {{ ansible_hostname }} >> /tmp/hostname.txt"
> 

> [!run]- 剧本高级特性-注册变量
> 
> 
> >应用场景
> 
> 调试，回显命令执行的内容
> 把状态保存成变量，其他任务可以进行判断或引用
> 
> >使用内置变量将IP地址保存到文本里，并将文本内容显示出来
> 
> \- hosts: all
>    tasks:
>    \- name: echo IP 
>      shell: "echo {{ ansible_default_ipv4.address }} >> /tmp/ip.txt"
>  
>    \- name: cat IP
>      shell: "cat /tmp/ip.txt"
>      register: ip_txt
>  
>    \- debug:
>        msg: "{{ ip_txt.stdout_lines }}"
> 
> >如果配置文件发生了变化,就重启服务,否则不重启
> 
> \- hosts: backup
>     tasks:
>     \- name: 01-copy_conf
>       copy:
>         src: /opt/rsyncd.conf
>         dest: /etc/
>       register: conf_status			# 注册变量
> 
> ​    \- name: 02-start 
> ​      systemd:
> ​        name: rsyncd
> ​        state: started
> ​        enabled: yes
> 
> ​    \- name: 03-restart 
> ​      systemd:
> ​        name: rsyncd
> ​        state: restarted
> ​      when: conf_status.changed   	# 判断变量状态是否发生改变
> 
> >注册变量和判断场景
> 
> 官方地址：
> 
>  https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html
> 
> 使用场景：
> 
> 场景：
>  判断所有机器/tmp/下有没有ip.txt的文件
>  
>  如果有，打印出来内容并且格式为：
>  例如：
>  
>  web01 has ip.txt
>  内容为：
>  
>  如果不存在：
>  输出内容：nfs is nofile
> 
> 参考实现：
> 
> \- name: Check for ip.txt and print content
> 
>   hosts: all
> 
>   tasks:
> 
> ​    \- name: Check if ip.txt exists
> 
> ​      stat:
> 
> ​        path: /tmp/ip.txt
> 
> ​      register: ip_txt_stat
> 
> 
> 
> ​    \- name: Print content of ip.txt if it exists
> 
> ​      shell: cat /tmp/ip.txt
> 
> ​      register: ip_txt_content
> 
> ​      when: ip_txt_stat.stat.exists
> 
> 
> 
> ​    \- name: Display the content of ip.txt
> 
> ​      debug:
> 
> ​        msg: "{{ inventory_hostname }} has ip.txt\n内容为：\n{{ ip_txt_content.stdout }}"
> 
> ​      when: ip_txt_stat.stat.exists
> 
> 
> 
> ​    \- name: Output message if ip.txt does not exist
> 
> ​      debug:
> 
> ​        msg: "nfs is nofile"
> 
> ​      when: not ip_txt_stat.stat.exists
> 

> [!run]-  Ansible剧本高级特性-服务状态管理
>
> 
> >官方文档
> 
> https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_handlers.html
> 
> >现在存在的问题
> 
> 如果只有start，那么配置文件发生变化了并不会重启
> 
> 如果只有restart，那么配置文件不管变没变化都会重启
> 
> >我们期望的效果
> 
> 第一次安装的时候 --> start
> 
> 配置文件发生变化 --> restart
> 
> 配置文件没发生变化 --> 不做任何操作
> 
> >nfs剧本改写
> 
> \- name: install nfs server
> 
>   hosts: nfs_server
> 
>   vars: 
> 
> ​    conf_path: "/root/yaml/nfs_server/conf/"
> 
> ​    data_path: "/data"
> 
> ​	backup_path: "/backup"
> 
> 
> 
>   tasks:
> 
>   \- name: 01-yum
> 
> ​    yum:
> 
> ​      name: nfs-utils
> 
> ​      state: present
> 
>   
> 
>   \- name: 02-groupadd
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
>   \- name: 03-useradd
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
>   \- name: 04-data
> 
> ​    file:
> 
> ​      path: "{{ item }}" 
> 
> ​      state: directory 
> 
> ​      owner: www 
> 
> ​      group: www
> 
> ​    loop:
> 
> ​      \- "{{ data_path }}"
> 
> ​      \- "{{ backup_path }}"
> 
> ​          
> 
>   \- name: 05-config
> 
> ​    copy:         
> 
> ​      src: "{{ conf_path }}/exports" 
> 
> ​      dest: /etc/
> 
> ​    notify:
> 
> ​    \- Restart nfs
> 
> ​          
> 
>   \- name: 06-start
> 
> ​    systemd:      
> 
> ​      name: nfs
> 
> ​      state: started
> 
> ​      enabled: true
> 
> 
> 
>   handlers:
> 
> ​    \- name: Restart nfs
> 
> ​      systemd:
> 
> ​        name: nfs 
> 
> ​        state: restarted
> 
> >注意
> 
> notify里写的任务名称一定要和handlers里的任务名称一模一样
> 
> handlers一定是在原本所有任务都执行完，最后才会执行handlers动作

> [!run]- Ansible剧本高级特性-选择tasks
> 
> 
> >应用场景
> 
> 调试的时候
> 
> 从某个任务开始往下依次执行
> 
> >查看所有task列表
> 
> [root@m-61 ~/yaml/nfs_server]# ansible-playbook --list-tasks nfs_server.yaml 
> 
> playbook: nfs_server.yaml
> 
>   play #1 (nfs_server): install nfs server	TAGS: []
> 
> ​    tasks:
> 
> ​      01-yum	TAGS: []
> 
> ​      02-groupadd	TAGS: []
> 
> ​      03-useradd	TAGS: []
> 
> ​      04-data	TAGS: []
> 
> ​      05-config	TAGS: []
> 
> ​      06-start	TAGS: []
> 
> >从某个指定的task开始执行
> 
> [root@m-61 ~/yaml/nfs_server]# ansible-playbook --start-at-task '05-config' nfs_server.yaml 
> 
> 
> 
> PLAY [install nfs server] *************************************************************************************
> 
> 
> 
> TASK [Gathering Facts] ****************************************************************************************
> 
> ok: [10.0.0.31]
> 
> 
> 
> TASK [05-config] **********************************************************************************************
> 
> ok: [10.0.0.31]
> 
> 
> 
> TASK [06-start] ***********************************************************************************************
> 
> ok: [10.0.0.31]
> 
> 
> 
> PLAY RECAP ****************************************************************************************************
> 
> 10.0.0.31                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

> [!run]- Ansible剧本高级特性-选择tag
> 
> 
> >查看tag标签
> 
> ansible-playbook --list-tasks nfs_server.yaml 
> 
> >选择指定的任务
> 
> ansible-playbook -t '05-config' nfs_server.yaml
> 
> ansible-playbook -t '01-yum,05-config,06-start' nfs_server.yaml
> 
> >完整剧本
> 
> \- name: install nfs server
> 
>   hosts: nfs_server
> 
>   vars: 
> 
> ​    conf_path: "/root/yaml/nfs_server/conf/"
> 
> 
> 
>   tasks:
> 
>   \- name: 01-yum
> 
> ​    yum:
> 
> ​      name: nfs-utils
> 
> ​      state: present
> 
> ​    tags: 01-yum
> 
>   
> 
>   \- name: 02-groupadd
> 
> ​    group:
> 
> ​      name: www
> 
> ​      gid: 1000
> 
> ​      state: present
> 
> ​    tags: 02-groupadd
> 
> ​    
> 
>   \- name: 03-useradd
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
> ​    tags: 03-useradd
> 
> ​          
> 
>   \- name: 04-data
> 
> ​    file:
> 
> ​      path: "{{ item }}" 
> 
> ​      state: directory 
> 
> ​      owner: www 
> 
> ​      group: www
> 
> ​    loop:
> 
> ​      \- /data
> 
> ​      \- /backup
> 
> ​    tags: 04-data
> 
> ​          
> 
>   \- name: 05-config
> 
> ​    copy:         
> 
> ​      src: "{{ conf_path }}/exports" 
> 
> ​      dest: /etc/
> 
> ​    notify:
> 
> ​    \- Restart nfs
> 
> ​    tags: 05-config
> 
> ​          
> 
>   \- name: 06-start
> 
> ​    systemd:      
> 
> ​      name: nfs
> 
> ​      state: started
> 
> ​      enabled: true
> 
> ​    tags: 06-start
> 
> 
> 
>   handlers:
> 
> ​    \- name: Restart nfs 
> 
> ​      systemd:
> 
> ​        name: nfs 
> 
> ​        state: restarted
