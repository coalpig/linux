k8s 84day
```
1.k8s有哪些组件？作用是什么？
kubelet 控制pod的创建运行和删除,监听api server的信息
kube-proxy 维护节点网络规则
runtime 容器运行时，指定以什么容器运行，如Docker，containerd
kubectl 接收指令或者资源清单,将指令发送给api server
kube-controller 监控node状态、node是否开启、node节点数是否和期望一致
api server 接收所有组件的消息，管理所有组件接口，消息中转站
etcd k8s的数据库，所有组件的数据都存储在etcd
kube-schedule 计算node合理的资源调度

2.k8s创建pod的流程说一下
kubectl 发送创建pod指令给 api server
api server 将创建pod指令存储在etcd 
etcd将指令信息发送给api server，api server将信息发送给能处理的contoller组件
contoller通过计算现有的pod，提交需要更改pod到那个node的机器信息到api server
api server将需要创建的pod通过接口发送给schedule 
schedule计算node节点状态，为node分配合适的pod，将结果发送给api server 
api server 发送给kubelet处理pod的创建

3.什么是pod？pod和容器的区别是什么？
pod是kubernetes的最小单位，pod由根容器和业务容器组成，pod里面可以创建多个容器，ip和文件系统由根容器创建
，提供给业务容器共享，根容器网络模式是container模式

pod里面可以创建多个容器，是包含关系

4.k8s和docker的关系是什么？为什么使用k8s？优势有哪些？
k8s可以使用docker作为容器运行时
k8s对于管理机器非常灵活快速
k8s对比docker的优势可以灵活的管理每一台机器的容器、对于部署和创建更加灵活


5.k8s创建资源的方式有哪些？
命令创建
资源清单创建

6.k8s的安装方式有哪些？有什么区别？
二进制安装 安装复杂，每个组件单独安装，可以学习到各个组件是如何连接的
ansible二进制安装 安装相较于二进制简单，也可以学习到各个组件是如何连接的
kubeadm安装 官方的提供的安装软件，简单快捷

```
以下资源配置清单的含义是什么？查看资源配置方式有哪些?
```
apiVersion: v1      #k8s内部api版本号
kind: Pod           #创建的资源类型
metadata:           #创建的元数据，在etcd里面存储的内容
  name: nginx-pod   #pod的名称，不能重复 
  labels:           #标签分类
    app: nginx-pod  #具体的标签
spec:               #pod中的内容
  containers:       #容器配置
  - name: nginx     #容器名称
    image: nginx    #容器运行的镜像名
```
