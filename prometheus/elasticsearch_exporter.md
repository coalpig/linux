```
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: prom
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
      scrape_timeout: 15s
    scrape_configs:
    - job_name: 'prometheus'
      static_configs:
      - targets: ['localhost:9090']
    - job_name: 'coredns'
      static_configs:
      - targets: ['kube-dns.kube-system:9153']
    - job_name: 'mysql'
      static_configs:
      - targets: ['10.103.30.229:9104']
    - job_name: 'redis_exporter_targets'
      static_configs:
      - targets:
        - redis-svc:6379
```

dp

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: elasticsearch-dp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: elasticsearch
  template:
    metadata:
      labels:
        app: elasticsearch
    spec:
      nodeName: node-02
      volumes:
      - name: es-data
        hostPath:
          path: /data/es/
          type: DirectoryOrCreate
      imagePullSecrets:
      - name: harbor-secret
      containers:
      - name: elasticsearch
        image: elasticsearch:7.9.1
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 9200
        - containerPort: 9300
        env:
        - name: discovery.type
          value: single-node

#        volumeMounts:
#        - name: es-data
#          mountPath: /usr/share/elasticsearch/data

      - name: elasticsearch-exporter
        image: quay.io/prometheuscommunity/elasticsearch-exporter:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 9114
        command:
        - /bin/elasticsearch_exporter
        args:
        - --es.uri=http://es-svc:9200
---
kind: Service
apiVersion: v1
metadata:
  name: es-svc
spec:
  selector:
    app: elasticsearch
  ports:
  - name: elasticsearch
    port: 9200
    targetPort: 9200
  - name: metrics
    port: 9114
    targetPort: 9114
```