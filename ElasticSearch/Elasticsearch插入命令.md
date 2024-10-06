
> [!run]- curl命令操作
> 
> 
> ```
> curl -XPUT 'http://10.0.0.51:9200/linux/_doc/1' -H 'Content-Type: application/json' -d '
> {
>   "name": "zhang",
>   "age": "29"
> }'
> ```

> [!run]- kibana界面操作
> 
> 
> ```
> PUT linux/_doc/1
> {
>   "name": "zhang",
>   "age": "29"
> }
> ```

> [!run]- 使用随机ID
> 
> 
> ```
> POST linux/_doc/
> {
>   "name": "zhang",
>   "age": "29",
>   "address": "BJ"
> }
> ```

> [!run]- 如何保证和mysql数据
> 
> 
> ```
> mysql
> id	name   age  address 	job
> 1	  zhang  27	  BJ	      it
> 2	  ya     22	  SZ	      it
> 
> POST linux/_doc/
> {
>   "id": "1",
>   "name": "zhang",
>   "age": "29",
>   "address": "BJ",
>   "job": "it"
> }
> 
> POST linux/_doc/
> {
>   "id": "2",
>   "name": "ya",
>   "age": "22",
>   "address": "SZ",
>   "job": "it"
> }
> ```