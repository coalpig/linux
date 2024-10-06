## k8s存储介绍

容器内部的的存储在生命周期是短暂的，会随着容器环境的销毁而销毁，具有不稳定性。在k8s里将对容器应用所需的存储资源抽象为存储卷(Volume)概念来解决这些问题。

k8s目前支持的Volume类型包括k8s的内部资源对象类型，开源共享存储类型和公有云存储等。分类如下：

k8s特定的资源对象：

```
ConfigMap   应用配置
Secret      加密数据
ServiceAccountToken  token数据
```

k8s本地存储类型:

```
EmptDir: 临时存储
HostPath: 宿主机目录
```

持久化存储(PV)和网络共享存储：

```
CephFS: 开源共享存储系统
GlusterFS: 开源共享存储系统
NFS:    开源共享存储
PersistentVolumeClaim: 简称PVC，持久化存储的申请空间
```