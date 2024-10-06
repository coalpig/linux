>Master节点组件

先参考一张图
![](attachments/Pasted%20image%2020240830191701.png)


kube-API Server：提供k8s API接口  
主要处理Rest操作以及更新Etcd中的对象  
是所有资源增删改查的唯一入口。

Scheduler：资源调度器  
根据etcd里的节点资源状态决定将Pod绑定到哪个Node上


Controller Manager  
负责保障pod的健康存在  
资源对象的自动化控制中心，Kubernetes集群有很多控制器。

Etcd
这个是Kubernetes集群的数据库  
所有持久化的状态信息存储在Etcd中

kubectl是管理k8s集群的客户端工具，管理员通过kubectl命令对API Server进行操作  
API Server 响应并返回对应的命令结果，从而达到对 Kubernetes 集群的管理

>Node节点的组成

参考一张图

![](attachments/Pasted%20image%2020240830191748.png)

容器运行时（Container Runtime)

```
容器运行时是负责容器运行的软件。  
默认情况下，Kubernetes 使用 容器运行时接口（Container Runtime Interface，CRI） 来与你所选择的容器运行时交互。  
​  
如果同时检测到 Docker 和 containerd，则优先选择 Docker。 这是必然的，因为 Docker 18.09 附带了 containerd 并且两者都是可以检测到的， 即使你仅安装了 Docker。 如果检测到其他两个或多个运行时，kubeadm 输出错误信息并退出。  
​  
kubelet 通过内置的 dockershim CRI 实现与 Docker 集成。
```

Docker Engine

负责节点容器的管理工作，最终创建出来的是一个Docker容器。

kubelet

安装在Node上的代理服务，用来管理Pods以及容器/镜像/Volume等，实现对集群对节点的管理。

kube-proxy

安装在Node上的网络代理服务，提供网络代理以及负载均衡，实现与Service通讯。




