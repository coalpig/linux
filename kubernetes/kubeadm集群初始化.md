kubeadm
只在master节点运行

1）集群初始化

```
kubeadm init \
--apiserver-advertise-address=10.0.0.11 \ #本机ip
--image-repository registry.aliyuncs.com/google_containers \ #镜像仓库拉取地址
--kubernetes-version v1.20.15 \ #安装k8s的版本
--service-cidr=10.96.0.0/12 \ #当使用负载均衡的时候，容器的ip
--pod-network-cidr=10.244.0.0/16 \ #pod的ip
--service-dns-domain=cluster.local \ #用来自动发现容器ip的
--ignore-preflight-errors=Swap \ #忽略swap分区的错误
--ignore-preflight-errors=NumCPU #忽略2核cpu数的错误，正常要求2核
```

参数解释：

```
--apiserver-advertise-address=10.0.0.11  	#API Server的地址
--image-repository registry.aliyuncs.com/google_containers  	#镜像仓库地址，这里使用的是阿里云
--kubernetes-version v1.20.15				    	#安装的k8s版本
--service-cidr=10.96.0.0/12  							#Cluster IP
--pod-network-cidr=10.244.0.0/16 					#Pod IP
--service-dns-domain=cluster.local 				#全域名的后缀，默认是cluster.local
--ignore-preflight-errors=Swap     				#忽略SWAP检查不通过的警告
--ignore-preflight-errors=NumCPU   				#忽略CPU检查不通过的警告
```
安装后的信息
为了node节点安装

```
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube #创建隐藏目录.kube
  cp -i /etc/kubernetes/admin.conf $HOME/.kube/config 复制配置的权限
  chown $(id -u):$(id -g) $HOME/.kube/config 更改这个文件属主为当前登录用户

#复制配置里面有apiserver地址 server: https://10.0.0.11:6443是为了，和apiserve通信#
#ls /etc/kubernetes/pki/ 里面有很多证书，配置证书为了和apiserver安装通信
Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:
#以下是为了node节点加入master，配置了相关证书
kubeadm join 10.0.0.11:6443 --token 5o4ppz.1nc00crblixo80wt \
    --discovery-token-ca-cert-hash sha256:7de89716f538b97e4c64895f465e33b4c5d31d58b95cb21fc7aa3abd0a08833d 
```


2）准备配置文件

```
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
```

3）获取Node节点信息

```
kubectl get nodes
```

4）设置kube-proxy使用ipvs模式

执行编辑命令，然后将mode: ""修改为mode: "ipvs"然后保存退出，这里涉及到configmap资源类型，后面详细讲解。

```
kubectl edit cm kube-proxy -n kube-system
#找到44行 mode "ipvs"
#需要修改mode为ipvs模式
kubectl -n kube-system get pod|grep kube-proxy|awk '{print "kubectl -n kube-system delete pod "$1}'|bash
ipvsadm -Ln
```

5）部署Flannel网络插件-只在master节点上安装部署
这个插件是为了把所有容器的网络打通
可以直接穿到master-01
![](attachments/03kube-flannel-v1.4.0.yml)
也可以克隆代码

```
[root@master-01 ~/k8s]# git clone --depth 1 https://github.com/coreos/flannel.git
[root@master-01 ~/k8s]# cd flannel/Documentation/
[root@master-01 ~/k8s/flannel/Documentation]#
```

下载下来后还需要修改资源配置清单

```
[root@master-01 ~/k8s/flannel/Documentation]# vim 03kube-flannel-v1.4.0.yml
 ...      
 165       containers:
 166       - name: kube-flannel
 167         image: docker.io/flannel/flannel:v0.24.2
 168         command:
 169         - /opt/bin/flanneld
 170         args:
 171         - --ip-masq
 172         - --kube-subnet-mgr
 173         - --iface=eth0  #如果是多网卡，需要指定网卡名称
```

应用资源配置清单

```
kubectl apply -f 文件名
kubectl create -f 03kube-flannel-v1.4.0.yml #创建资源清单
kubectl apply -f 03kube-flannel-v1.4.0.yml #第二种方法
```

检查pod运行状态等一会应该是running

```
[root@master-01 ~]# kubectl -n kube-flannel get pod
NAME                    READY   STATUS    RESTARTS   AGE
kube-flannel-ds-fv2tr   1/1     Running   0          8m38s
```
