---
tags:
  - ansible/归档
---
[[ansible面试]]

关于ansiblle
- 什么是ansible，可以查看[Ansible介绍](Ansible介绍.md)，里面有如何安装ansiblel

ansible主机清单
- 什么是主机清单，可以参考[Ansible主机清单](Ansible主机清单.md)
- [ansible主机清单拓展](ansible主机清单拓展.md)
- [举例ansible服务端连接客户端](../ssh/举例ansible服务端连接客户端.md)


[[pattern匹配]]

[使用 ad-hoc 命令](使用%20ad-hoc%20命令.md)

[[关于ansible命令和命令的选项]]

[关于Playbook](关于Playbook.md)

[[关于 Ansible Lint]]

[使用角色的方式来组织playbook](使用角色的方式来组织playbook.md)

[ansible中使用变量](ansible中使用变量.md)

比如要使用ansible hostname -m setup 中setup是采集目标主机的信息-- >[Facts数据](Facts数据.md)

[Jinja2模板语法](Jinja2模板语法.md)

[条件判断与循环](条件判断与循环.md)

[Blocks](Blocks.md)

[Playbook高级特性](Playbook高级特性.md)

如果需要对主机清单的变量密码进行加密,防止使用者知道密码--> [Ansible Vault](Ansible%20Vault.md)

了解ansible的配置--> [Ansible配置](Ansible配置.md)

[管理 windows 主机](管理%20windows%20主机.md)

> [!info] Ansible常用模块
![Ansible常用模块](Ansible常用模块.md)

>[!info] ansible NFS脚本
可以使用ansible的ad-hoc编写一个ansible NFS脚本
[Ansible编写NFS脚本](Ansible编写NFS脚本.md)

>[!info] ansible颜色输出解释
 [[Ansible颜色输出]]

> [!info] 关于ansiblle剧本
> ```dataview
> list 
> from #ansible/剧本 
> sort file.name desc
> ```

>[!info] Ansible剧本高级特性
![Ansible剧本高级特性](Ansible剧本高级特性.md)

>[!info] ansible角色
> ```dataview
> list 
> from #ansible/角色 
> sort file.name desc
> ```

