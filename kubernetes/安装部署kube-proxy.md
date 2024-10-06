```
第1章 部署 kube-proxy 组件
##########master节点操作###############
1.创建 kube-proxy kubeconfig 文件
mkdir /root/config
cd /root/config/
cat >env_proxy.sh<< 'EOF'
BOOTSTRAP_TOKEN=19ea6d37d2ea10d046c6bde743803e28
KUBE_APISERVER="https://10.0.0.10:6443"
kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=kube-proxy.kubeconfig
kubectl config set-credentials kube-proxy \
  --client-certificate=/etc/kubernetes/ssl/kube-proxy.pem \
  --client-key=/etc/kubernetes/ssl/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=kube-proxy.kubeconfig
kubectl config set-context default \
  --cluster=kubernetes \
  --user=kube-proxy \
  --kubeconfig=kube-proxy.kubeconfig
kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
EOF

#复制proxy证书

cp /root/kubernetes/kube-proxy-key.pem /etc/kubernetes/ssl/
cp /root/kubernetes/kube-proxy.pem /etc/kubernetes/ssl/


2.执行创建脚本
[root@master1 ~/config]# bash env_proxy.sh 
Cluster "kubernetes" set.
User "kube-proxy" set.
Context "default" created.
Switched to context "default".
[root@master1 ~/config]# ll
总用量 20
-rw------- 1 root root 2168 3月  23 15:50 bootstrap.kubeconfig
-rw-r--r-- 1 root root  778 3月  23 15:50 environment.sh
-rw-r--r-- 1 root root  691 3月  23 16:43 env_proxy.sh
-rw------- 1 root root 6270 3月  23 16:44 kube-proxy.kubeconfig

3.将生成的kube-proxy.kubeconfig发送给node节点
for i in node-03 node-04;do scp -r /root/config/kube-proxy.kubeconfig $i:/etc/kubernetes/cfg/kube-proxy.kubeconfig;done

##########node节点操作###############
4.创建kube-proxy配置文件
cat >/etc/kubernetes/cfg/kube-proxy << EOF
KUBE_PROXY_OPTS="--logtostderr=true \
--v=4 \
--metrics-bind-address=0.0.0.0 \
--hostname-override=$(ifconfig eth0|awk 'NR==2{print $2}') \
--cluster-cidr=192.168.100.0/24 \
--kubeconfig=/etc/kubernetes/cfg/kube-proxy.kubeconfig"
EOF

5.创建启动文件
cat >/usr/lib/systemd/system/kube-proxy.service<<'EOF'
[Unit]
Description=Kubernetes Proxy
After=network.target

[Service]
EnvironmentFile=/etc/kubernetes/cfg/kube-proxy
ExecStart=/usr/local/bin/kube-proxy $KUBE_PROXY_OPTS
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

6.启动服务
systemctl daemon-reload
systemctl stop kube-proxy.service
systemctl status kube-proxy.service
systemctl dsable kube-proxy.service
```