k8s支持2种查找服务的主要模式：环境变量和DNS，前者开箱即用，而后者则需要CoreDNS组件。

环境变量模式

在一个Pod运行起来的时候，系统会自动为其容器运行环境注入所有集群中有效的Service的信息。

Service的相关信息包括服务IP，服务端口号，相关协议等。

```
[root@node1 ~]# kubectl exec my-nginx-7c4ff94949-6jjq2 -- printenv|grep SERVICE
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
MYSQL_SERVICE_PORT=3306
MYWEB_SERVICE_PORT=8080
MY_NGINX_SERVICE_PORT_HTTP=80
KUBERNETES_SERVICE_HOST=10.1.0.1
MY_NGINX_SERVICE_PORT=80
MY_NGINX_SERVICE_HOST=10.1.182.68
MYSQL_SERVICE_HOST=10.1.81.63
MYWEB_SERVICE_HOST=10.1.149.26
```

这样客户端就可以使用相关的环境变来访问服务了

```
[root@node1 ~]# kubectl exec -it my-nginx-7c4ff94949-6jjq2 -- /bin/bash
root@my-nginx-7c4ff94949-6jjq2:/# curl -I ${MY_NGINX_SERVICE_HOST}
HTTP/1.1 200 OK
```

DNS模式

Kubernetes 提供了一个 DNS 插件 Service，当Service以DNS域名形式进行访问时，需要在k8s集群里存在一个DNS服务来完成域名到CusterIP地址的解析工作。经过多年发展，目前由CoreDNS作为k8s集群的默认DNS服务来提供域名解析服务。

![](attachments/Pasted%20image%2020240903000116.png)

CoreDNS为其他的Pod提供Service解析服务，查看Pod的DNS解析文件可以发现nameserver是一个IP地址，这个IP地址其实是CoreDNS自己的ClusterIP。

```
[root@node1 ~]# kubectl -n kube-system get svc|grep kube-dns
kube-dns                  ClusterIP   10.1.0.10      <none>        53/UDP,53/TCP,9153/TCP
```

安装了CoreDNS的集群，当我们创建Pod后，kubelet会使用配置文件里配置的--cluster-dns=和--cluster-domain参数来传递给容器内部。kubelet配置如下；

```
[root@node1 ~]# cat /var/lib/kubelet/config.yaml
............................
clusterDNS:
- 10.1.0.10
clusterDomain: cluster.local
............................
```

查看容器的/etc/resolv.conf内容可以发现域名的相关配置

```
[root@node1 ~]# kubectl exec -it my-nginx-7c4ff94949-6jjq2 -- cat /etc/resolv.conf
nameserver 10.1.0.10
search default.svc.cluster.local svc.cluster.local cluster.local
options ndots:5
```

那么我们在容器里该怎么去访问Service服务呢？一共有以下几种形式。

```
servicename.default.svc.cluster.local
servicename.namespace
servicename
```

实验一下：

```
[root@node1 ~]# kubectl exec -it my-nginx-7c4ff94949-6jjq2 -- curl -sI my-nginx.default.svc.cluster.local|head -1
HTTP/1.1 200 OK

[root@node1 ~]# kubectl exec -it my-nginx-7c4ff94949-6jjq2 -- curl -sI my-nginx.default|head -1                  
HTTP/1.1 200 OK

[root@node1 ~]# kubectl exec -it my-nginx-7c4ff94949-6jjq2 -- curl -sI my-nginx|head -1        
HTTP/1.1 200 OK

[root@node1 ~]# kubectl run -it --image busybox:1.28.3 test-dns --restart=Never -- nslookup my-nginx
Server:    10.1.0.10
Address 1: 10.1.0.10 kube-dns.kube-system.svc.cluster.local

Name:      my-nginx
Address 1: 10.1.182.68 my-nginx.default.svc.cluster.local
```
