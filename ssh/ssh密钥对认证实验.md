---
tags:
  - ssh
---

- ~ 记忆方法


**1个目录：**

~/.ssh				SSH相关文件默认保存在当前用户的家目录下



**2个命令：**

ssh-keygen			创建密钥对

ssh-copy-id 			发送公钥



**4个文件：**

id_rsa				私钥-->钥匙

id_rsa.pub			公钥-->锁

known_hosts			记录ssh连接过的主机指纹信息

authorized_keys		保存其他服务器的公钥信息


- ~ 密钥对免密登录


第一步：创建密钥对

ssh-keygen

第二步：发送公钥到服务器

ssh-copy-id 服务器IP地址

第三步：验证是否可以免密登录

ssh 服务器IP地址

- ~ 注意事项


1）使用哪个用户创建的密钥对，那么.ssh是当前用户家目录下

2）~/.ssh目录的权限是700

3）id_rsa私钥的权限是600

4）authorized_keys保存公钥的文件权限也是600
