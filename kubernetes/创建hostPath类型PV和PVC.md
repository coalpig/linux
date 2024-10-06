### 4.1 创建PV

创建数据目录：因为hostPath使用的是宿主机目录，所以这种类型的PV需要POD绑定到固定的Node节点上才能保证POD删除后再创建数据还能继续使用，这样就大大降低了POD的灵活性，不过我们还是先在node1上创建数据目录及文件来测试。这里选择在node1节点上操作。

```
mkdir /data/k8s/hostpath -p
echo "hostpath node1 ok" >> /data/k8s/hostpath/index.html
```

资源配置清单：

```
cat > pv-hostpath.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-hostpath
  labels:
    type: local
spec:
  storageClassName: hostpath
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain  
  hostPath:
    path: "/data/k8s/hostpath"
EOF
kubectl apply -f pv-hostpath.yaml
```

配置详解：

```
capacity:  PV存储的容量
------------------------------------------------------
accessModes: 访问模式,k8s支持的访问模式如下
- ReadWriteOnce(RWO): 读写权限，并且只能被单个Node挂载
- ReadOnlyMany(ROX):  只读权限，允许被多个Node挂载
- ReadWriteMany(RWX): 读写权限，允许被多个Node挂载
------------------------------------------------------
persistentVolumeReclaimPolicy: 回收策略
- Retain: 保留数据，需要手工处理
- Recycle: 简单清除文件的操作(例如运行rm -rf /dada/* 命令)
- Delete: 与PV相连的后端存储完成Volume的删除操作
目前只有NFS和HostPath两种类型的PV支持Recycle策略。
------------------------------------------------------
storageClassName: 存储类别
具有特定类别的PV只能与请求了该类别的PVC绑定。未指定类型的PV则只能对与不请求任何类别的PVC绑定。
------------------------------------------------------
hostPath:       #存储类型是hostpath,即会在宿主机目录上创建相应的路径
  path: "/data/k8s/hostpath"        #宿主机创建的目录
```

查看创建的PV：

```
kubectl get pv
kubectl describe pv pv-hostpath
```

PV状态解释：

```
Avaliable（可用）：可用状态，还未被任何PVC绑定
Bound（可绑定）：PV已经被PVC绑定
Released（已释放）：PVC被删除，但是资源未被回收，不能被其他PVC使用
Failed（失败）：该PV的自动回收失败
```

### 4.2 创建PVC

资源配置清单：

```
cat > pvc-hostpath.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-hostpath
spec:
  storageClassName: hostpath
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
EOF
kubectl apply -f pvc-hostpath.yaml
```

资源配置详解：

```
accessModes: 访问模式，与PV定义的一样
------------------------------------------------------
resources: 描述对存储资源的请求，设置需要的存储空间大小
------------------------------------------------------
storageClassName: 存储类别，与PV的存储类型相匹配
```

查看创建的PVC:

```
[root@master-10 ~]# kubectl get pvc
NAME           STATUS   VOLUME        CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc-hostpath   Bound    pv-hostpath   10Gi       RWO            hostpath       56s
```

PVC状态解释：

通过查看pvc状态可以看到STATUS字段显示的状态为Bound，这里表示PVC已经与PV进行了绑定

查看PVC绑定状态：

```
[root@master-10 ~]# kubectl describe pvc pvc-hostpath 
Name:          pvc-hostpath
Namespace:     default
StorageClass:  hostpath						#PV的StorageClass名称
Status:        Bound						#PV已经与PVC绑定
Volume:        pv-hostpath					#绑定的PV
Labels:        <none>
Annotations:   pv.kubernetes.io/bind-completed: yes
               pv.kubernetes.io/bound-by-controller: yes
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      10Gi							#PV生命的容量
Access Modes:  RWO							#访问模式
VolumeMode:    Filesystem
Mounted By:    <none>
Events:        <none>
```

### 4.3 创建POD

pv和pvc已经创建好了，接下来我们就可以创建POD来使用PVC了

资源配置清单：注意，因为我们hostpath目录只在node1上创建了，所以这里我们需要手动将POD调度到Node1节点上才能使用这个PV。

```
cat > pod-pvc-hostpath.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: pod-pvc-hostpath
spec:
  volumes:
  - name: pvc-hostpath
    persistentVolumeClaim:
      claimName: pvc-hostpath
  nodeSelector:
    kubernetes.io/hostname: node1
  containers:
  - name: pod-pvc-hostpath
    image: nginx:1.14.0
    ports:
    - containerPort: 80
    volumeMounts:
    - name: pvc-hostpath
      mountPath: "/usr/share/nginx/html"
EOF
kubectl apply -f pod-pvc-hostpath.yaml
```

查看POD创建的情况：

```
[root@master-10 yaml]# kubectl get pod
NAME               READY   STATUS    RESTARTS   AGE
pod-pvc-hostpath   1/1     Running   0          42s

[root@master-10 yaml]# kubectl get pod -o wide
NAME               READY   STATUS    RESTARTS   AGE   IP          NODE      NOMINATED NODE   READINESS GATES
pod-pvc-hostpath   1/1     Running   0          42s   10.2.1.14   node-20   <none>           <none>
```

测试访问：

```
[root@master-10 yaml]# curl 10.2.1.14
hostpath node1 ok
```

删除POD然后再重新创建之后测试：

```
# kubectl delete pod pod-pvc-hostpath 
pod "pod-pvc-hostpath" deleted

# kubectl apply -f pod-pvc-hostpath.yaml 
pod/pod-pvc-hostpath created

# kubectl get pod
NAME               READY   STATUS    RESTARTS   AGE
pod-pvc-hostpath   1/1     Running   0          2s

# kubectl get pod -o wide
NAME               READY   STATUS    RESTARTS   AGE   IP          NODE      NOMINATED NODE   READINESS GATES
pod-pvc-hostpath   1/1     Running   0          4s    10.2.1.15   node-20   <none>           <none>

# curl 10.2.1.15
hostpath node1 ok
```
