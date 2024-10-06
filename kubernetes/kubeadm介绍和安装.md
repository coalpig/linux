kubeadm介绍

```
kubeadm是google推出的一种部署k8s集群的套件，他将k8s的组件打包封装成了容器，然后通过kubeadm进行集群的初始化。  
kubeadm的好处是安装部署方便，缺点是不容易看到每个组件的配置，出了问题不好排查。但是我们现在的重点是学习k8s的使用，所以这些优先选择简单的安装方式，最后会介绍二进制安装部署。
```

kubeadm部署前规划

节点规划

```
master  master节点  API Server,controlle,scheduler,kube-proxy,kubelet,etcd  
node1   node节点    Dokcer kubelet kube-proxy   
node2   node节点    Dokcer kubelet kube-proxy
```

IP规划

```
POD IP      10.2.0.0  
Cluster IP  10.1.0.0  
Node IP     10.0.0.0

```
注意！！！以下步骤如果没有特别指出在某个节点运行则默认在所有节点都执行。

# kubeadm环境准备

注意!以下操作所有主机都执行

1）所有主机都执行k8s禁止使用swap
为什么禁止使用swap
```
在使用 kubeadm 安装 Kubernetes (k8s) 时，需要设置禁止使用 swap 分区，主要是因为 Kubernetes 的 kubelet 默认行为是在节点上检测到交换内存时无法启动。这是因为 swap 分区的使用会在磁盘上增加系统的可用内存量，但同时会在磁盘虚拟页面和内存页面交换过程中带来额外的磁盘 I/O 负载。由于容器运行环境自身对磁盘的吞吐量有很高的需求，swap 分区的使用在高负载情况下可能导致 K8s 系统的整体性能下降，并有可能导致应用程序的崩溃。

此外，Kubernetes 云原生的实现目的是将运行实例紧密包装到尽可能接近 100%，所有的部署、运行环境应该与 CPU 以及内存限定在一个可控的空间内。如果使用 swap，则其实 node 的 pod 使用内存总和可能超过了 node 的内存，这样其实就达不到资源的严格限制和管理的目的。

因此，为了确保 Kubernetes 集群的性能和稳定性，推荐在安装 kubeadm 之前禁用 swap 分区。可以通过执行 `swapoff -a` 命令临时关闭 swap，并修改 `/etc/fstab` 文件来永久禁用 swap 分区，以确保重启后 swap 分区不会重新启用
```

```
cat > /etc/sysconfig/kubelet<<EOF
KUBELET_CGROUP_ARGS="--cgroup-driver=systemd"
KUBELET_EXTRA_ARGS="--fail-swap-on=false"
EOF
```

2）所有主机都执行，设置内核参数
为了网络转发
与防火墙iptables相关
```
cat >  /etc/sysctl.d/k8s.conf <<EOF #写入配置
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system #生效配置
```

3）所有主机都执行，加载IPVS模块
使用老版本内核的设置会出现以下错误
改用新内核版本就可以了
![](attachments/Pasted%20image%2020240830173546.png)
```
#老版本内核
cat >/etc/sysconfig/modules/ipvs.modules<<EOF
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4
EOF
chmod +x /etc/sysconfig/modules/ipvs.modules
source /etc/sysconfig/modules/ipvs.modules
lsmod | grep -e ip_vs -e nf_conntrack_ipv


#新版本内核
cat >/etc/sysconfig/modules/ipvs.modules<<EOF
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack
modprobe br_netfilter
EOF
chmod +x /etc/sysconfig/modules/ipvs.modules
source /etc/sysconfig/modules/ipvs.modules
lsmod | grep -e ip_vs -e nf_conntrack_ipv
```

# kubeadm安装部署

注意!以下操作所有主机都执行

1）设置kubeadm国内仓库

```
cat > /etc/yum.repos.d/kubernetes.repo << 'EOF'
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
```

2）安装指定版本kubeadm

```
#ipvsadm 防火墙规则
#--nogpgcheck 不启动证书校验
yum install -y kubelet-1.20.15 kubeadm-1.20.15 kubectl-1.20.15 ipvsadm --nogpgcheck
```

3）设置kubelet开机启动

```
systemctl enable kubelet
```

4）设置kubectl支持命令补全

```
#可以帮助命令补全,k8s命令很多
yum install bash-completion -y
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
kubectl completion bash > /etc/bash_completion.d/kubectl
```
