---
tags:
  - OpenJDK
  - firewalld
---
> [!systemd]- 关闭防火墙和Selinux
> 
> 
> ```
> 关闭swap分区
> 内存 2G
> 
> iptables -nL
> iptables -F
> iptables -X
> iptables -Z
> iptables -nL
> 
> #关闭selinux
> 临时生效:
> setenforce 0
> getenforce
> 
> 永久生效:
> setenforce 0
> vim /etc/selinux/config 
> SELINUX=disabled
> ```

> [!install]- 下载软件
> 
> 
> elasticsearch-7.9.1-x86_64.rpm
> 
> ```
> mkdir /data/soft -p
> cd /data/soft/
> wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.9.1-x86_64.rpm
> ```

> [!info]- 安装jdk
> 
> 
> 对于Elasticsearch7.0之后的版本不需要再独立的安装JDK了，软件包里已经自带了最新的JDK，所以直接启动即可。

> [!install]- 安装ES
> 
> 
> ```
> rpm -ivh elasticsearch-7.9.1-x86_64.rpm
> ```

> [!config]- 修改配置文件
> 
> ```
> egrep -v "#|^#" /etc/elasticsearch/elasticsearch.yml
> ```
> 
> ```
> node.name: node-1
> path.data: /var/lib/elasticsearch
> path.logs: /var/log/elasticsearch
> bootstrap.memory_lock: true # 配置内存锁定
> network.host: 127.0.0.1,10.0.0.51
> http.port: 9200
> discovery.seed_hosts: ["10.0.0.51"]
> ```

> [!config]- 配置内存锁定
> 
> 
> ```
> systemctl edit elasticsearch #进入vim模式
> [Service]
> LimitMEMLOCK=infinity
> ```

> [!systemd]- 启动并检查
> 
> 
> ```
> systemctl daemon-reload
> systemctl enable elasticsearch.service
> systemctl start elasticsearch.service
> netstat -lntup|grep 9200
> curl 10.0.0.51:9200
> ```