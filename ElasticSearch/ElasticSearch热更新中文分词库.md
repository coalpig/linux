---
tags: []
---
- ! 热更新web服务端操作

> [!install]- 热更新服务端安装nginx
> 
> 
> ```
> yum install nginx -y
> ```
> 

> [!txt]- 编写字典文件
> 
> 
> ```shell
> cat >> /usr/share/nginx/html/my_dic.txt << EOF
> 北京
> 张亚
> 武汉
> 中国
> 深圳
> EOF
> ```

> [!systemd]- 重启并测试
> 
> 
> ```shell
> nginx -t
> systemctl restart nginx 
> curl 127.0.0.1/my_dic.txt
> ```

- ! ES客户端端操作

> [!config]- 配置es的中文分词器插件
> 
> 
>  ```
> cat >/etc/elasticsearch/analysis-ik/IKAnalyzer.cfg.xml<<'EOF'
> <?xml version="1.0" encoding="UTF-8"?>
> <!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">
> < properties>
>  <comment>IK Analyzer 扩展配置</comment>
> 
>     <!--用户可以在这里配置自己的扩展字典 -->
>     <entry key="ext_dict"></entry>
> 
>      <!--用户可以在这里配置自己的扩展停止词字典-->
>     <entry key="ext_stopwords"></entry>
> 
>     <!--用户可以在这里配置远程扩展字典 -->
>     <entry key="remote_ext_dict">http://10.0.0.51/my_dic.txt</entry>
> 
>     <!--用户可以在这里配置远程扩展停止词字典-->
>     <!-- <entry key="remote_ext_stopwords">words_location</entry> -->
> </properties>
> 
> EOF
> ```
> 

> [!config]- 将修改好的IK配置文件复制到其他所有ES节点
> 
> 
> ```
> cd /etc/elasticsearch/analysis-ik/
> scp IKAnalyzer.cfg.xml 10.0.0.52:/etc/elasticsearch/analysis-ik/
> scp IKAnalyzer.cfg.xml 10.0.0.53:/etc/elasticsearch/analysis-ik/
> ```

> [!systemd]- 重启所有的ES节点
> 
> 
> ```
> systemctl restart elasticsearch.service 
> ```

> [!log]- 查看日志里字典的词有没有加载出来
> 
> 每个ES服务器打开日志，然后更新字典内容，查看日志里会不会自动加载
> 
> ```
> echo "中国" >> /usr/share/nginx/html/my_dic.txt
> ```
> 
> ```
> tail -f /var/log/elasticsearch/my-application.log
> ```
> 
> 查看日志里字典的词有没有加载出来
> 
> ```
> [2024-08-09T11:03:48,222][INFO ][o.e.c.r.a.AllocationService] [node-1] Cluster health status changed from [YELLOW] to [GREEN] (reason: [shards started [[linux2][1]]]).
> [2024-08-09T11:05:57,656][INFO ][o.w.a.d.Dictionary       ] [node-1] start to reload ik dict.
> [2024-08-09T11:05:57,656][INFO ][o.w.a.d.Dictionary       ] [node-1] try load config from /etc/elasticsearch/analysis-ik/IKAnalyzer.cfg.xml
> [2024-08-09T11:05:57,717][INFO ][o.w.a.d.Dictionary       ] [node-1] [Dict Loading] http://10.0.0.7/main.txt
> [2024-08-09T11:05:57,719][INFO ][o.w.a.d.Dictionary       ] [node-1] 中国
> [2024-08-09T11:05:57,720][INFO ][o.w.a.d.Dictionary       ] [node-1] 扛把子
> [2024-08-09T11:05:57,720][INFO ][o.w.a.d.Dictionary       ] [node-1] 败家之眼
> [2024-08-09T11:05:57,720][INFO ][o.w.a.d.Dictionary       ] [node-1] 王一bo
> [2024-08-09T11:05:57,720][INFO ][o.w.a.d.Dictionary       ] [node-1] 傻子ak
> [2024-08-09T11:05:57,720][INFO ][o.w.a.d.Dictionary       ] [node-1] reload ik dict finished.
> ```

> [!run]- 搜索测试验证结果
> 
> 
> ```
> POST /news2/_search
> {
>     "query" : { "match" : { "content" : "中国" }}, #要搜索的内容
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

> [!info]- 电商上架新产品流程
> 
> 
> ```
> 先把新上架的商品的关键词更新到词典里
> 查看ES日志，确认新词被动态更新了
> 自己编写一个测试索引，插入测试数据，然后查看搜索结果
> 确认没有问题之后，在让开发插入新商品的数据
> 测试
> ```



