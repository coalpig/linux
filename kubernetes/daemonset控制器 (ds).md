
一个nod保持只运行一个容器
- 运用在日志
- 运用在监控
```
apiVersion: apps/v1
kind: DaemonSet #副本类型
metadata:
  name: nginx-ds #副本的名称
  labels:
    app: nginx-ds #副本的标签
spec:
  # 按你的实际情况修改副本数
  # 删除复本数量
  selector:
    matchLabels:
      app: nginx-ds #pod的标签
  template:
    metadata:
      name: nginx-ds #pod的名称
      labels:
        app: nginx-ds #pod的标签
    spec:
      containers:
      - name: nginx-ds #容器名称
        image: nginx
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
```

## DaemonSet控制器

### 1） DaemonSet类型介绍

![](https://cdn.nlark.com/yuque/0/2024/png/830385/1724978350993-677e4f08-002c-48f3-84f6-f372a0a94e60.png?x-oss-process=image%2Fwatermark%2Ctype_d3F5LW1pY3JvaGVp%2Csize_56%2Ctext_6Lev6aOe5a2m5Z-O%2Ccolor_FFFFFF%2Cshadow_50%2Ct_80%2Cg_se%2Cx_10%2Cy_10)

DaemonSet 确保全部（或者某些）节点上运行一个 Pod 的副本。 当有节点加入集群时， 也会为他们新增一个 Pod 。 当有节点从集群移除时，这些 Pod 也会被回收。删除 DaemonSet 将会删除它创建的所有 Pod。

简单来说就是每个节点只部署一个POD。  
常见的应用场景：  
监控容器  
日志收集容器

### 2） DaemonSet举例

```
apiVersion: apps/v1
 kind: DaemonSet
 metadata:
   name: nginx-ds
   labels:
     app: nginx-ds
 spec:
   selector:
     matchLabels:
       app: nginx-ds
   template:
     metadata:
       labels:
         app: nginx-ds
     spec:
       containers:
       - name: nginx-ds
         image: nginx:1.16
         ports:
         - containerPort: 80
```
