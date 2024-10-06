Prometheus当前存在的问题

解决方案：

1.Thanos

2.VirtoriaMetrics

Thanos架构

VirtoriaMetrics架构

VirtoriaMetrics

`vmstorage`：数据存储以及查询结果返回，默认端口为 8482

`vminsert`：数据录入，可实现类似分片、副本功能，默认端口 8480

`vmselect`：数据查询，汇总和数据去重，默认端口 8481

`vmagent`：数据指标抓取，支持多种后端存储，会占用本地磁盘缓存，默认端口 8429

`vmalert`：报警相关组件，不如果不需要告警功能可以不使用该组件，默认端口为 8880

单节点方案;

```
# vm-single.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: victoria-metrics
  namespace: vm
spec:
  selector:
    matchLabels:
      app: victoria-metrics
  template:
    metadata:
      labels:
        app: victoria-metrics
    spec:
      volumes:
        - name: storage
          persistentVolumeClaim:
            claimName: victoria-metrics-data
      containers:
        - name: vm
          image: docker.m.daocloud.io/victoriametrics/victoria-metrics:v1.101.0
          imagePullPolicy: IfNotPresent
          args:
            - -storageDataPath=/var/lib/victoria-metrics-data # 指定数据存储目录
            - -retentionPeriod=1w # 数据保存周期
          ports:
            - containerPort: 8428
              name: http
          volumeMounts:
            - mountPath: /var/lib/victoria-metrics-data
              name: storage
---
apiVersion: v1
kind: Service
metadata:
  name: victoria-metrics
  namespace: vm
spec:
  type: NodePort
  ports:
    - port: 8428
  selector:
    app: victoria-metrics
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: victoria-metrics-data
spec:
  accessModes:
    - ReadWriteOnce
  capacity:
    storage: 20Gi
  storageClassName: local-storage
  local:
    path: /data/vm
  persistentVolumeReclaimPolicy: Retain
  nodeAffinity:
    required:
      nodeSelectorTerms:
        - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
                - node-02
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: victoria-metrics-data
  namespace: vm
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
  storageClassName: local-storage
```