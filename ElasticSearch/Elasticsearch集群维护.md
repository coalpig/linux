> [!warn]- 自定义副本数和索引数参数注意事项
> 
> 
> ```
> 索引一旦建立完成,分片数就不可以修改了
> 但是副本数可以随时修改
> ```

> [!run]- 创建索引的时候就自定义副本和分片
> 
> 
> ```
> PUT /linux2/
> {
>   "settings": {
>     "number_of_shards": 3, 
>     "number_of_replicas": 0
>   }
> }
> ```
> 
> 修改单个索引的副本数
> 
> ```
> PUT /linux2/_settings/
> {
>   "settings": {
>     "number_of_replicas": 2
>   }
> }
> ```
> 
> 修改所有的索引的副本数
> 
> ```
> PUT /_all/_settings/
> {
>   "settings": {
>     "number_of_replicas": 0
>   }
> }
> ```
> 

> [!info]- 工作如何设置
> 
> 
> ```
> 2个节点: 默认就可以
> 3个节点: 重要的数据,2副本 不重要的默认 
> 日志收集: 1副本3分片
> ```
> 
> ![](attachments/image-20201218091903908%201.png)
> 
> ![](attachments/image-20201218091903908%202.png)
> 