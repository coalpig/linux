![](attachments/Pasted%20image%2020240922094617.png)


首先需要创建mysql+mysql-exporter

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
```

接着mysql-svc使得mysql可以通过名称访问

```
kind: Service
apiVersion: v1
metadata:
  name: mysql-svc
  labels:
    app: mysql-svc
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

创建mysql-Monitor

```
apiVersion: monitoring.coreos.com/v1    #monitor的版本
kind: ServiceMonitor                    #monitor自己的类型
metadata:
  name: mysql-monitor                   #monitor的名称
  labels:                               #这里可以不写,monitor的labels
    app: mysql-dp                       #这里可以不写,monitor的labels
  namespace: monitoring                 #这个命名空间要和dp的一样
spec:
  endpoints:
  - bearerTokenFile: /var/run/secrets/kubernetes.io/serviceaccount/token	#token文件
    interval: 30s			#每30s获取一次信息
    port: metrics			#对应的Service端口名称
  jobLabel: k8s-app		    #用户从中检索任务名称标签
  namespaceSelector:	    #匹配某一个命名空间的Service
    matchNames:				#匹配的命名空间名称
    - default					
  selector:					#匹配的Service的labels
    matchLabels:
      app: mysql-svc            svc的标签
```