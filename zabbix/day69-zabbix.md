 1.使用zabbix监控项模版监控zabbix集群的健康状态，监控需求如下：
2.画图给出趋势以及聚合图形
```
1.连接数（connected_clients）
监控项: 监测每个节点的活跃连接数。
阈值: 警告阈值设置在连接数接近最大连接配置的70%。
connected=$(redis-cli -c -h 10.0.0.51 -p 6380 info | awk -F':' '/connected_clients/{print $2}' | egrep -o '[0-9]+')
maxclients=$(cat /opt/redis_6380/conf/redis_6380.conf  | awk '/maxclients/{print $2}' | egrep -o '[0-9]+')
echo $[$connected/$maxclients]
echo $[$connected/$maxclients]
2.内存使用量（used_memory）
监控项: 监测每个节点已使用的内存量。
阈值: 警告阈值设置在配置内存的70%。
redis-cli -c -h 10.0.0.51 -p 6380 info | awk -F':'  '/used_memory:/{print $2 | egrep -o '[0-9]+'}' >> abc.txt

cat /opt/redis_6380/conf/redis_6380.conf  | awk '/maxmemory/{print $2 | egrep -o '[0-9]+'}'

3.CPU使用率
监控项: 监测每个Redis服务器节点的CPU使用率。
阈值: 警告阈值可设置在CPU使用率达到70%。
redis-cli -c -h 10.0.0.51 -p 6380 info | awk -F':' '/used_cpu_sys:/{print $2}' | egrep -o '[0-9]+' >> abc.txt



4.主从同步延迟（master_repl_offset - slave_repl_offset）
监控项: 监测主从数据复制的延迟。
阈值: 任何显著的延迟（例如超过1秒）都应该触发警告。
redis-cli -c -h 10.0.0.52 -p 6381 info | awk -F':' '/master_repl_offset/{print $2}'

redis-cli -c -h 10.0.0.52 -p 6381 info | awk -F':' '/slave_repl_offset/{print $2}'

5.持久化RDB和AOF状态
监控项: 监测RDB和AOF的最后一次成功执行时间和状态。
阈值: 如持久化操作失败，立即触发警告。

redis-cli -c -h 10.0.0.52 -p 6381 info  | awk -F':' '/rdb_last_bgsave_time_sec/{print $2}'

redis-cli -c -h 10.0.0.52 -p 6381 info  | awk -F':' '/rdb_last_bgsave_status/{print $2}'

redis-cli -c -h 10.0.0.52 -p 6381 info  | awk -F':' '/aof_last_rewrite_time_sec/{print $2}'

redis-cli -c -h 10.0.0.52 -p 6381 info  | awk -F':' '/aof_last_bgrewrite_status/{print $2}'




6.命令处理速率（instantaneous_ops_per_sec）
监控项: 监测每秒处理的命令数量。
阈值: 根据正常操作时的平均值设定基线，如果发现异常下降则触发警告。

redis-cli -c -h 10.0.0.52 -p 6381 info  | awk -F':' '/instantaneous_ops_per_sec/{print $2}'


7.拒绝连接数（rejected_connections）
监控项: 监测由于达到最大连接数而被拒绝的连接数。
阈值: 任何被拒绝的连接都应该触发警告。

redis-cli -c -h 10.0.0.52 -p 6381 info  | awk -F':' '/rejected_connections/{print $2}'


8.键失效率（expired_keys）
监控项: 监测在一定时间内键自动过期的数量。
阈值: 根据历史数据设定一个平均水平，超出正常范围应触发警告。

redis-cli -c -h 10.0.0.52 -p 6381 info  | awk -F':' '/expired_keys/{print $2}'

9.集群状态（cluster_state）
监控项: 检查集群是否处于OK状态。
阈值: 如果不是ok就报警

redis-cli -c -h 10.0.0.52 -p 6381 cluster info  | awk -F':' '/cluster_state/{print $2}'


10.集群已知节点数（cluster_known_nodes）
监控项: 监控集群中已知的节点总数。
阈值: 如果有节点故障了就报警
redis-cli -c -h 10.0.0.52 -p 6381 cluster info  | awk -F':' '/cluster_known_nodes/{print $2}'


11.分配的槽数（cluster_slots_assigned）
监控项: 监控已分配的槽位数量。
阈值: 如果不是16384就报警
redis-cli -c -h 10.0.0.52 -p 6381 cluster info  | awk -F':' '/cluster_slots_assigned/{print $2}'



12.正常的槽数（cluster_slots_ok）
监控项: 监控正常的槽位数量。
阈值: 如果不是16384就报警

redis-cli -c -h 10.0.0.52 -p 6381 cluster info  | awk -F':' '/cluster_slots_ok/{print $2}'


```

思考：
1.如何监控集群是否发生故障转移？
2.目前的监控方案每个监控项都需要访问一次redis，是否可以优化？
3.如果你去了一家新公司，又需要你将这些监控项重新添加一次，你会如何应对？