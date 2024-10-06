```yaml
apiVersion: apps/v1
kind: ReplicaSet #副本类型
metadata:
  name: nginx-rs #副本的名称
  labels:
    app: nginx-rs-lable #副本的标签
spec:
  # 按你的实际情况修改副本数
  replicas: 3 #复本数量
  selector:
    matchLabels:
      app: nginx-pod-lable #pod的标签
  template:
    metadata:
      name: nginx-pod #pod的名称
      labels:
        app: nginx-pod-lable #pod的标签
    spec:
      containers:
      - name: nginx-container #容器名称
        image: nginx
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
  #以上注释中，pod的标签名要一模一样
```
如果出现问题启动不了
就重启kube
在写的时候名称应该全部保持一致，防止出错
```
apiVersion: apps/v1
kind: ReplicaSet #副本类型
metadata:
  name: nginx-rs #副本的名称
  labels:
    app: nginx-rs #副本的标签
spec:
  # 按你的实际情况修改副本数
  replicas: 3 #复本数量
  selector:
    matchLabels:
      app: nginx-rs #pod的标签
  template:
    metadata:
      name: nginx-rs #pod的名称
      labels:
        app: nginx-rs #pod的标签
    spec:
      containers:
      - name: nginx-rs #容器名称
        image: nginx
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
```
特殊现象
- 第一个现象
```
如果先创建一个带有 nginx-pod-lable标签的pod
然后运行会创建3个副本的实例，那么先创建的会保持
```
- 第二个现象
```
如果已经创建了3个标签
然后删除3个pod中一个标签，那么删除的那个会孤立
rs集合还是会保持3个标签
就会出现孤立的空标签pod
```

## ReplicaSet控制器

[https://kubernetes.io/zh/docs/concepts/workloads/controllers/replicaset/](https://kubernetes.io/zh/docs/concepts/workloads/controllers/replicaset/)

ReplicaSet 的目的是维护一组在任何时候都处于运行状态的 Pod 副本的稳定集合。 因此，它通常用来保证给定数量的、完全相同的 Pod 的可用性。

### 1）编写RS控制器资源配置清单

```
apiVersion: apps/v1                      #接口版本号
 kind: ReplicaSet                        #资源类型 ReplicaSet
 metadata:                               #RS的原数据
   name: nginx-rs                        #RS原数据名称
   labels:                               #RS原数据标签
     app: nginx-rs                       #RS具体标签
 spec:                                   #定义pod的实际运行配置
   replicas: 2                           #要运行几个Pod
   selector:                             #选择器
     matchLabels:                        #匹配标签
       app: nginx-rs                    #匹配Pod的标签
   template:                             #创建的Pod的配置模板
     metadata:                           #pod自己的原数据
       labels:                           #pod自己的标签
         app: nginx-rs                  #pod具体标签名
     spec:                               #定义容器运行的配置
       containers:                       #容器参数
       - name: nginx-rs                  #容器名
         image: nginx                    #容器镜像
         imagePullPolicy: IfNotPresent   #镜像拉取策略
         ports:                          #暴露端口
         - name: http                    #端口说明
           containerPort: 80             #容器暴露的端口
```

### 2）应用RS资源配置清单

```
 kubectl create -f nginx-rs.yaml
```

### 3）查看RS资源

```
kubectl get rs 
kubectl get pod -o wide
```

### 4）修改yaml文件应用修改

```
vim nginx-rs.yaml
kubectl apply -f nginx-rs.yaml
```

### 5）动态修改配置 扩容 收缩 升级

```
kubectl edit rs nginx
kubectl scale rs nginx --replicas=5
```

### 6）如何删除rs控制器创建的Pod？

现象：不能直接删除rs创建的pod，因为删除后rs还会在创建

结论：所以正确的操作是要直接删除rs控制器，这样rs控制器会把创建的所有pod一起删除

方法1：直接从配置文件删除

```
kubectl delete -f nginx-rs.yaml
```

方法2：直接使用命令删除

```
kubectl delete rs nginx-rs
```




