虽然我们创建的是Deployment类型资源，但实际上控制副本还是由RS来控制的，Deployment只是替我们去创建RS控制器，然后再由RS去控制POD副本.

```
apiVersion: apps/v1
kind: Deployment #副本类型
metadata:
  name: nginx-dp #副本的名称
  labels:
    app: nginx-dp #副本的标签
spec:
  # 按你的实际情况修改副本数
  replicas: 3 #复本数量
  selector:
    matchLabels:
      app: nginx-dp #pod的标签
  template:
    metadata:
      name: nginx-dp #pod的名称
      labels:
        app: nginx-dp #pod的标签
    spec:
      containers:
      - name: nginx-dp #容器名称
        image: nginx
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
  #以上注释中，pod的标签名要一模一样
```

每一个新dp发布后，旧的dp都会保留
如果dp新发布版本后，会先创建一个新版本的pod，新版本pod创建成功才会吧旧的删除
依次类推


## Deployment控制器

### 1）Deployment和RS控制器的关系

Deployment创建ReplicaSet

由ReplicaSet创建并控制Pod使用保持期望数量在运行

更新版本时Deployment创建新版本的ReplicaSet实现Pod的轮询升级

### 2）资源配置清单

```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx-dp
  name: nginx-dp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-dp
  template:
    metadata:
      labels:
        app: nginx-dp
      name: nginx-dp
    spec:
      containers:
      - image: nginx
        imagePullPolicy: IfNotPresent
        name: nginx-dp
```

### 3）应用资源配置清单

```
kubectl create -f nginx-dp.yaml
```

### 4）查看dp资源信息

```
kubectl get pod -o wide
kubectl get deployments.apps
kubectl describe deployments.apps nginx-dp
```

### 5）更新版本

方法1: 命令行根据资源配置清单修改镜像

```
kubectl set image -f nginx-dp.yaml nginx-containers=nginx:1.24.0
```

查看有没有更新

```
kubectl get pod 
kubectl describe deployments.apps nginx-dp
kubectl describe pod nginx-dp-7c596b4d95-6ztld
```

方法2: 命令行根据资源类型修改镜像打开2个窗口：第一个窗口监控pod状态

```
 kubectl get pod -w
```

第二个窗口更新操作

```
kubectl set image deployment nginx-dp nginx-dp=nginx:1.24
kubectl set image deployment nginx-dp nginx-dp=nginx:1.25
```

查看更新后的deployment信息

```
kubectl describe deployments.apps nginx-dp 
 ----------------------------------------------------
   Normal  ScalingReplicaSet  14m                  deployment-controller  Scaled up replica set nginx-dp-7c596b4d95 to 1
   Normal  ScalingReplicaSet  14m                  deployment-controller  Scaled down replica set nginx-dp-9c74bb6c7 to 1
   Normal  ScalingReplicaSet  14m                  deployment-controller  Scaled up replica set nginx-dp-7c596b4d95 to 2
   Normal  ScalingReplicaSet  13m                  deployment-controller  Scaled down replica set nginx-dp-9c74bb6c7 to 0
   Normal  ScalingReplicaSet  8m30s                deployment-controller  Scaled up replica set nginx-dp-9c74bb6c7 to 1
   Normal  ScalingReplicaSet  8m29s (x2 over 32m)  deployment-controller  Scaled up replica set nginx-dp-9c74bb6c7 to 2
   Normal  ScalingReplicaSet  8m29s                deployment-controller  Scaled down replica set nginx-dp-7c596b4d95 to 1
   Normal  ScalingReplicaSet  8m28s                deployment-controller  Scaled down replica set nginx-dp-7c596b4d95 to 0
```

更新过程：

```
nginx-dp-7c596b4d95-8z7kf   #老的版本
nginx-dp-7c596b4d95-6ztld   #老的版本

nginx-dp-9c74bb6c7-pgfxz    0/1     Pending   
nginx-dp-9c74bb6c7-pgfxz    0/1     Pending
nginx-dp-9c74bb6c7-pgfxz    0/1     ContainerCreating  #拉取新版本镜像
nginx-dp-9c74bb6c7-pgfxz    1/1     Running            #运行新POD
nginx-dp-7c596b4d95-8z7kf   1/1     Terminating        #停止一个旧的POD
nginx-dp-9c74bb6c7-h7mk2    0/1     Pending            
nginx-dp-9c74bb6c7-h7mk2    0/1     Pending           
nginx-dp-9c74bb6c7-h7mk2    0/1     ContainerCreating  #拉取新版本镜像
nginx-dp-9c74bb6c7-h7mk2    1/1     Running            #运行新POD
nginx-dp-7c596b4d95-6ztld   1/1     Terminating        #停止一个旧的POD
nginx-dp-7c596b4d95-8z7kf   0/1     Terminating        #等待旧的POD结束
nginx-dp-7c596b4d95-6ztld   0/1     Terminating        #等待旧的POD结束
```

查看滚动更新状态：

```
kubectl rollout status deployment nginx-dp
```

滚动更新示意图：![](https://cdn.nlark.com/yuque/0/2024/webp/830385/1724978350814-231f283a-665a-469e-aa0e-27fda4c5336b.webp?x-oss-process=image%2Fwatermark%2Ctype_d3F5LW1pY3JvaGVp%2Csize_35%2Ctext_6Lev6aOe5a2m5Z-O%2Ccolor_FFFFFF%2Cshadow_50%2Ct_80%2Cg_se%2Cx_10%2Cy_10)

### 6）回滚上一个版本

```
kubectl describe deployments.apps nginx-dp 
kubectl rollout undo deployment nginx-dp
kubectl describe deployments.apps nginx-dp
```

### 7）回滚到指定版本

v1 1.14.0 v2 1.15.0 v3 3.333.3回滚到v1版本

创建第一版 1.24.0

```
kubectl create -f nginx-dp.yaml  --record
```

更新第二版 1.25.0

```
kubectl set image deployment nginx-dp nginx-dp=nginx:1.25.0
```

更新第三版 1.99.0（故意写错）

```
kubectl set image deployment nginx-dp nginx-dp=nginx:1.99.0
```

查看所有历史版本

```
 kubectl rollout history deployment nginx-dp
```

查看指定历史版本信息

```
 kubectl rollout history deployment nginx-dp --revision=1
```

回滚到指定版本

```
 kubectl rollout undo deployment nginx-dp --to-revision=1
```

### 8）扩缩容

```
kubectl scale deployment nginx-dp --replicas=5
kubectl scale deployment nginx-dp --replicas=2
```

总结：

动态修改镜像版本

kubectl set image deployment nginx-dp nginx-dp=nginx:1.24

kubectl set image deployment nginx-dp nginx-dp=nginx:1.25

查看所有历史版本

kubectl rollout history deployment nginx-dp

查看指定历史版本号

kubectl rollout history deployment nginx-dp --revision=2

回滚上一次

kubectl rollout undo deployment nginx-dp

回滚到指定版本

kubectl rollout undo deployment nginx-dp --to-revision=1

扩/缩容

kubectl scale deployment/nginx-dp --replicas=10




