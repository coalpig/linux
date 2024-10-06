---
tags:
  - node
  - npm
---

> [!info]- 前提条件
> 需要node环境
> 
> ```
> npm -v
> node -v
> ```
> 

> [!install]- nodejs安装
> 
> 
> ```
> wget https://nodejs.org/dist/v10.16.3/node-v10.16.3-linux-x64.tar.xz
> tar xf  node-v10.16.3-linux-x64.tar.xz -C /opt/
> cd /opt/
> ln -s node-v10.16.3-linux-x64 node
> echo 'export PATH=/opt/node/bin:$PATH' >> /etc/profile
> source /etc/profile
> npm -v
> node -v
> ```

> [!install]- 指定使用国内淘宝npm源
> 
> 
> ```
> npm install -g cnpm --registry=https://registry.npm.taobao.org
> ```

> [!install]- 安装es-dump
> 
> 
> ```
> cnpm install elasticdump -g
> ```

> [!run]- 备份
> 备份
> 
> 备份成可读的json格式
> 
> ```
> elasticdump \
>   --input=http://10.0.0.51:9200/news2 \
>   --output=/data/news2.json \
>   --type=data
> ```
> 
> 备份成压缩格式
> 
> ```
> elasticdump \
>   --input=http://10.0.0.51:9200/news2 \
>   --output=$|gzip > /data/news2.json.gz  
> ```
> 
> 备份分词器/mapping/数据一条龙服务
> 
> ```
> elasticdump \
>   --input=http://10.0.0.51:9200/news2 \
>   --output=/data/news2_mapping.json \
>   --type=mapping
> elasticdump \
>   --input=http://10.0.0.51:9200/news2 \
>   --output=/data/news2.json \
>   --type=data
> ```

> [!run]- 恢复
> 
> 
> 只恢复数据
> 
> ```
> elasticdump \
>   --input=/data/news2.json \
>   --output=http://10.0.0.51:9200/news2
> ```
> 
> 恢复所有数据包含分词器/mapping一条龙
> 
> ```
> elasticdump \
>   --input=/data/news2_mapping.json \
>   --output=http://10.0.0.51:9200/news2 \
>   --type=mapping
> elasticdump \
>   --input=/data/news2.json \
>   --output=http://10.0.0.51:9200/news2 \
>   --type=data
> ```
> 

> [!run]- 批量备份
> 
> 
> ```
> curl -s 10.0.0.52:9200/_cat/indices|awk '{print $3}'|grep -v "^\."
> ```

> [!warn]- 注意事项
> 
> 
> ```
> 1.如果恢复的时候数据冲突了，会被覆盖掉
> 2.如果已经存在备份文件里没有的数据，会保留下来
> ```

> [!run]- 带密码认证的导出
> 
> 
> ```
> --input=http://name:password@production.es.com:9200/my_index
> ```


