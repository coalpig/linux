---
tags:
  - ansible/角色
---
> [!warn]- 编写思路
> 
> 
> 先拷贝配置文件到template目录下并重命名为j2
> 编写tasks文件
> 调试运行

> [!run]- 创建角色目录
> 
> 
> ```
> cd /etc/ansible/roles/
> mkdir sshd/{tasks,handlers,files,templates,vars} -p
> ```
> 

> [!info]- 编写jinja模版文件
> 
> 
> >jinja模板注意：
> 
> 模块必须是template
> 模版文件必须以.j2结尾
> 模版文件必须放在template目录下
> 
> >关键配置：
> 复制sshd配置文件到template文件夹下
> 
> ```
> Port {{ ssh_port }}
> ListenAddress {{ ansible_facts.eth1.ipv4.address }}
> ```

> [!run]- 编写变量文件
> 
> 
> ```
> [root@m-61 /etc/ansible/roles/sshd]# cat vars/main.yaml 
> ssh_port: '22'
> ```

> [!run]- 编写handlers文件
> 
> 
> ```
> [root@m-61 /etc/ansible/roles/sshd]# cat handlers/main.yaml 
> - name: restart sshd
>   systemd:
>     name: sshd 
>     state: restarted
> ```

> [!info]- 编写主任务文件
> 
> 
> [root@m-61 /etc/ansible/roles/sshd]# cat tasks/main.yaml 
> >复制配置文件和密码文件
> - name: 01_copy_sshd 
>   template:
>     src: sshd_config.j2
>     dest: /etc/ssh/sshd_config
>     mode: '600'
>     backup: yes
>   notify:
>     - restart sshd 
> 
> >启动服务
> - name: start 
>   systemd:
>     name: sshd 
>     state: started
>     enabled: yes

> [!info]- 查看最终的目录
> 
> 
> ```
> [root@m-61 /etc/ansible/roles]# tree sshd/
> sshd/
> ├── files
> ├── handlers
> │   └── main.yaml
> ├── tasks
> │   └── main.yaml
> ├── templates
> │   └── sshd_config.j2
> └── vars
>     └── main.yaml
> ```

> [!info]- 编写主调用文件
> 
> ```
> [root@m-61 /etc/ansible/roles]# cat ../sshd.yaml 
> - hosts: ssh
>   roles:
>     - sshd
> ```
