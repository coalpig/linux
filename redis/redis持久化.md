---
tags:
  - Redis
---
# 第3章 Redis持久化

## 1.RDB持久化和AOF持久化

RDB: 类似于快照，当前内存里的数据的状态持久化到硬盘  
优点：压缩格式/恢复速度快  
缺点：不是实时的，可能会丢数据，操作比较重量  
  
AOF:类似于mysql的binlog，可以设置成每秒/每次操作都以追加的形式保存在日志文件  
优点：安全，最多只损失1秒的数据，具备一定的可读性  
缺点：文件比较大，恢复速度慢

## 2.RDB持久化流程图
![[attachments/Pasted image 20240729204113.png]]
## 3.配置RDB持久化

```
save 900 1
save 300 10
save 60 10000
dbfilename redis.rdb
dir /data/redis_6379/
```

## 4.RDB持久化结论：

没配置save参数时：  
1.shutdown/pkill/kill都不会持久化保存  
2.可以手动执行bgsave  
  
配置save参数时：  
1.shutdown/pkill/kill均会自动触发bgsave持久化保存数据  
2.pkill -9 不会触发持久化  
  
恢复时：  
1.持久化数据文件名要和配置文件里定义的一样才能被识别  
2.RDB文件只有一个数据文件，迁移和备份只要这一个RDB文件即可  
  
注意：  
RDB高版本兼容低版本，低版本不能兼容高版本  
3.x >> 5.X >> OK  
5.x >> 3.x >> NoOK

日志内容：

```
8952:M 13 Apr 2020 17:33:12.947 # User requested shutdown...
8952:M 13 Apr 2020 17:33:12.947 * Saving the final RDB snapshot before exiting.
8952:M 13 Apr 2020 17:33:12.947 * DB saved on disk
8952:M 13 Apr 2020 17:33:12.947 * Removing the pid file.
8952:M 13 Apr 2020 17:33:12.947 # Redis is now ready to exit, bye bye...
```

## 4.AOF流程图
![[attachments/Pasted image 20240729204124.png]]
## 5.AOF持久化配置

```
appendonly yes
appendfilename "redis.aof"
appendfsync everysec
```

## 6.AOF重写机制

实验流程：

```
执行的命令   aof记录     redis里的数据
set k1  v1  set k1     k1

set k2  v2  set k1      k1 k2 
            set k2

set k3  v3  set k1      k1 k2 k3 
            set k2  
            set k3

del k1      set k1      k2 k3
            set k2  
            set k3 
            del k1

del k2      set k1      k3 
            set k2  
            set k3 
            del k1 
            del k2

aof文件里实际有意义的只有一条记录：
set k3
```

操作命令：

```
BGREWRITEAOF
```

## 7.AOF和RDB读取实验

实验背景：

aof和rdb同时存在，redis重启会读取哪一个数据？

实验步骤：

```
set k1 v1
set k2 v2 
bgsave       rbd保存 k1 k2  
mv redis.rdb /opt/

flushall
set k3 v3 
set k4 v4    aof保存 k3 k4
mv redis.aof /opt/

redis-cli shutdown
rm -rf /data/redis_6379/*
mv /opt/redis.aof /data/redis_6379/
mv /opt/redis.rdb /data/redis_6379/

systemctl start redis
```

实验结论：

当aof和rdb同时存在的时候，redis会优先读取aof的内容

## 8.AOF模拟故障

损坏实验结论：

```
1.aof修复命令不要用，因为他的修复方案非常粗暴，一刀切，从出错的地方到最后全部删除
2.任何操作之前，先备份数据
```

kill -9 实验:

```
for i in {1..10000};do redis-cli set key_${i} v_${i} && echo "${i} is ok";done
ps -ef|grep redis|grep -v grep|awk '{print "kill -9",$2}'
```

结论：

1.aof相对比较安全，最多丢失1秒数据

## 9.如果设置了过期时间，恢复数据后会如何处理？

```
1.aof文件会记录下过期时间
2.恢复的时候会去对比过期时间和当前时间，如果超过了，就删除key
3.key的过期时间不受备份影响
```

## ·10.AOF和RDB如何选择

```
https://redis.io/topics/persistence
1.开启混合模式
2.开启aof
3.不开启rdb
4.rdb采用定时任务的方式定时备份
5.可以从库开启RDB进行备份
```

## 11.redis注意事项
- redis在停止服务的时候，持续化目录的rdb和aof都会被redis内存里面已经存在的数据覆盖