## 1.什么是binlog日志

```
简单来讲,binlog日志是记录你执行的SQL语句
但是注意,记录的都是涉及到创建或修改的语句
创建: 建库,建表,建字段
修改: 修改数据,插入数据,删除数据

记录修改类操作(逻辑日志，类似于SQL记录)
DML: insert update delete
DDL: create drop alter trucate
DCL: grant revoke
```

binary log
 二进制日志
 专门记录更改创建的语句

作用
- 执行sql相关的操作后，如果后悔了，需要恢复，就要用到binlog
- 同时如果误操作了，可以用来恢复

对于查询操作binlog不会记录


## 2.为什么需要binlog日志

主要用于恢复全备之后的增量数据因为不能实时的备份,所以一般一天一备,但是如果白天发生了误删除,那么可以从binlog日志里恢复主从复制传输数据就是从binlog里提取的
