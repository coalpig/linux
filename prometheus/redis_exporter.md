
更新和重载配置文件的脚本
```
#!/bin/bash

get(){
  kubectl -n prom exec -it $(kubectl -n prom get pod | awk "NR>1"'{print $1}') -- cat /etc/prometheus/prometheus.yml
}

reload(){
  curl -X POST "http://$(kubectl -n prom get svc|awk 'NR>1{print $3}'):9090/-/reload"
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

redis-dp和exporter
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-dp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      nodeName: node-01
      volumes:
      - name: redis-data
        hostPath:
          path: /data/redis/
          type: DirectoryOrCreate
      imagePullSecrets:
      - name: harbor-secret
      containers:
      - name: redis
        image: redis
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 6379
        volumeMounts:
        - name: redis-data
          mountPath: /usr/local/etc/redis
      - name: redis-exporter
        image: quay.io/oliver006/redis_exporter
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 9121
---
kind: Service
apiVersion: v1
metadata:
  name: redis-svc
spec:
  selector:
    app: redis
  ports:
  - name: redis
    port: 6379
    targetPort: 6379
  - name: metrics
    port: 9121
    targetPort: 9121
```