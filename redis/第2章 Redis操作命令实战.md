# 第2章 Redis操作命令实战

## 1.Redis-cli客户端工具说明

在我们开始练习redis的基础命令之前，我们需要了解一下如何连接进redis数据库里。

和其他的数据库工具一样，redis也有专有的终端工具，那就是redis-cli。

这里要说明的是redis-cli拥有很贴心的自动补全功能，当我们输入命令时会自动以灰色的字样提醒我们这条命令的格式以及参数。所以我们要善于利用redis-cli的提示和补全功能。

下面让我们体验一下吧，当我们输入SET后，redis-cli会自动给我们补全出来SET命令的格式。

```bash
[root@db-51 ~]# redis-cli 
127.0.0.1:6379> SET key value [expiration EX seconds|PX milliseconds] [NX|XX]
```

## 2.字符串类型操作

1）设置一个key

```bash
127.0.0.1:6379> SET k1 v1
```

2）查看一个key

```bash
127.0.0.1:6379> GET k1
"v1"
```

3）设置多个key

```bash
127.0.0.1:6379> MSET k1 v1 k2 v2 k3 v3
OK
```

4）查看多个key

```bash
127.0.0.1:6379> MGET k1 k2 k3
1) "v1"
2) "v2"
3) "v3"
```

5）计数器功能

计数器的应用场景很多，比如说帖子浏览数，留言评论数，视频播放次数等。这里大家可能会奇怪，不是只有数字才会加减吗？为什么字符串也可以加减呢？其实接下来要使用的INCR命令会将字符串值解析成整型.将其加1,最后结果保存为新的字符串。

计数器加1操作；

```bash
127.0.0.1:6379> SET key1 100
OK
127.0.0.1:6379> GET key1
"100"
127.0.0.1:6379> INCR key1
(integer) 101
127.0.0.1:6379> GET key1
"101"
```

计数器加N操作：

```bash
127.0.0.1:6379> INCRBY key1 10
(integer) 111
127.0.0.1:6379> GET key1
"111"
```

计数器减1操作：

```bash
127.0.0.1:6379> INCRBY key1 -1
(integer) 110
127.0.0.1:6379> GET key1
"110"
```

计数器减N操作：

```bash
127.0.0.1:6379> INCRBY key1 -10
(integer) 100
127.0.0.1:6379> GET key1
"100"
```

## 3.列表类型操作

1）从列表左边插入元素

```bash
127.0.0.1:6379> LPUSH list1 A B C
(integer) 3
```

2）从列表右边插入元素

```bash
127.0.0.1:6379> RPUSH list1 D E F
(integer) 6
```

3）读取列表的长度

```bash
127.0.0.1:6379> LLEN list1
(integer) 6
```

4）读取列表的指定范围元素

```bash
127.0.0.1:6379> LRANGE list1 0 -1
1) "C"
2) "B"
3) "A"
4) "D"
5) "E"
6) "F"
```

5）从左边删除元素

```bash
127.0.0.1:6379> LPOP list1
"C"
127.0.0.1:6379> LRANGE list1 0 -1
1) "B"
2) "A"
3) "D"
4) "E"
5) "F"
```

6）从右边删除元素

```bash
127.0.0.1:6379> RPOP list1
"F"
127.0.0.1:6379> LRANGE list1 0 -1
1) "B"
2) "A"
3) "D"
4) "E"
```

## 4.集合类型操作

1）创建集合

```bash
127.0.0.1:6379> SADD set1 1 2 3
(integer) 3
127.0.0.1:6379> SADD set2 1 3 5 7
(integer) 4
```

2）查看集合成员

```bash
127.0.0.1:6379> SMEMBERS set1
1) "1"
2) "2"
3) "3"
127.0.0.1:6379>   SMEMBERS set2
1) "1"
2) "3"
3) "5"
4) "7"
```

3）查看集合的并集

```bash
127.0.0.1:6379> SUNION set1 set2
1) "1"
2) "2"
3) "3"
4) "5"
5) "7"
```

4）查看集合的交集

```bash
127.0.0.1:6379> SINTER set1 set2
1) "1"
2) "3"
```

5）查看集合的差集

```bash
127.0.0.1:6379> SDIFF set1 set2
1) "2"
127.0.0.1:6379> SDIFF set2 set1
1) "5"
2) "7"
```

## 5.有序集合类型操作

1）添加成员

```bash
127.0.0.1:6379> ZADD chinacity 100 user1
(integer) 1
127.0.0.1:6379> ZADD chinacity 99 user2 
(integer) 1
127.0.0.1:6379> ZADD chinacity 98 user3
(integer) 1
127.0.0.1:6379> ZADD chinacity 97 user4
(integer) 1
127.0.0.1:6379> ZADD chinacity 96 user5
(integer) 1
```

2）计算成员个数

```bash
127.0.0.1:6379> ZCARD chinacity
(integer) 5
```

3）计算某个成员个数

```bash
127.0.0.1:6379> ZSCORE chinacity user1
"100"
127.0.0.1:6379> ZSCORE chinacity user2
"99"
```

4）按照降序查看某成员名次

```bash
127.0.0.1:6379> ZRANK chinacity user1
(integer) 4
```

5）按照升序查看某成员名次

```bash
127.0.0.1:6379> ZREVRANK chinacity user1
(integer) 0
```

6）删除某个成员

```bash
127.0.0.1:6379> ZREM chinacity user1
(integer) 1
```

7）增加成员分数

```bash
127.0.0.1:6379> ZINCRBY chinacity 1 user2
"100"
```

8）返回指定排名范围的成员

```bash
127.0.0.1:6379> ZRANGE chinacity 0 2
1) "user5"
2) "user4"
3) "user3"
127.0.0.1:6379> ZRANGE chinacity 0 2 WITHSCORES
1) "user5"
2) "96"
3) "user4"
4) "97"
5) "user3"
6) "98"
```

9）返回指定分数范围的成员

```bash
127.0.0.1:6379> ZRANGEBYSCORE chinacity 95 99 WITHSCORES
1) "user5"
2) "96"
3) "user4"
4) "97"
5) "user3"
6) "98"
```

10）返回指定分数范围的成员的个数

```bash
127.0.0.1:6379> ZCOUNT chinacity 95 99
(integer) 3
```

## 6.HASH类型操作

1）mysql数据格式如何缓存到redis

```bash
mysql数据格式：
user表
id   name   job  age
1	   user1  it   18
2    user2  it   24
3    user3  it   30

hash类型存储格式：
key	     field1  value   field2  value  field3  value
user:1   name    user1   job     it     age     18
user:2   name    user2   job     it     age     18
user:3   name    user3   job     it     age     18
```

2）创建一个HASH数据

```bash
HMSET user:1 name user1 job it age 18
HMSET user:2 name user2 job it age 24
HMSET user:3 name user3 job it age 30
```

3）查看hash里的指定字段的值

```bash
select name from user where id = 1 ;

HMGET user:1 name 
HMGET user:1 name job age
```

4）查看hash里的所有字段的值

```bash
select * from user where id = 1 ;

HGETALL user:1
```