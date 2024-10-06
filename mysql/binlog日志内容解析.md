

默认insert操作日志是看不到具体的内容，因为使用了base64编码

```
mysqlbinlog /data/mysql_3306/logs/mysql-bin.000001
```

如果想查看具体的操作语句，可以使用base64解码后查看
因为mysql的binlog进行了加密

```
mysqlbinlog --base64-output=decode-rows -vv /data/mysql_3306/logs/mysql-bin.000001
```
