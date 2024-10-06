

## 1.选主策略

```
1.日志量最新
2.备选主
3.不被选主
```

## 2.故障转移流程

```
1.从宕机崩溃的master保存二进制日志事件(binlog events);
2.识别含有最新更新的slave;
3.应用差异的中继日志(relay log)到其他的slave;
4.应用从master保存的二进制日志事件(binlog events);
5.提升一个slave为新的master;
6.使其他的slave连接新的master进行复制;
```

