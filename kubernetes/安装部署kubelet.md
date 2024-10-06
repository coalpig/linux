```
第1章 Node节点部署kubelet服务
-----------------以下操作master-1执行-----------------
1.master-1发送Node节点需要的命令
cd /soft
scp kubernetes/server/bin/kubelet kubernetes/server/bin/kube-proxy node-03:/usr/local/bin/
scp kubernetes/server/bin/kubelet kubernetes/server/bin/kube-proxy node-04:/usr/local/bin/

2.master-1创建kubelet bootstrap.kubeconfig文件
解释:
Kubernetes 中 kubeconfig 文件配置文件用于访问集群信息，在开启了 TLS 的集群中，每次与集群交互时都需要身份认证
生产环境一般使用证书进行认证，其认证所需要的信息会放在 kubeconfig 文件中

创建脚本命令:
mkdir /root/config
cd /root/config
cat > environment.sh <<'EOF'
# 创建 kubelet bootstrapping kubeconfig,这个token需要和/etc/kubernetes/cfg/token.csv一致
BOOTSTRAP_TOKEN=19ea6d37d2ea10d046c6bde743803e28
KUBE_APISERVER="https://10.0.0.10:6443"

# 设置集群参数
kubectl config set-cluster kubernetes \
--certificate-authority=/etc/kubernetes/ssl/ca.pem \
--embed-certs=true \
--server=${KUBE_APISERVER} \
--kubeconfig=bootstrap.kubeconfig

# 设置客户端认证参数
kubectl config set-credentials kubelet-bootstrap \
--token=${BOOTSTRAP_TOKEN} \
--kubeconfig=bootstrap.kubeconfig

# 设置上下文参数
kubectl config set-context default \
--cluster=kubernetes \
--user=kubelet-bootstrap \
--kubeconfig=bootstrap.kubeconfig

# 设置默认上下文
kubectl config use-context default \
--kubeconfig=bootstrap.kubeconfig
EOF

3.执行脚本并检查
[root@master-1 ~/config]# bash environment.sh 
Cluster "kubernetes" set.
User "kubelet-bootstrap" set.
Context "default" created.
Switched to context "default".
[root@master-1 ~/config]# ll
总用量 8
-rw------- 1 root root 2168 3月  23 15:50 bootstrap.kubeconfig
-rw-r--r-- 1 root root  778 3月  23 15:50 environment.sh

4.把生成的bootstrap.kubeconfig发送到node节点
for i in node-03 node-04;do ssh $i mkdir -p /etc/kubernetes/cfg/;done
for i in node-03 node-04;do scp -r /root/config/bootstrap.kubeconfig $i:/etc/kubernetes/cfg/bootstrap.kubeconfig;done

5.将 kubelet-bootstrap 用户绑定到系统集群角色(master-02节点执行)
kubectl create clusterrolebinding kubelet-bootstrap \
  --clusterrole=system:node-bootstrapper \
  --user=kubelet-bootstrap

--------------------------------以下操作node节点执行--------------------------------
6.创建 kubelet 参数配置文件
#node节点都操作
cat > /etc/kubernetes/cfg/kubelet.config << EOF
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
address: $(ifconfig eth0|awk 'NR==2{print $2}')
port: 10250
readOnlyPort: 10255
cgroupDriver: systemd
clusterDNS: ["192.168.100.2"]
clusterDomain: cluster.local.
failSwapOn: false
authentication:
  anonymous:
    enabled: true
EOF

6.创建 kubelet 配置文件
cat >/etc/kubernetes/cfg/kubelet<< EOF
KUBELET_OPTS="--logtostderr=true \
--v=4 \
--hostname-override=$(ifconfig eth0|awk 'NR==2{print $2}') \
--kubeconfig=/etc/kubernetes/cfg/kubelet.kubeconfig \
--bootstrap-kubeconfig=/etc/kubernetes/cfg/bootstrap.kubeconfig \
--config=/etc/kubernetes/cfg/kubelet.config \
--cert-dir=/etc/kubernetes/ssl \
--pod-infra-container-image=rancher/pause:3.6"
EOF

7.创建 kubelet 启动文件
cat >/usr/lib/systemd/system/kubelet.service<<'EOF'
[Unit]
Description=Kubernetes Kubelet
After=docker.service
Requires=docker.service
[Service]
EnvironmentFile=/etc/kubernetes/cfg/kubelet
ExecStart=/usr/local/bin/kubelet $KUBELET_OPTS
Restart=on-failure
KillMode=process
[Install]
WantedBy=multi-user.target
EOF

8.启动kubelet服务
systemctl daemon-reload
systemctl start kubelet.service
systemctl status kubelet.service
systemctl enable kubelet.service

----------------------master-1操作----------------------
9.服务端查看与批准CSR请求
[root@master-1 ~]# kubectl get csr
NAME                                                   AGE   REQUESTOR           CONDITION
node-csr-Kwu6ghXD6M65-tKT_rYT9zo_OJ4aO5D_MleLR5bULmk   52s   kubelet-bootstrap   Pending
node-csr-tuoj7MahNIeD_vX6L49c44LTMAsRQYP0sRWTa38syYY   54s   kubelet-bootstrap   Pending

10.批准请求
kubectl certificate approve node-csr-Kwu6ghXD6M65-tKT_rYT9zo_OJ4aO5D_MleLR5bULmk
kubectl certificate approve node-csr-tuoj7MahNIeD_vX6L49c44LTMAsRQYP0sRWTa38syYY

11.再次查看申请
[root@master1 ~]# kubectl get csr
NAME                                                   AGE    REQUESTOR           CONDITION
node-csr-Kwu6ghXD6M65-tKT_rYT9zo_OJ4aO5D_MleLR5bULmk   9m9s   kubelet-bootstrap   Approved,Issued
node-csr-tuoj7MahNIeD_vX6L49c44LTMAsRQYP0sRWTa38syYY   9m4s   kubelet-bootstrap   Approved,Issued


12.查看node节点
[root@master-1 ~]# kubectl get nodes
NAME            STATUS   ROLES    AGE   VERSION
192.168.91.21   Ready    <none>   16s   v1.15.1
192.168.91.22   Ready    <none>   10s   v1.15.1
```