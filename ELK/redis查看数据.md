```
[root@web-7 ~]# redis-cli -h 10.0.0.7
10.0.0.7:6379> keys *
1) "nginx-log"
10.0.0.7:6379> type nginx-log
list
10.0.0.7:6379> LRANGE nginx-log 0 -1
10.0.0.7:6379> LLEN nginx-log
(integer) 26
```