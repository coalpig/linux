> [!run]- 创建测试语句
> 
> 
> ```
> POST linux/_doc/
> {
>   "name": "zhang3",
>   "age": "22",
>   "address": "SZ",
>   "job": "ops"
> }
> 
> POST linux/_doc/
> {
>   "name": "li4",
>   "age": "30",
>   "address": "BJ",
>   "job": "dev"
> }
> 
> POST linux/_doc/
> {
>   "name": "wang5",
>   "age": "24",
>   "address": "BJ",
>   "job": "dev"
> }
> 
> POST linux/_doc/
> {
>   "name": "zhao6",
>   "age": "35",
>   "address": "SZ",
>   "job": "devops"
> }
> 
> POST linux/_doc/
> {
>   "name": "sun7",
>   "age": "21",
>   "address": "BJ",
>   "job": "ops"
> }
> 
> POST linux/_doc/
> {
>   "name": "jack",
>   "age": "27",
>   "address": "BJ",
>   "job": "devops"
> }
> 
> POST linux/_doc/
> {
>   "name": "scott",
>   "age": "25",
>   "address": "SZ",
>   "job": "dev"
> }
> ```

> [!run]- 简单查询
> 
> 
> ```
> GET linux/_search/
> ```

> [!run]- 条件查询
> 
> 
> ```
> GET linux/_search
> {
>   "query": {
>     "term": {
>       "name": {
>         "value": "zhang3"
>       }
>     }
>   }
> }
> 
> GET linux/_search
> {
>   "query": {
>     "term": {
>       "job": {
>         "value": "ops"
>       }
>     }
>   }
> }
> ```

> [!run]- 多条件查询
> 
> 
> ```
> GET linux/_search
> {
>   "query": {
>     "bool": {
>       "must": [
>         {
>           "term": {
>             "job.keyword": "dev"
>           }
>         },
>         {
>           "term": {
>             "address.keyword": "BJ"
>           }
>         },
>         {
>           "range": {
>             "age.keyword": {
>               "gt": "20",
>               "lt": "30"
>             }
>           }
>         }
>       ]
>     }
>   }
> }
> ```
