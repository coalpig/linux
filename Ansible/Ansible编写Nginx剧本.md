---
tags:
  - ansible/剧本
---
- ~ 命令行写法

```
ansible web -m yum -a "name=nginx state=installed"

ansible web -m service -a "name=nginx state=started"
```

- ~ 剧本写法

```
- name: install nginx server 

  hosts: web

  tasks:

  - name: 01-install

​    yum:

​      name: nginx

​      state: installed

  - name: 02-started

​    service: 

​      name: nginx

​      state: started  
```
