> [!config]- 查看ES有哪些配置
> 
> 
> 
> ```
> [root@node-51 ~]# rpm -qc elasticsearch 
> /etc/elasticsearch/elasticsearch.yml						#主配置文件
> /etc/elasticsearch/jvm.options									#JVM配置文件
> /etc/init.d/elasticsearch												#init启动脚本
> /etc/sysconfig/elasticsearch										#环境变量文件
> /usr/lib/sysctl.d/elasticsearch.conf	  				#内核参数文件
> /usr/lib/systemd/system/elasticsearch.service   #systemd启动文件
> ```

> [!config]- 自定义配置文件
> 
> ```
> cp /etc/elasticsearch/elasticsearch.yml  /opt/
> cat > /etc/elasticsearch/elasticsearch.yml << 'EOF'    
> node.name: node-1
> path.data: /var/lib/elasticsearch
> path.logs: /var/log/elasticsearch
> bootstrap.memory_lock: true
> network.host: 127.0.0.1,10.0.0.51
> http.port: 9200
> discovery.seed_hosts: ["10.0.0.51"]
> cluster.initial_master_nodes: ["10.0.0.51"]
> EOF
> ```

> [!info]- 配置文件解释
> 
> 
> ```
> node.name: node-1						        #节点名称
> path.data: /var/lib/elasticsearch		#数据目录
> path.logs: /var/log/elasticsearch		#日志目录
> bootstrap.memory_lock: true				  #锁定内存
> network.host: 10.0.0.51,127.0.0.1		#监听地址
> http.port: 9200										  #端口
> discovery.seed_hosts: ["10.0.0.51"]		#发现节点
> cluster.initial_master_nodes: ["10.0.0.51"]		#集群初始化节点
> ```
> 

> [!systemd]- 重启服务
> 
> 
> ```
> systemctl restart elasticsearch.service
> ```

> [!info]- 解决内存锁定失败
> 
> 
> 重启后查看日志发现提示内存锁定失败
> 
> ```
> [root@node-51 ~]# tail -f /var/log/elasticsearch/elasticsearch.log
> [2020-12-17T19:34:38,132][ERROR][o.e.b.Bootstrap          ] [node-1] node validation exception
> [1] bootstrap checks failed
> [1]: memory locking requested for elasticsearch process but memory is not locked
> ```
> 
> 官网解决方案
> 
> ```
> https://www.elastic.co/guide/en/elasticsearch/reference/current/setting-system-settings.html#systemd
> ```
> 
> 解决命令
> 
> ```
> systemctl edit elasticsearch
> [Service]
> LimitMEMLOCK=infinity
> 
> systemctl daemon-reload
> systemctl restart elasticsearch.service
> ```