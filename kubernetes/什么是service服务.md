Service服务介绍

通过前面的实验我们已经掌握了使用Pod控制器来管理Pod，我们也会发现，Pod的生命周期非常短暂，每次镜像升级都会销毁以及创建，而我们知道每个Pod都拥有自己的IP地址，并且随着Pod删除和创建，这个IP是会变化的。  

当我们的Pod数量非常多的时候前端的入口服务该怎么知道后面都有哪些Pod呢？
  
为了解决这个问题k8s提供了一个对象Service和三种IP，创建的Service资源通过标签可以动态的知道后端的Pod的IP地址，在PodIP之上设计一个固定的IP，也就是ClusterIP，然后使用NodePort来对外暴露端口提供访问。
  
接下来我们先认识一下K8s里的三种IP及其作用。


Service 服务发现

在k8s中，一个service对应的"后端"由Pod的IP和容器端口号组成，即一个完整的"IP:Port"访问地址，这在k8s里叫做Endpoint。通过查看Service的详细信息可以看到后端Endpoint的列表。

```
[root@node1 ~]# kubectl describe svc my-nginx                  
...................
Endpoints:         10.2.1.24:80,10.2.1.26:80,10.2.1.27:80 + 2 more...
```

我们也可以使用DNS域名的形式访问Service，如果在同一个命名空间里甚至可以直接使用service名来访问服务。