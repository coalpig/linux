k8s高可用集群是自己搭建的吗？实现原理是什么？


简述Kubernetes常见的部署方式?

```
kubeasz ansible的方式，github的开源项目
二进制部署 生产环境适合
kubeadm部署，使用docker一键部署 简单的学习和实验 
阿里云ack部署
```

你们k8s是什么版本？为什么不升级到最新版？
```
使用的是1.20的版本
```


为什么不升级到最新版？
```
个人角度：业务稳定运行，没有新版本的需求就没有更新，一些第三方工具Kubernetes兼容性问题
还有就是比如dashboard的2.1.0支持兼容k8s1.20
ingress的1.3.1支持兼容k8s的1.2.0
dashboard和ingress都是k8s官方的软件

公司角度：在部署k8s架构的时候就以及确定了版本，一旦动了版本，其他的软件依赖也要重新安装
```


你们使用的是什么容器运行时？docker还是containerd？
我们使用docker容器运行时
实际上，Kubernetes 1.20 宣布弃用docker，并且在2021年下半年发布的1.23版本中，彻底移除 dockershim 代码，意味着届时[kubernetes](https://zhida.zhihu.com/search?q=kubernetes&zhida_source=entity&is_preview=1)支持的容器运行时不再包括docker。
这意味着对于高级容器运行时，我们目前只有containerd 和 [cri-o](https://zhida.zhihu.com/search?q=cri-o&zhida_source=entity&is_preview=1) 两种选择了。


为什么使用containerd？优势是什么？

```
containerd 社区更加活跃，发展势头更好
 从生产环境使用上看，containerd也较cri-o多、
 containerd是行业标准的容器运行时，具备简单性，健壮性和可移植性等特点。
 它可以作为Linux和Windows的守护程序使用
 可以管理其主机系统的完整容器生命周期：镜像传输和存储，容器执行和监控，低级存储和网络附件等。
```

你们k8s是什么方式安装的？

二进制安装的


k8s高可用是如何实现的？



你们k8s集群有多少个节点？服务器配置是什么？



kubeadm与二进制安装有什么区别？
kubeadm一键安装会很方便，但是是跑在docker上

而二进制安装则更加清晰

二进制安装k8s的流程大概说一下，有哪些重要步骤？



如果使用kubeadm部署node节点，但是忘记了join命令怎么办

kubeadm token create --print-join-command

