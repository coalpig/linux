```
第1章 部署API Server
master-02操作即可,操作完复制给其他节点
master-02操作即可,操作完复制给其他节点
master-02操作即可,操作完复制给其他节点


1.下载k8s二进制包
cd /soft
tar xvf kubernetes-server-linux-amd64.tar.gz
cd kubernetes/server/bin/
cp kube-scheduler kube-apiserver kube-controller-manager kubectl /usr/local/bin/

2.创建证书目录并将证书放到指定位置
mkdir -p /etc/kubernetes/{cfg,ssl}
cp /root/kubernetes/*.pem /etc/kubernetes/ssl/

3.创建TLS Bootstrapping Token
作用:
TLS bootstrapping 功能就是让 kubelet 先使用一个预定的低权限用户连接到 apiserver，
然后向 apiserver 申请证书，kubelet 的证书由 apiserver 动态签署
Token 可以是任意的包涵 128 bit 的字符串，可以使用安全的随机数发生器生成

生成随机数命令：
head -c 16 /dev/urandom | od -An -t x | tr -d ' '

编辑Token文件:
cat > /etc/kubernetes/cfg/token.csv << 'EOF'
19ea6d37d2ea10d046c6bde743803e28,kubelet-bootstrap,10001,"system:kubelet-bootstrap"
EOF

4.创建Apiserver配置文件
###配置文件解释
#--logtostderr 启用日志
#---v 日志等级
#--etcd-servers etcd 集群地址
#--bind-address 监听地址
#--secure-port https 安全端口
#--advertise-address 集群通告地址
#--allow-privileged 启用授权
#--service-cluster-ip-range Service 虚拟 IP 地址段
#--enable-admission-plugins 准入控制模块
#--authorization-mode 认证授权,启用 RBAC 授权
#--enable-bootstrap-token-auth 启用 TLS bootstrap 功能
#--token-auth-file token 文件
#--service-nodeport-range Service Node 类型默认分配端口范围
###

#创建命令
cat >/etc/kubernetes/cfg/kube-apiserver.cfg <<EOF
KUBE_APISERVER_OPTS="--logtostderr=true \
--v=4 \
--insecure-bind-address=0.0.0.0 \
--insecure-port=8080 \
--etcd-servers=https://10.0.0.12:2379,https://10.0.0.13:2379,https://10.0.0.14:2379 \
--bind-address=0.0.0.0 \
--secure-port=6443 \
--advertise-address=0.0.0.0 \
--allow-privileged=true \
--service-cluster-ip-range=192.168.100.0/24 \
--enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota,NodeRestriction \
--authorization-mode=RBAC,Node \
--enable-bootstrap-token-auth \
--token-auth-file=/etc/kubernetes/cfg/token.csv \
--service-node-port-range=30000-50000 \
--tls-cert-file=/etc/kubernetes/ssl/server.pem \
--tls-private-key-file=/etc/kubernetes/ssl/server-key.pem \
--client-ca-file=/etc/kubernetes/ssl/ca.pem \
--service-account-key-file=/etc/kubernetes/ssl/ca-key.pem \
--etcd-cafile=/etc/etcd/ssl/ca.pem \
--etcd-certfile=/etc/etcd/ssl/server.pem \
--etcd-keyfile=/etc/etcd/ssl/server-key.pem"
EOF

5.配置kube-apiserver启动文件
cat >/usr/lib/systemd/system/kube-apiserver.service <<'EOF'
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes
[Service]
EnvironmentFile=/etc/kubernetes/cfg/kube-apiserver.cfg
ExecStart=/usr/local/bin/kube-apiserver $KUBE_APISERVER_OPTS
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

6.将所有配置发送到其他节点
发送命令
for i in master-03 master-04;do scp /usr/local/bin/kube* $i:/usr/local/bin/;done
#发送配置
for i in master-03 master-04;do scp -r /etc/kubernetes/cfg $i:/etc/kubernetescfg;done
#发送启动配置
for i in master-03 master-04;do scp /usr/lib/systemd/system/kube-apiserver.service $i:/usr/lib/systemd/system/kube-apiserver.service;done
#检测文件
for i in master-03 master-04 ;do echo $i "---------->"; ssh $i ls /etc/kubernetes/ssl;done


7.启动kube-apiserver服务
所有master都操作
systemctl daemon-reload
systemctl start kube-apiserver.service
systemctl status kube-apiserver.service
systemctl enable kube-apiserver.service

8.检查token文件是否一致
for i in master-03 master-04;do ssh $i cat /etc/kubernetes/cfg/token.csv;done

9.检查端口
[root@master-02 ~]# netstat -lntup|egrep "8080|6443"
tcp6       0      0 :::8080                 :::*                    LISTEN      8295/kube-apiserver 
tcp6       0      0 :::6443                 :::*                    LISTEN      8295/kube-apiserver 

10.node节点连接测试vip是否好使
]# telnet 10.0.0.10 6443
Trying 10.0.0.10...
Connected to 10.0.0.10.
Escape character is '^]'.
^]
```