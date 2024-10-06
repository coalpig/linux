> [!run]- 自定义的ID更新
> 
> 
> ```
> PUT linux/info/1
> {
>   "name": "zhang",
>   "age": 30,
>   "job": "it",
>   "id": 1
> }
> ```

> [!run]- 随机ID更新
> 
> 
> 创建测试数据
> 
> ```
> PUT linux/_doc/1
> {
>   "name": "zhang",
>   "age": "30",
>   "job": "it",
>   "id": 2
> }
> ```
> 
> 先根据自定义的Id字段查出数据的随机ID
> 
> ```
> GET linux/_search/
> {
>   "query": {
>     "term": {
>       "id": {
>         "value": "2"
>       }
>     }
>   }
> }
> ```
> 
> 取到随机ID后更改数据
> 
> ```
> PUT linux/_doc/CVDdknIBq3aq7mPQaoWw
> {
>   "name": "tony",
>   "age": 30,
>   "job": "it",
>   "id": 2
> }
> ```