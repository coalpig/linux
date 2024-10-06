## 1.PV和PVC介绍

https://kubernetes.io/zh/docs/concepts/storage/persistent-volumes/

PV是对底层网络共享存储的抽象，将存储定义为一种“资源”。PV由管理员创建和配置PVC则是用户对存储资源的一个“申请”。就像Pod消费Node的资源一样，PVC能够“消费”PV资源PVC可以申请特定的存储空间和访问模式

## 2.PV和PVC生命周期

![](attachments/Pasted%20image%2020240910162211.png)


在PV的整个生命周期中，可能会处于4种不同的阶段:

```
Avaliable（可用）：表示可用状态，还未被任何PVC绑定
Bound（绑定）：表示PV已经被PVC绑定
Released（已释放）：PVC被删除，但是资源还未被集群重新声明
Failed（失败）：表示该PV的自动回收失败
```

创建PVC之后，k8s就会去查找满足我们声明要求的PV,比如storageClassName,accessModes以及容量这些是否满足要求，如果满足要求就将PV和PVC绑定在一起。

需要注意的是目前PV和PVC之间是一对一绑定的关系，也就是说一个PV只能被一个PVC绑定。

![](attachments/Pasted%20image%2020240910162227.png)

## 3.PV支持的类型

PV支持的类型主要分为动态和静态两种，这里我们只列举常用的存储类型：

静态PV：

- 宿主机目录：hostPath
- 本地存储设备：LocalPV

动态PV：

- 共享存储：Ceph,GlusterFS,NFS

![](attachments/Pasted%20image%2020240910162318.png)

