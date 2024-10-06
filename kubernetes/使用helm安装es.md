```
#添加仓库
helm repo add elastic https://helm.elastic.co

#更新仓库
helm repo update

#获取默认变量
helm show values elastic/elasticsearch --version 7.17.3


#创建PV
cat > es-pv.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: localpv01
  labels:
    type: localpv
spec:
  storageClassName: localpv
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  local:
    path: "/data/es"
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - master-01
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: localpv02
  labels:
    type: localpv
spec:
  storageClassName: localpv
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  local:
    path: "/data/es"
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
  name: localpv03
  labels:
    type: localpv
spec:
  storageClassName: localpv
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  local:
    path: "/data/es"
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - node-02
EOF

#变量文件
cat > es-values-7173.yaml << 'EOF'
image: "abc.com/base/elasticsearch"
imageTag: "7.17.3"
imagePullPolicy: "IfNotPresent"

imagePullSecrets: 
- name: harbor-secret

resources:
  requests:
    cpu: "10m"
    memory: "512Mi"
  limits:
    cpu: "100m"
    memory: "512Mi"

volumeClaimTemplate:
  accessModes: ["ReadWriteOnce"]
  storageClassName: localpv
  resources:
    requests:
      storage: 30Gi

ingress:
  enabled: true
  hosts:
    - host: es.local
      paths:
        - path: /
EOF

#创建应用
helm install -f es-values-7173.yaml my-es elastic/elasticsearch --version 7.17.3
```