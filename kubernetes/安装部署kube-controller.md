```
第1章 部署kube-controller-manager
部署顺序:
etcd --> api server --> xxxx
etcd --> flannel --> docker --> xxxx
master1操作完成然后发送给其他master

网络规划:
POD IP:			172.17.0.0
Cluster IP: 	192.168.100.0
Node Port:      10.0.0.0 30000-50000

1.创建kube-controller-manager配置文件
#参数解释:
--master=127.0.0.1:8080 #指定 Master 地址
--leader-elect #竞争选举机制产生一个 leader 节点，其它节点为阻塞状态。
--service-cluster-ip-range #kubernetes service 指定的 IP 地址范围。

#创建命令:
cat >/etc/kubernetes/cfg/kube-controller-manager.cfg<<'EOF'
KUBE_CONTROLLER_MANAGER_OPTS="--logtostderr=true \
--v=4 \
--master=127.0.0.1:8080 \
--leader-elect=true \
--address=0.0.0.0 \
--service-cluster-ip-range=192.168.100.0/24 \
--cluster-name=kubernetes \
--cluster-signing-cert-file=/etc/kubernetes/ssl/ca.pem \
--cluster-signing-key-file=/etc/kubernetes/ssl/ca-key.pem \
--root-ca-file=/etc/kubernetes/ssl/ca.pem \
--service-account-private-key-file=/etc/kubernetes/ssl/ca-key.pem"
EOF

2.创建kube-controller-manager启动文件
cat >/usr/lib/systemd/system/kube-controller-manager.service<<'EOF'
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/kubernetes/kubernetes
[Service]
EnvironmentFile=/etc/kubernetes/cfg/kube-controller-manager.cfg
ExecStart=/usr/local/bin/kube-controller-manager $KUBE_CONTROLLER_MANAGER_OPTS
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

3.发送给其他节点
for i in master-03 master-04;do scp /etc/kubernetes/cfg/kube-controller-manager.cfg $i:/etc/kubernetes/cfg/kube-controller-manager.cfg;done
for i in master-03 master-04;do scp /usr/lib/systemd/system/kube-controller-manager.service $i:/usr/lib/systemd/system/kube-controller-manager.service;done

4.启动controller-manager
systemctl daemon-reload
systemctl start kube-controller-manager.service
systemctl status kube-controller-manager.service
systemctl enable kube-controller-manager.service

5.检查组件状态
[root@master1 ~]# kubectl get cs
NAME                 STATUS    MESSAGE             ERROR
controller-manager   Healthy   ok                  
scheduler            Healthy   ok                  
etcd-0               Healthy   {"health":"true"}   
etcd-1               Healthy   {"health":"true"}   
etcd-2               Healthy   {"health":"true"}   
```