---
tags:
  - ansible/角色
---

角色目录规划


>官方说明

https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html

>目录说明

注意！这里的目录结构必须按照官方定义的要求来做！不是自己随便乱起！

```shell
tasks				#存放主任务执行文件
handlers				#存放handlers文件
files					#存放需要发送的文件或压缩包
templates			#存放jinja模版配置文件
vars					#存放变量文件

```