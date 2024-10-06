hostPath使用的是宿主机的目录，并且我们的POD不能随意漂移到其他节点上，所以我们使用hostPath类型的PV时，都会使nodeSelector将POD固定在指定的node节点上。这样做的好处是因为使用的是本地磁盘，所以速度快，但是缺点是如果宿主机宕机了不太好恢复数据,而且如果使用宿主机目录，很容易造成磁盘占完导致宿主机的系统崩溃。

k8s在hostPath的基础上，实现了一个新特性叫LocalPV，他其实和hostPath加上nodeSelector实现的效果类似，区别在对于普通pv来说，k8s是先调度POD到节点上，然后再持久化节点上的数据目录与POD挂载。而LocalPV则是需要提前在节点准备好，但不一定所有节点都具备这个类型的磁盘，所以k8s调度的时候会先知道所有节点与LocalPV指定的磁盘的关系，也就是说，先确定哪些节点可以调度，再去调度POD。另外一个区别则是LocalPV应该是一块独立的磁盘挂载在宿主机上，这样做的好处一个是磁盘IO独享，另外加入宿主机故障了，只需要将磁盘插到其他节点上就能继续使用上面的数据。

```
普通PV：调度POD到某个节点  --> 持久化数据目录 --> 数据目录绑定POD
LocalPV: 筛选符合LocalPV调度的节点 --> 调度POD到LocalPV节点 --> 持久化数据目录 --> 数据目录绑定POD
```

### 6.1 数据目录准备

这里我们给虚拟机新增加一块独立的磁盘，然后格式化磁盘并挂载到node1节点的宿主机目录上。但是由于我们的虚拟机都是链接克隆的，而VM对链接克隆的虚拟机不支持添加新硬盘。所以我们这里就直接创建目录来模拟独立挂载的磁盘，接下来我们在node2上创建数据目录。

```
 mkdir /data/k8s/localpv -p
```

### 6.2 创建Local PV

资源配置：

```
cat > pv-local.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-local
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  local:
    path: /data/k8s/localpv
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - node1
EOF
```

配置解释：

这里的配置和hostpath类似，只是多了节点亲和性，这样调度器在调度pod的时候，能够知道pv和节点之间的关系。

查看状态：

```
# kubectl get pv
NAME       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS    REASON   AGE
pv-local   5Gi        RWO            Retain           Available           local-storage            2m24s
```

### 6.3 创建Local PVC

```
cat > pvc-local.yaml << 'EOF'
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: pvc-local
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: local-storage
EOF
```

查看创建结果：

```
# kubectl get pvc
NAME        STATUS   VOLUME     CAPACITY   ACCESS MODES   STORAGECLASS    AGE
pvc-local   Bound    pv-local   5Gi        RWO            local-storage   20s
```

但是这时候有个问题，那就是如果我node1和node2都有Local类型的PV，storageClassName都叫ocal-storage，这个时候创建PVC的时候直接绑定到了node1上，但是我的POD调度的时候指定要在Node2上，这样就变成POD在node2，但是却绑定了Node1上的LocalPV，这肯定是不符合要求的，所以会调度失败。下面我们来演示一下：

创建Node2的PV，storageClassName也是local-storage

```
cat > pv-local-node2.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-local-node2
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  local:
    path: /data/k8s/localpv
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - node2
EOF
```

查看执行结果：

```
# kubectl get pv
NAME             CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM               STORAGECLASS    REASON   AGE
pv-local         5Gi        RWO            Retain           Bound       default/pvc-local   local-storage            23m
pv-local-node2   5Gi        RWO            Retain           Available                       local-storage            15m
```

这个时候会发现pvc绑定的是node1的pv，那么假如这时候我创建一个POD，但是指定运行在node2上，会发生什么事情呢

```
cat > pod-pvc-local.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: pod-pvc-local
spec:
  volumes:
  - name: pvc-local
    persistentVolumeClaim:
      claimName: pvc-local
  containers:
  - name: pod-pvc-local
    image: nginx:1.14.0
    ports:
    - containerPort: 80
    volumeMounts:
    - name: pvc-local
      mountPath: "/usr/share/nginx/html"
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: kubernetes.io/hostname
            operator: In
            values:
            - node2 
EOF
kubectl apply -f pod-pvc-local.yaml
```

查看创建结果：我们会发现状态时Pending，因为我们绑定的节点在Node2,但是PVC帮的PV在node1

```
# kubectl get pod
NAME            READY   STATUS    RESTARTS   AGE
pod-pvc-local   0/1     Pending   0          22s
```

查看详细信息：

