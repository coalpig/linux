官方网址：

[https://helm.sh/zh/docs/](https://helm.sh/zh/docs/)


```
1.安装helm
wget https://get.helm.sh/helm-v3.16.1-linux-amd64.tar.gz
tar zxf helm-v3.16.1-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/
helm version

2.添加仓库
#仓库网址
https://artifacthub.io/packages/search?kind=0

#查看仓库列表
helm repo list

#添加仓库
helm repo add bitnami https://charts.bitnami.com/bitnami

#更新仓库
helm repo update


3.实战-mysql
#添加仓库
helm repo add wso2 https://helm.wso2.com

#更新仓库
helm repo update

#获取默认变量
helm show values wso2/mysql --version 1.6.9

#创建PV
cat > mysql-pv.yaml << 'EOF'
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-pv
  labels:
    type: local
spec:
  storageClassName: localpv
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  local:
    path: /mnt
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - node-01
EOF

#替换变量
cat > mysql-vaules.yaml << 'EOF'
imagePullPolicy: IfNotPresent
imagePullSecrets:
- name: harbor-secret

image: "abc.com/base/mysql"
imageTag: "5.7"

busybox:
  image: "abc.com/base/busybox"
  tag: "latest"

persistence:
  enabled: true
  storageClass: "localpv"
  accessMode: ReadWriteOnce
  size: 5Gi

service:
  type: ClusterIP
  port: 3306
EOF

#创建应用
helm install -f mysql-vaules.yaml my-mysql wso2/mysql --version 1.6.9

#获取登录密码
MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default my-mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo)

#登录Pod
kubectl exec -it  my-mysql-xxxxxxxx -- mysql -uroot -p${MYSQL_ROOT_PASSWORD}
```