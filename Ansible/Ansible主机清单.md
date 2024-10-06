---
tags:
  - ansible/基础
---

>什么是主机清单
- 官方文档： https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html
- 第三方文档： https://ansible.leops.cn/basic/Inventory/
- 当我们需要管理的服务器数量特别多的时候，有必要对这些服务器按照功能分组管理，主机清单就是将这些服务器按照Ansible要求的格式分组的配置文件。
- 就是需要对哪些机器批量执行命令，将主机安装服务分好组

>主机清单的变量参数

| 参数               | 描述                                    |     |
| ---------------- | ------------------------------------- | --- |
| ansible_host     | 将要连接的远程主机名.与你想要设定的主机的别名不同的话,可通过此变量设置. |     |
| ansible_port     | 连接端口号，如果是ssh的话，默认是22                  |     |
| ansible_user     | 用于连接认证的用户名                            |     |
| ansible_password | 用于连接认证的用户名密码                          |     |


>为什么需要主机清单
- 方便快速管理多台机器
    - 多台机器的管理需要按照不同的服务来分组
    - 不同的组可能密码，ssh端口，连接的用户也不一样


>主机清单hosts如何配置
- 一般使ini的方式,如下
- 主机清单如果使用yaml格式可读性太差了
- 提前配置好密钥对认证--> [ssh免交互分发公钥](../ssh/ssh免交互分发公钥.md)

```
cat /etc/ansible/hosts
```

```
[web]
172.16.1.31
172.16.1.41

[nfs]
172.16.1.31

[backup]
172.16.1.41
```

>运行ansible验证主机清单

```
- ansible 主机组名称 -m 模块名称 -a 模块参数

- ansible all -m 模块名称 -a 模块参数
```
>分组执行测试命令

```
ansible web -m ping
ansible nfs -m ping
ansible backup -m ping
```

>主机清单配置里面的所有主机都执行

```
ansible all -m ping
```

>自定义主机清单里面的SSH端口号

```
[web]
172.16.1.31 ansible_ssh_port=9527
```

测试命令

```
ansible web -m ping
```

>如果不对ssh做密钥对认证，需要将密码端口号作为变量写入主机清单

- 首先需要提前把主机信息加入到know_host文件里

```
[web]
172.16.1.31 ansible_ssh_port=9527  ansible_ssh_pass='123'
172.16.1.41 ansible_ssh_port=9528  ansible_ssh_pass='123456'
[all:vars]
ansible_password=123
```

-  然后还需要修改ansible配置文件,打开取消认证的注释

```
host_key_checking = False
```

测试命令

```
ansible web -m ping
```

>主机清单中同一组连续的IP

主机清单配置

```
[zabbix]
172.16.1.[31:41] #31到41的ip
```

测试命令

```
ansible zabbix -m ping
```

>同一组具有相同的变量

主机清单配置
- 书写方法第一种

```
[web]
172.16.1.31 ansible_ssh_pass='123'
172.16.1.41 ansible_ssh_pass='123'
```
- 第二种

```
[web]
172.16.1.31
172.16.1.41

[web:vars]
ansible_ssh_pass='123' 
```
测试命令

```
ansible web -m ping
```

>使用多个主机清单

指定主机清单文件

```
ansible all -i staging -i production -m ping
```

指定主机清单目录

```
inventory/ 01-openstack.yml    # configure inventory plugin to get hosts from Openstack cloud 
02-dynamic-inventory.py        # add additional hosts with dynamic inventory script 
03-static-inventory            # add static hosts group_vars/ 
all.yml                        # assign variables to all hosts
```

```
ansible all -i inventory -m ping
```

