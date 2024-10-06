### 5.1 nfs配置：

注意：Node节点也需要安装nfs客户端

```
yum install nfs-utils -y
cat > /etc/exports <<EOF
/data/k8s/nfs 10.0.0.0/8(rw,sync,no_root_squash)
EOF
systemctl restart nfs rpcbind
mkdir -p /data/k8s/nfs
chown -R nfsnobody:nfsnobody /data/k8s/nfs/
echo "nfs master ok" >> /data/k8s/nfs/index.html
```

### 5.2 创建PV

资源配置清单：

```
cat > pv-nfs.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-nfs
  labels:
    type: nfs  
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: nfs
  nfs:
    server: 10.0.0.11
    path: /data/k8s/nfs
EOF
kubectl apply -f pv-nfs.yaml
```

配置详解:

```
nfs:                                #存储类型是NFS
server: 10.0.0.11                   #NFS服务的IP地址  
path: /data/k8s/nfs        #NFS的共享目录路径
```

查看pv信息：

```
# kubectl get pv pv-nfs 
NAME     CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
pv-nfs   5Gi        RWO            Retain           Available           nfs                     38m
```

### 5.3 创建PVC

资源配置清单：

```
cat > pvc-nfs.yaml <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-nfs
spec:
  storageClassName: nfs
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
EOF
kubectl apply -f pvc-nfs.yaml
```

查看创建结果：

```
# kubectl get pvc pvc-nfs 
NAME      STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc-nfs   Bound    pv-nfs   5Gi        RWO            nfs            17s
```

创建POD使用PVC：

```
cat > pod-pvc-nfs.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: pod-pvc-nfs
spec:
  volumes:
  - name: pvc-nfs
    persistentVolumeClaim:
      claimName: pvc-nfs
  containers:
  - name: pod-pvc-nfs
    image: nginx:1.14.0
    ports:
    - containerPort: 80
    volumeMounts:
    - name: pvc-nfs
      mountPath: "/usr/share/nginx/html"
EOF
kubectl apply -f pod-pvc-nfs.yaml
```

查看创建的POD：

```
# kubectl get pod -o wide          
NAME               READY   STATUS    RESTARTS   AGE   IP          NODE      NOMINATED NODE   READINESS GATES
pod-pvc-hostpath   1/1     Running   0          17m   10.2.1.15   node1   <none>           <none>
pod-pvc-nfs        1/1     Running   0          2s    10.2.1.16   node1   <none>           <none>
```

测试访问：

```
# curl 10.2.1.16
nfs master ok
