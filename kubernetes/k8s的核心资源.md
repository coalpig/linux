
1.POD

POD是k8s的最小单位  
POD的IP地址是随机的，删除POD会改变IP  
POD都有一个根容器  
一个POD内可以由一个或多个容器组成  
一个POD内的容器共享根容器的网络命名空间和文件系统卷  
一个POD的内的网络地址由根容器提供

![](attachments/Pasted%20image%2020240830192933.png)

创建Pod流程图:
![](attachments/Pasted%20image%2020240830192844.png)

时间图：
![](attachments/Pasted%20image%2020240830192913.png)

文字说明：

创建Pod的清单 --> API Server   
API Server --> etcd  
etcd --> API Server  
kube-scheduler --> API Server --> etcd  
etcd --> API server --> kubelet --> Docker  
kubelet --> API Server --> etcd  
​  
管理员清单提交给了 APIServer  
API Server 接收到请求后把资源清单信息存入到 etcd 数据库中  
etcd 存好后更新状态给 API Server  
API Server通过相应的接口更新事件  
kube-scheduler 组件发现这个时候有一个 Pod 还没有绑定到节点上，就会对这个 Pod 进行一系列的调度，把它调度到一个最合适的节点上  
然后把这个节点和 Pod 绑定到一起的信息告诉 API Server  
API Server将调度消息更新到etcd里，etcd更新好后返回状态给API Server  
节点上的 kubelet 组件这个时候 watch 到有一个 Pod 被分配过来了，就去把这个 Pod 的信息拉取下来，然后根据描述通过容器运行时把容器创建出来，最后当然同样把 Pod 状态汇报给API Server 再写回到 etcd 中去，这样就完成了一整个的创建流程。

容器运行状态：

Waiting（等待）   
如果容器并不处在Running或Terminated状态之一，它就处在Waiting状态。 处于Waiting状态的容器仍在运行它完成启动所需要的操作：例如，从某个容器镜像 仓库拉取容器镜像，或者向容器应用数据等等。 当你使用 kubectl 来查询包含 Waiting状态的容器的 Pod 时，你也会看到一个 Reason 字段，其中给出了容器处于等待状态的原因。  
​  
Running（运行中）   
Running状态表明容器正在执行状态并且没有问题发生。  
如果你使用 kubectl 来查询包含 Running 状态的容器的 Pod 时，你也会看到 关于容器进入Running状态的信息。  
​  
Terminated（已终止）   
处于Terminated状态的容器已经开始执行并且或者正常结束或者因为某些原因失败。 如果你使用kubectl来查询包含Terminated状态的容器的 Pod 时，你会看到 容器进入此状态的原因、退出代码以及容器执行期间的起止时间。

2.Label

label标签是kubernetes中非常重要的一个属性，label标签就像身份证一样，可以用来识别k8s的对象。  
我们在传统架构里不同组件之间查找都是通过IP地址，但是在k8s里，很多的匹配关系都是通过标签来查找的。

3.Namespace

Namespace(命令空间)是k8s里另一个非常重要的概念，Namespace通过将集群内部的资源对象划分为不同的。Namespace里，形成逻辑上的不同项目组或用户组。  
常见的pod,service,Deployment等资源如果没有指定命令空间，则默认创建在名为default的默认命名空间。

4.Controller

用来管理POD,控制器的种类有很多  
  - RC Replication Controller  控制POD有多个副本  
  - RS ReplicaSet              RC控制的升级版  
  - Deployment                 推荐使用，功能更强大，包含了RS控制器  
  - DaemonSet                  保证所有的Node上有且只有一个Pod在运行  
  - StatefulSet              有状态的应用，为Pod提供唯一的标识，它可以保证部署和scale的顺序

5.Service

Service服务也是k8s的核心资源之一，Service定义了服务的入口地址，用来将后端的Pod服务暴露给外部用户访问。  
我们知道Pod会随时被销毁和创建，而新创的Pod的IP地址并不是固定的，那么Service资源是如何找到后面不确定IP的Pod呢？  
​  
为了解决这个问题，k8s在PodIP之上又设计了一层IP，名为ClusterIP,这个ClusterIP在创建后就不会再变化，除非被删除重新创建。  
通过这样的设计，我们只需要创建Cluster类型的Service资源，再通过标签和后端的Pod绑定在一起，这样只要访问ClusterIP就可以将请求转发到了后端的Pod，而且如果后端有多个Pod，ClusterIP还会将流量自动负载均衡到后面的Pod  
​  
通过ClusterIP我们可以访问对应的Pod，但是这个ClusterIP是一个虚拟IP，只能在k8s集群内部使用。外部用户是访问不到的，那么我们如何让外面的用户也可以访问到我们的服务呢？  
我们的k8s运行在物理服务器上，那么必然会有物理网卡和真实的IP地址，也就是说所有k8s集群之外的节点想访问k8s集群内的某个节点，都必须通过物理网卡和IP。  
所以我们可以通过将物理网卡的IP地址的端口和Cluster做端口映射来实现外部流量对内部Pod的访问。  
这种IP在k8s里称为NodeIP，暴露的端口称为NodePort。  
​  
​  
总结一下：  
NodeIP      对外提供用户访问  
CluterIP    集群内部IP，可以动态感知后面的POD IP  
POD IP      POD的IP

Service三种网络图：

![](attachments/Pasted%20image%2020240830192652.png)


Service和Pod和RS的关系：
![](attachments/Pasted%20image%2020240830192639.png)
