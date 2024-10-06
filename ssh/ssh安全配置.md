---
tags:
  - ssh
---

>ssh知识点

ssh默认端口号是22

ssh是一个服务，服务名是sshd

sshd服务的配置文件/etc/ssh/sshd_config

>目前SSH不安全的地方

1）虽然设置了公钥认证，但是原来的密码认证还是可以连接的

2）SSH协议的端口号默认是22，全世界的人都知道

3）SSH默认允许所有IP段连接的，应该只允许172内网网段才能连

4）SSH默认是允许root登录

>解决密码登录问题

PasswordAuthentication no

>解决密码登录问题解决默认端口号和IP地址

Port 2222

ListenAddress 172.16.1.7

>解决密码登录问题不允许root帐号直接登录

PermitRootLogin no
