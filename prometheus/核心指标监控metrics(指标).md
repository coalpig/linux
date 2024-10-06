
https://www.cnblogs.com/zhangmingcheng/p/15770672.html


资源使用情况的监控可以通过 Metrics API的形式获取

- 容器CPU
- 内存使用率

这些度量可以由用户直接访问
- 使用kubectl top
- docker top 等

Metrics-Server是集群核心监控数据的聚合器

通俗地说，它存储了集群中各节点的监控数据

提供了API以供分析和使用

它是Deployment，Service，ClusterRole，ClusterRoleBinding，APIService，RoleBinding等资源对象的综合体

- metric-server提供的是实时的指标（实际是最近一次采集的数据，保存在内存中），并没有数据库来存储
- 这些数据指标并非由metric-server本身采集，而是由每个节点上的cadvisor采集，metric-server只是发请求给cadvisor并将metric格式的数据转换成aggregate api

## metrics-server

从 v1.8 开始，资源使用情况的监控可以通过 Metrics API的形式获取，具体的组件为Metrics Server，用来替换之前的heapster，heapster从1.11开始逐渐被废弃。

Metrics-Server是集群核心监控数据的聚合器，从 Kubernetes1.8 开始，它作为一个 Deployment对象默认部署在由kube-up.sh脚本创建的集群中，如果是其他部署方式需要单独安装，或者咨询对应的云厂商。

## Metrics API

介绍Metrics-Server之前，必须要提一下Metrics API的概念

Metrics API相比于之前的监控采集方式(hepaster)是一种新的思路，官方希望核心指标的监控应该是稳定的，版本可控的，且可以直接被用户访问(例如通过使用 kubectl top 命令)，或由集群中的控制器使用(如HPA)，和其他的Kubernetes APIs一样。

官方废弃heapster项目，就是为了将核心资源监控作为一等公民对待，即像pod、service那样直接通过api-server或者client直接访问，不再是安装一个hepater来汇聚且由heapster单独管理。

假设每个pod和node我们收集10个指标，从k8s的1.6开始，支持5000节点，每个节点30个pod，假设采集粒度为1分钟一次，则：

```
10 x 5000 x 30 / 60 = 25000 平均每分钟2万多个采集指标
```

因为k8s的api-server将所有的数据持久化到了etcd中，显然k8s本身不能处理这种频率的采集，而且这种监控数据变化快且都是临时数据，因此需要有一个组件单独处理他们，k8s版本只存放部分在内存中，于是metric-server的概念诞生了。

其实hepaster已经有暴露了api，但是用户和Kubernetes的其他组件必须通过master proxy的方式才能访问到，且heapster的接口不像api-server一样，有完整的鉴权以及client集成。这个api现在还在alpha阶段（18年8月），希望能到GA阶段。类api-server风格的写法：[generic apiserver](https://github.com/kubernetes/apiserver)

有了Metrics Server组件，也采集到了该有的数据，也暴露了api，但因为api要统一，如何将请求到api-server的`/apis/metrics`请求转发给Metrics Server呢，解决方案就是：[kube-aggregator](https://github.com/kubernetes/kube-aggregator),在k8s的1.7中已经完成，之前Metrics Server一直没有面世，就是耽误在了kube-aggregator这一步。

kube-aggregator（聚合api）主要提供：

- Provide an API for registering API servers.
    
- Summarize discovery information from all the servers.
    
- Proxy client requests to individual servers.
    

详细设计文档：[参考链接](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/aggregated-api-servers.md)

metric api的使用：

- Metrics API 只可以查询当前的度量数据，并不保存历史数据
    
- Metrics API URI 为 /apis/metrics.k8s.io/，在 k8s.io/metrics 维护
    
- 必须部署 metrics-server 才能使用该 API，metrics-server 通过调用 Kubelet Summary API 获取数据
    

如：

```
http://127.0.0.1:8001/apis/metrics.k8s.io/v1beta1/nodes

http://127.0.0.1:8001/apis/metrics.k8s.io/v1beta1/nodes/<node-name>

http://127.0.0.1:8001/apis/metrics.k8s.io/v1beta1/namespace/<namespace-name>/pods/<pod-name>
```

## Metrics-Server

Metrics server定时从Kubelet的Summary API(类似/ap1/v1/nodes/nodename/stats/summary)采集指标信息，这些聚合过的数据将存储在内存中，且以metric-api的形式暴露出去。

Metrics server复用了api-server的库来实现自己的功能，比如鉴权、版本等，为了实现将数据存放在内存中吗，去掉了默认的etcd存储，引入了内存存储（即实现[Storage interface](https://github.com/kubernetes/apiserver/blob/master/pkg/registry/rest/rest.go))。因为存放在内存中，因此监控数据是没有持久化的，可以通过第三方存储来拓展，这个和heapster是一致的。



## k8s自带集群会有coredns

k8s里的coredns自带的metrics接口，所以我们可以先拿来试试手，查看croedns的配置文件可以发现提供prometheus服务采集的端口是9153

```
kubectl -n kube-system get pod -o wide
NAME                                READY   STATUS    RESTARTS   AGE     IP            NODE        
coredns-7f89b7bc75-7zvjg            1/1     Running   4          19d     10.244.0.17   master-01   
coredns-7f89b7bc75-tnkmt            1/1     Running   4          19d     10.244.0.15   master-01  
```

```
vim prom-cm.yml 
```

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: prom
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
      scrape_timeout: 15s
    scrape_configs:
    - job_name: 'prometheus'
      static_configs:
          - targets: ['localhost:9090']
    - job_name: 'coredns'  #在配置文件中添加coredns
      static_configs:
      - targets: ['10.244.0.15:9153','10.244.0.17:9153']
```


```
kubectl apply -f prom-cm.yml 
```

脚本快速查看配置文件并且更新

```
#!/bin/bash

get(){
  kubectl -n prom exec -it $(kubectl -n prom get pod | awk "NR>1"'{print $1}') -- cat /etc/prometheus/prometheus.yml
}

reload(){
  curl -X POST "http://$(kubectl -n prom get svc|awk 'NR>1{print $3}'):9090/-/reload"
}

case $1 in
  g)
    get
    ;;
  r)
    reload
    ;;
  *)
    echo "g|r"
esac
```