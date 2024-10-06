> [!test]- 未分词的情况
> 
> 
> 插入测试数据
> 
> ```
> POST /news/_doc/1
> {"content":"美国留给伊拉克的是个烂摊子吗"}
> 
> POST /news/_doc/2
> {"content":"公安部：各地校车将享最高路权"}
> 
> POST /news/_doc/3
> {"content":"中韩渔警冲突调查：韩警平均每天扣1艘中国渔船"}
> 
> POST /news/_doc/4
> {"content":"中国驻洛杉矶领事馆遭亚裔男子枪击 嫌犯已自首"}
> ```
> 
> 查询测试
> 
> ```
> POST /news/_search
> {
>     "query" : { "match" : { "content" : "中国" }},
>     "highlight" : {
>         "pre_tags" : ["<tag1>", "<tag2>"],
>         "post_tags" : ["</tag1>", "</tag2>"],
>         "fields" : {
>             "content" : {}
>         }
>     }
> }
> ```
> 

> [!test]- 结论
> 
> 
> ```
> 未配置中文分词器时查询中文会将词拆分成一个一个的汉字。
> ```

> [!info]
> 前提条件
> 
> ```
> 所有的ES节点都需要安装
> 所有的ES都需要重启才能生效
> 中文分词器的版本号要和ES版本号对应
> https://github.com/medcl/elasticsearch-analysis-ik
> ```

> [!install]- 安装中文分词器
> 
> 
> 在线安装
> 
> ```
> /usr/share/elasticsearch/bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.9.1/elasticsearch-analysis-ik-7.9.1.zip
> ```
> 
> 离线本地文件安装
> 
> ```
> /usr/share/elasticsearch/bin/elasticsearch-plugin install file:///opt/elasticsearch-analysis-ik-7.9.1.zip
> ```
> 
> 重启所有ES节点
> 
> ```
> systemctl restart elasticsearch.service
> ```
> 

> [!run]- 创建索引
> 
> 
> ```
> PUT /news2
> ```

> [!run]- 创建模板
> 
> 
> ```
> POST /news2/_doc/_mapping?include_type_name=true
> {
>     "properties": {
>         "content": {
>             "type": "text",
>             "analyzer": "ik_max_word",
>             "search_analyzer": "ik_smart"
>         }
>     }
> }
> ```

> [!run]- 插入测试数据
> 
> 
> ```
> POST /news2/_doc/1
> {"content":"美国留给伊拉克的是个烂摊子吗"}
> 
> POST /news2/_doc/2
> {"content":"公安部：各地校车将享最高路权"}
> 
> POST /news2/_doc/3
> {"content":"中韩渔警冲突调查：韩警平均每天扣1艘中国渔船"}
> 
> POST /news2/_doc/4
> {"content":"中国驻洛杉矶领事馆遭亚裔男子枪击 嫌犯已自首"}
> ```

> [!run]- 再次查询数据发现已经能识别中文了
> 
> 
> ```
> POST /news2/_search
> {
>     "query" : { "match" : { "content" : "中国" }},
>     "highlight" : {
>         "pre_tags" : ["<tag1>", "<tag2>"],
>         "post_tags" : ["</tag1>", "</tag2>"],
>         "fields" : {
>             "content" : {}
>         }
>     }
> }
> ```

