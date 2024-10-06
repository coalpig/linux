查看当前位于哪个binlog

```
show binary logs;
show master status;
```

查看当前的事件

```
show binlog events in 'mysql-bin.000001';
```

刷新日志

```
flush logs;
```

查看binlog日志详细内容

```
mysqlbinlog /data/mysql_3306/logs/mysql-bin.000001|less
```
