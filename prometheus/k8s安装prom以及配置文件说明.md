
## 官方配置文件说明

https://prometheus.io/docs/prometheus/latest/configuration/configuration/

创建命名空间
```
kubectl create namespace prom
```

## 不同的命名空间需要创建不同的harbor认证
```
cat > harbor-secret.yaml << 'EOF'
apiVersion: v1
kind: Secret
metadata:
  name: harbor-secret
  namespace: prom
data:
  .dockerconfigjson: ewoJImF1dGhzIjogewoJCSJhYmMuY29tIjogewoJCQkiYXV0aCI6ICJZV1J0YVc0NlNHRnlZbTl5TVRJek5EVT0iCgkJfQoJfQp9
type: kubernetes.io/dockerconfigjson
EOF
```


## 编写configmap

```
cat > prom-cm.yml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: prom
data:
  prometheus.yml: |                 
    global:                     #全局配置
      scrape_interval: 15s      #抓取数据间隔
      scrape_timeout: 15s       #抓取超时时间
    scrape_configs:             #拉取配置
    - job_name: 'prometheus'    #任务名称
      static_configs:           #静态配置
      - targets: ['localhost:9090']     #抓取数据节点的IP端口
EOF
```

## 创建PV和PVC
node-01创建目录

```
mkdir /data/prometheus -p
```

```
cat > prom-pv-pvc.yml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: prometheus-local
  labels:
    app: prometheus
spec:
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 10Gi
  storageClassName: local-storage
  local:
    path: /data/prometheus
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - node-01
  persistentVolumeReclaimPolicy: Retain
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: prometheus-data
  namespace: prom
spec:
  selector:
    matchLabels:
      app: prometheus
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: local-storage
EOF
```

## 编写RBAC

```
cat > prom-rbac.yml << 'EOF'
apiVersion: v1
kind: ServiceAccount
metadata:
  name: prometheus
  namespace: prom
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: prometheus
rules:
- apiGroups:
  - ""
  resources:
  - nodes
  - services
  - endpoints
  - pods
  - nodes/proxy
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - "extensions"
  resources:
  - ingresses
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - configmaps
  - nodes/metrics
  verbs:
  - get
- nonResourceURLs:
  - /metrics
  verbs:
  - get
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: prometheus
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: prometheus
subjects:
- kind: ServiceAccount
  name: prometheus
  namespace: prom
EOF
```

## 编写deployment

```
cat > prom-dp.yml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
  namespace: prom
  labels:
    app: prometheus
spec:
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      serviceAccountName: prometheus				#引用RBAC创建的ServiceAccount
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: prometheus-data
      - name: config-volume  
        configMap:
          name: prometheus-config  
      initContainers:					#由初始化容器将数据目录的属性修改为nobody用户和组
      - name: fix-permissions
        image: abc.com/base/busybox
        command: [chown, -R, "nobody:nobody", /prometheus]
        volumeMounts:
        - name: data
          mountPath: /prometheus
      containers:
      - name: prometheus
        image: abc.com/prom/prometheus:v2.24.1
        resources:
          requests:
            cpu: 100m
            memory: 512Mi
          limits:
            cpu: 100m
            memory: 512Mi
        ports:
        - name: http
          containerPort: 9090            
        args:
        - "--config.file=/etc/prometheus/prometheus.yml"	#指定配置文件
        - "--storage.tsdb.path=/prometheus" 	 			#tsdb数据库保存路径
        - "--storage.tsdb.retention.time=24h"	 	        #数据保留时间，默认15天
        - "--web.enable-admin-api"  						#控制对admin HTTP API的访问
        - "--web.enable-lifecycle"                          #支持热更新，直接执行localhost:9090/-/reload立即生效
        volumeMounts:
        - name: config-volume
          mountPath: "/etc/prometheus"
        - name: data
          mountPath: "/prometheus"
EOF
```

## 编写Service

```
cat > prom-svc.yml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: prometheus
  namespace: prom
  labels:
    app: prometheus
spec:
  selector:
    app: prometheus
  ports:
    - name: web
      port: 9090
      targetPort: http
EOF
```

## 编写ingress

```
cat > prom-ingress.yml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: prometheus
  namespace: prom
  labels:
    app: prometheus
spec:
  rules:
  - host: prom.k8s.com
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: prometheus
            port:
              number: 9090
EOF
```

## 访问promtheus

http://prom.k8s.com
