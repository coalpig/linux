> [!warn]- 监控注意
> 
> 
> ```
> 1.不能只监控集群状态
> 2.监控节点数
> 3.监控集群状态
> 4.两者任意一个发生改变了都报警
> ```

> [!run]- 监控命令
> 
> 
> ```
> GET _cat/nodes
> GET _cat/health
> GET _cat/master
> GET _cat/indices
> GET _cat/shards
> GET _cat/shards/linux
> ```

> [!run]- 查看集群健康状态
> 
> 
> ```
> curl -s 127.0.0.1:9200/_cat/health|grep "green"|wc -l
> ```

> [!run]- 查看节点个数
> 
> 
> ```
> curl -s 127.0.0.1:9200/_cat/nodes|wc -l
> ```

> [!info]- kibana开启监控
> 
> ```
> 点击kibana面板的监控按钮
> ```

> [!run]- kibana关闭监控
> 
> 
> ```
> GET /_cluster/settings
> PUT /_cluster/settings
> {
>   "persistent" : {
>     "xpack" : {
>       "monitoring" : {
>         "collection" : {
>           "enabled" : "false"
>         }
>       }
>     }
>   }
> }
> ```