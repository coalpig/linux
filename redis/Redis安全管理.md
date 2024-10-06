---
tags:
  - Redis
---
## 1.Redis用户密码

### 1）配置密码认证功能

```
requirepass 123456
```

### 2）使用密码

第一种：

```
[root@db-51 ~]# redis-cli
127.0.0.1:6379> set k1 v1
(error) NOAUTH Authentication required.
127.0.0.1:6379> AUTH 123456
OK
127.0.0.1:6379> keys *
1) "k1"
```

第二种：

```
[root@db-51 ~]# redis-cli -a '123456' get k1
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
"v1"
```

### 3）为什么redis的密码认证这么简单?

1.redis一般都部署在内网环境，相对比较安全的

2.有同学担心密码写在配置文件里，不用担心，因为开发不允许SSH登陆到Linux服务器，但是可以远程连接Redis，所以设置密码还是有作用的

## 2.禁用或重命名危险命令

### 1）禁用危险命令

```
rename-command KEYS ""
rename-command SHUTDOWN ""
rename-command CONFIG ""
rename-command FLUSHALL ""
```

### 2）命名危险命令

```
rename-command KEYS "QQ526195417"
rename-command SHUTDOWN ""
rename-command CONFIG ""
rename-command FLUSHALL ""
```