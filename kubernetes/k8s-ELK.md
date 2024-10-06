# es
es-local-pv-pvc

```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: es-pv1
  labels:
    type: local
spec:
  storageClassName: local-storage
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  local:
    path: /data/es
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - node-01
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: es-pv2
  labels:
    type: local
spec:
  storageClassName: local-storage
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  local:
    path: /data/es
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - node-02
```

无头svc
es-svc-headless

```
apiVersion: v1
kind: Service
metadata:
  name: es
  labels:
    app: es
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None #无头配置
  selector:
    app: es
```

es-statefulset
创建有状态资源类型

```
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: es
spec:
  serviceName: "es"
  replicas: 2
  selector:
    matchLabels:
      app: es
  template:
    metadata:
      labels:
        app: es
    spec:
      imagePullSecrets:
      - name: harbor-secret
      containers:
      - name: es
        image: abc.com/base/elasticsearch:7.9.1
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
          name: log
        volumeMounts:
        - name: log
          mountPath: /usr/share/elasticsearch/data
        env:
          - name: cluster.name
            value: "es-k8s"
          - name: node.name
            valueFrom:
              fieldRef:
                fieldPath: metadata.name
          - name: discovery.seed_hosts
            value: "es-0.es,es-1.es"
          - name: cluster.initial_master_nodes
            value: "es-0,es-1"
          - name: ES_JAVA_OPTS
            value: "-Xms512m -Xmx512m"

  volumeClaimTemplates:
  - metadata:
      name: log
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
      storageClassName: local-storage
```

es-svc-clusterip
创建clusterip可以让其他pod访问，也可以让ingress访问

```
apiVersion: v1
kind: Service
metadata:
  name: cluster
spec:
  type: ClusterIP
  selector:
    app: es
  ports:
    - name: http
      protocol: TCP
      port: 9200
      targetPort: 9200
```

创建ingress可以映射域名

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: es-ingress
spec:
  ingressClassName: nginx
  rules:
  - host: www.es.com
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: cluster
            port:
              number: 9200
```

# filebeat
对于filebeat有两种方法
- daemonset方法，将每个pod中的nginx的日志用不用的名字挂载到宿主机
- 边车模式deploy每个pod启动两个容器，两个容器定义一个emptyDir

## 边车模式deploy法
首先需要准备好

- filebeat配置文件，使用configmap
- nginx使用json格式需要nginx主配置文件



filebeat.yaml
如果需要修改日志类型和格式可以kubectl edit
```
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/nginx/access.log
  json.keys_under_root: true
  json.overwrite_keys: true

output.elasticsearch:
  hosts: ["cluster:9200"]
```

nginx.conf

```
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    log_format json '{ "time_local": "$time_local", '
                              '"remote_addr": "$remote_addr", '
                              '"referer": "$http_referer", '
                              '"request": "$request", '
                              '"status": $status, '
                              '"bytes": $body_bytes_sent, '
                              '"http_user_agent": "$http_user_agent", '
                              '"x_forwarded": "$http_x_forwarded_for", '
                              '"up_addr": "$upstream_addr",'
                              '"up_host": "$upstream_http_host",'
                              '"upstream_time": "$upstream_response_time",'
                              '"request_time": "$request_time"'
        ' }';

    access_log  /var/log/nginx/access.log  json;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}
```

接下来创建两个configmap

```
kubectl create configmap filebeat-cm --from-file=filebeat=./filebeat.yaml

kubectl create configmap nginx-cm --from-file=nginx=./nginx.conf
```
nginx-filebeat-statefulset

两个容器，一个业务容器，一个采集日志容器

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      imagePullSecrets:
      - name: harbor-secret
      containers:
#nginx
      - name: nginx-pod
        image: nginx
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
        volumeMounts:
        - name: filebeat-log
          mountPath: /var/log/nginx

        - name: nginx-cm
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf

#filebeat
      - name: filebeat
        image: abc.com/base/filebeat:7.9.1
        imagePullPolicy: IfNotPresent

        args: [
          "-c", "/etc/filebeat.yaml",
          "-e",
        ]

        env:
        - name: ELASTICSEARCH_HOST
          value: cluster
        - name: ELASTICSEARCH_PORT
          value: "9200"

        volumeMounts:

        - name: filebeat-log
          mountPath: /var/log/nginx

        - name: filebeat-cm
          mountPath: /etc/filebeat.yaml
          subPath: filebeat.yaml

#volumes
      volumes:
      - name: filebeat-cm
        configMap:
         name: filebeat-cm
         items:
         - key: filebeat
           path: filebeat.yaml

      - name: nginx-cm
        configMap:
         name: nginx-cm
         items:
         - key: nginx
           path: nginx.conf

      - name: filebeat-log
        emptyDir: {}
```

接下来可以创建clusterip

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
spec:
  type: ClusterIP
  selector:
    app: nginx
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 80
```

外网创建ingree

# daemonset 方法中filebeat配置
基于边车模式将nginx和filebeat拆开


nginx-dp

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-dp #取这里的变量
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      imagePullSecrets:
      - name: harbor-secret
      containers:
      - name: nginx-pod
#nginx
        env:  #加入变量，识别自己资源配置中的pod name
          - name: POD_NAME
            valueFrom:
              fieldRef:
                apiVersion: v1
                fieldPath: metadata.name
        image: nginx
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
        volumeMounts:

        - name: nginx-log
          mountPath: /var/log/nginx 
          subPathExpr: $(POD_NAME)  #设置的变量更改pod中的路径为/var/log/nginx/nginx-dp(自动创建的id)

        - name: nginx-cm
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf

#volumes
      volumes:
      - name: nginx-cm
        configMap:
         name: nginx-cm
         items:
         - key: nginx
           path: nginx.conf

      - name: nginx-log
        hostPath:
          path: /data/log
          type: DirectoryOrCreate #宿主机自动创建目录
```

filebeat-daemonset

```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: filebeat
spec:
  selector:
    matchLabels:
      app: filebeat
  template:
    metadata:
      labels:
        app: filebeat
    spec:
#nodeName: node-01
      imagePullSecrets:
      - name: harbor-secret
      containers:
#filebeat
      - name: filebeat
        image: abc.com/base/filebeat:7.9.1
        imagePullPolicy: IfNotPresent

        args: [
          "-c", "/etc/filebeat.yaml",
          "-e",
        ]

        env:
        - name: ELASTICSEARCH_HOST
          value: cluster
        - name: ELASTICSEARCH_PORT
          value: "9200"

        volumeMounts:

        - name: nginx-log
          mountPath: /var/log/nginx

        - name: filebeat-cm
          mountPath: /etc/filebeat.yaml
          subPath: filebeat.yaml

#volumes
      volumes:
      - name: filebeat-cm
        configMap:
         name: filebeat-cm
         items:
         - key: filebeat
           path: filebeat.yaml

      - name: nginx-cm
        configMap:
         name: nginx-cm
         items:
         - key: nginx
           path: nginx.conf

      - name: nginx-log
        hostPath:
          path: /data/log
```




