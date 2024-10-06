刚才我们说了，有些应用自带的metrics接口，那么对于没有自带metrics接口的应用，我们可以使用各种exporter监控，官方已经给我们提供了非常多的exporter,具体可以去官网查阅，地址如下：

https://prometheus.io/docs/instrumenting/exporters/

下面以mysql的exporter举例，具体的做法就是在每个mysql的pod里部署一个exporter服务来监控mysql的各项数据。

mysql这里没有使用命名空间，如果使用了需要创建命名空间，并且harbor证书也需要在命名空间里面创建

配置文件

```
apiVersion: v1
kind: ConfigMap              #资源类型cm
metadata: 
  name: prometheus-config    #资源名称
  namespace: prom            #命名空间
data:                        #ConfigMap 中存储的数据
  prometheus.yml: |          #键 prometheus.yml
    global:                  #全局配置块
      scrape_interval: 15s   #Prometheus 会每 15 秒抓取一次
      scrape_timeout: 15s    #抓取操作的超时时间
    scrape_configs:  #翻译是抓_配置        #Prometheus 抓取配置的列表

    - job_name: 'prometheus' #在prometheus页面Targets的名称
      static_configs: 
      - targets: ['localhost:9090']
#     - targets: ['prometheus.prom:9090'] #这里可以直接使用svc


    - job_name: 'coredns'
      static_configs:
      - targets: ['10.244.0.15:9153','10.244.0.17:9153']  
#     - targets: ['kube-dns.kube-system:9153'] #这里可以直接使用svc


    - job_name: 'mysql' 
      static_configs:
      - targets: ['10.103.30.229:9104'] #这里可以使用svc名称
#     - targets: ['mysql-svc.命名空间:9153'] #这里可以直接使用svc
```



```
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-exporter-cm
data:
  .my.cnf: |
    [client]
    user = root
    password = root
    [client.servers]
    user = root
    password = root
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-dp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      nodeName: node-02
      volumes:
      - name: mysql-data
        hostPath:
          path: /data/mysql/
          type: DirectoryOrCreate
      - name: mysql-exporter-cm
        configMap:
          name: mysql-exporter-cm
      imagePullSecrets:
      - name: harbor-secret
      containers:
      - name: mysql
        image: abc.com/base/mysql:5.7
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 3306
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "root"
        volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql/
      - name: mysql-exporter
        image: abc.com/prom/mysqld-exporter
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 9104
        volumeMounts:
        - name: mysql-exporter-cm
          mountPath: /.my.cnf
          subPath: .my.cnf
---
kind: Service
apiVersion: v1
metadata:
  name: mysql-svc
spec:
  selector:
    app: mysql
  ports:
  - name: mysql
    port: 3306
    targetPort: 3306
  - name: metrics
    port: 9104
    targetPort: 9104

```


快速查看和更新配置文件的脚本
这里是使用svc
```
#!/bin/bash

get(){
  kubectl -n prom exec -it $(kubectl -n prom get pod | awk "NR>1"'{print $1}') -- cat /etc/prometheus/prometheus.yml
}

reload(){
  curl -X POST "http://$(kubectl -n prom get svc|awk 'NR>1{print $3}'):9090/-/reload" #重加载配置文件
}

case $1 in
  g)
    get
    ;;
  r)
    reload
    ;;
  *)
    echo "g|r"
esac
```