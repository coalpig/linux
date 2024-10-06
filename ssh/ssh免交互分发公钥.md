---
tags:
  - ssh
---

>第一次交互：私钥的保存路径
```shell
[root@nfs-31 ~]# ssh-keygen 

Generating public/private rsa key pair.

Enter file in which to save the key (/root/.ssh/id_rsa): 
```

>第二次交互：私钥密码
```shell
Created directory '/root/.ssh'.

Enter passphrase (empty for no passphrase): 
```

>第三次交互：确认密码

```shell
Enter same passphrase again: 

```

>第四次交互：确认指纹信息

```shell

[root@nfs-31 ~]# ssh-copy-id 10.0.0.41

/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"

The authenticity of host '10.0.0.41 (10.0.0.41)' can't be established.

ECDSA key fingerprint is SHA256:T7PEadLsF6pTId3DlsZg4WpHg4jv4wh64hzobQ0ZFjQ.

ECDSA key fingerprint is MD5:d2:e2:83:84:d4:30:bd:3e:0b:5c:22:01:8d:6a:4e:25.

Are you sure you want to continue connecting (yes/no)? 


```

>第五次交互：输入主机密码

```shelll
root@10.0.0.41's password: 
```

> [!info]- 免交互分发密钥步骤
> 

>第一次交互：指定私钥的保存路径

```shell
ssh-keygen -f /root/.ssh/id_rsa
```

>第二次交互：指定私钥密码

```shell
ssh-keygen -f /root/.ssh/id_rsa -N ''
```

>第四次交互：不确认指纹信息

```shell
ssh-copy-id 10.0.0.41 -o StrictHostKeyChecking=no
```

>第五次交互：自动输入主机密码

```shell
yum install sshpass -y

sshpass -p "123" ssh-copy-id 10.0.0.41 -o StrictHostKeyChecking=no
```

>最终效果：

```shell
\#!/bin/bash



ssh-keygen -f /root/.ssh/id_rsa -N '' &>> /dev/null



for i in $(cat pass.txt) #10.0.0.41:111

do

  ip=$(echo $i|awk -F":" '{print $1}') 	#10.0.0.41

  pa=$(echo $i|awk -F":" '{print $2}') 	#111

  sshpass -p "$pa" ssh-copy-id $ip -o StrictHostKeyChecking=no &>> /dev/null

  ssh $ip 'hostname'

done
```