```
# kubectl describe pod pod-pvc-local
Events:
  Type     Reason            Age                 From               Message
  ----     ------            ----                ----               -------
  Warning  FailedScheduling  12s (x5 over 2m5s)  default-scheduler  0/3 nodes are available: 1 node(s) had volume node affinity conflict, 2 node(s) didn't match node selector.
```

为什么会导致这种现象？那是因为正常流程是创建PVC的时候立刻就绑定了PV，没有考虑到POD调度的情况，所以我们需要延迟PVC绑定PV的操作，直到第一个声明使用这个PVC的POD被创建出来的时候PVC才会和PV进行绑定。

原来：PVC-->PV-->POD调度

延迟：POD调度-->PVC-->PV

那么如何实现这个延迟操作呢？这就需要使用一个新的资源类型叫StorageClass，我们需要利用StorageClass里的延迟绑定特性。

资源配置：

```
cat > local-storageclass.yaml << 'EOF'
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
EOF
kubectl apply -f local-storageclass.yaml
```

配置解释：

```
apiVersion: storage.k8s.io/v1
kind: StorageClass                            #资源类型
metadata:
  name: local-storage                         #和PV里定义的名字一样
provisioner：kubernetes.io/no-provisioner      #不自动创建PV，因为LocalPV不支持自动创建PV，我们是手动创建
volumeBindingMode：WaitForFirstConsumer        #延迟PVC绑定PV的操作，等到POD被创建时才绑定
```

首先我们删除之前创建的POD和PVC，恢复成只有两个PV和没有POD没有PVC被创建的状态

```
# kubectl get pod
No resources found in default namespace.

# kubectl get pvc
No resources found in default namespace.

# kubectl get pv
NAME             CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS    REASON   AGE
pv-local         5Gi        RWO            Retain           Available           local-storage            43m
pv-local-node2   5Gi        RWO            Retain           Available           local-storage            35m
```

然后我们创建PVC，因为我们设置了绑定延迟，所以这时候PVC不会直接和PV绑定。

```
# kubectl apply -f pvc-local.yaml 
persistentvolumeclaim/pvc-local created

# kubectl get pvc
NAME        STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS    AGE
pvc-local   Pending                                      local-storage   2s
```

查看PVC详情：

```
# kubectl describe pvc pvc-local
Events:
  Type    Reason                Age               From                         Message
  ----    ------                ----              ----                         -------
  Normal  WaitForFirstConsumer  5s (x3 over 29s)  persistentvolume-controller  waiting for first consumer to be created before binding
```

此时PVC在等待我们创建的POD，那么现在我们创建运行在node2的pod，看看PVC会不会绑定到node2的PV

```
# kubectl apply -f pod-pvc-local.yaml 
pod/pod-pvc-local created

# kubectl get pvc
NAME        STATUS   VOLUME           CAPACITY   ACCESS MODES   STORAGECLASS    AGE
pvc-local   Bound    pv-local-node2   5Gi        RWO            local-storage   2m13s
```

可以发现PVC绑定到了正确的PV上，POD也顺利创建出来了。

```
# kubectl get pod
NAME            READY   STATUS    RESTARTS   AGE
pod-pvc-local   1/1     Running   0          75s
```

### 6.x pvc删除后显示Released状态

Released是因为我们的PVC配置的模式是Retain，所以PVC删除后并不会清空数据，此时pv会是已释放状态，但是资源还没有被认领，我们在确定数据备份了的前提下可以通过修改PV来将pv恢复到Available状态

官方解释：

https://kubernetes.io/zh/docs/concepts/storage/persistent-volumes/#reclaiming

未编辑前：

```
[root@master ~]# kubectl get pv
NAME             CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM               STORAGECLASS    REASON   AGE
pv-local         5Gi        RWO            Retain           Released   default/pvc-local   local-storage            21m
pv-local-node2   5Gi        RWO            Retain           Released   default/pvc-local   local-storage            13m
```

编辑PV，然后删除claimRef字段

```
kubectl edit pv pv-local
 ----------------------------------------------
  claimRef:
     apiVersion: v1
     kind: PersistentVolumeClaim
     name: pvc-local
     namespace: default
     resourceVersion: "200673"
     uid: e28ba817-636a-4776-99f9-a3522706bc8c
```

删除后再次查看：

```
[root@master ~/k8s_yml/PVPVC]# kubectl get pv
NAME             CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM               STORAGECLASS    REASON   AGE
pv-local         5Gi        RWO            Retain           Available                       local-storage            21m
pv-local-node2   5Gi        RWO            Retain           Released    default/pvc-local   local-storage            13m
```

