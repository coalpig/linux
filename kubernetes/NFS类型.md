
### 4.1 NFS类型说明

我们也可以直接使用Node节点自己本身的nfs软件将共享目录挂载到Pod里，前提是NFS服务已经安装配置好，并且Node节点上安装了NFS客户端软件。

### 4.2 创建NFS服务

```
yum install nfs-utils -y
cat > /etc/exports << 'EOF'
/data/nfs-volume/blog *(rw,sync,no_root_squash)
EOF
mkdir -p /data/nfs-volume/blog
systemctl restart nfs
```

### 4.3 创建NFS类型资源清单

```
apiVersion: v1
kind: Pod
metadata:
  name: liveness-pod
spec:
  nodeName: node2

  volumes: 
  - name: nfs-data
    nfs:
      server: 10.0.0.11
      path: /data/nfs-volume/
  containers:
  - name: liveness
    image: nginx 
    imagePullPolicy: IfNotPresent
    ports:
    - name: http
      containerPort: 80
    volumeMounts:
    - name: nfs-data
      mountPath: /usr/share/nginx/html/
```
