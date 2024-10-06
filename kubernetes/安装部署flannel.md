```
第1章 安装配置Flannel
master1安装配置好然后复制给其他节点
1.下载Flannel命令
cd /soft
#wget https://github.com/coreos/flannel/releases/download/v0.11.0/flannel-v0.11.0-linux-amd64.tar.gz
tar xvf flannel-v0.10.0-linux-amd64.tar.gz
mv flanneld mk-docker-opts.sh /usr/local/bin/
for i in master-03 master-04 node-03 node-04;do scp /usr/local/bin/flanneld $i:/usr/local/bin/;done
for i in master-03 master-04 node-03 node-04;do scp /usr/local/bin/mk-docker-opts.sh $i:/usr/local/bin/;done

2.创建Flannel配置文件
mkdir -p /etc/flannel
cat > /etc/flannel/flannel.cfg <<'EOF'
FLANNEL_OPTIONS="-etcd-endpoints=https://10.0.0.14:2379,https://10.0.0.12:2379,https://10.0.0.13:2379 \
-etcd-cafile=/etc/etcd/ssl/ca.pem \
-etcd-certfile=/etc/etcd/ssl/server.pem \
-etcd-keyfile=/etc/etcd/ssl/server-key.pem"
EOF
for i in master-03 master-04 node-03 node-04;do ssh $i mkdir -p /etc/flannel;done
for i in master-03 master-04 node-03 node-04;do scp /etc/flannel/flannel.cfg $i:/etc/flannel/flannel.cfg;done
 
3.创建Flannel启动文件
cat > /usr/lib/systemd/system/flanneld.service << 'EOF'
[Unit]
Description=Flanneld overlay address etcd agent
After=network-online.target network.target
Before=docker.service
[Service]
Type=notify
EnvironmentFile=/etc/flannel/flannel.cfg
ExecStart=/usr/local/bin/flanneld --ip-masq $FLANNEL_OPTIONS
ExecStartPost=/usr/local/bin/mk-docker-opts.sh -k DOCKER_NETWORK_OPTIONS -d /run/flannel/subnet.env
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
for i in master-03 master-04 node-03 node-04;do scp  /usr/lib/systemd/system/flanneld.service $i:/usr/lib/systemd/system/flanneld.service;done
 
4.ETCD写入POD网段信息
解释:
172.17.0.0/16 为 Kubernetes Pod 的 IP 地址段.
网段必须与 kube-controller-manager 的 --cluster-cidr 参数值一致

写入命令:
etcdctl \
--ca-file=/etc/etcd/ssl/ca.pem \
--cert-file=/etc/etcd/ssl/server.pem \
--key-file=/etc/etcd/ssl/server-key.pem \
--endpoints="https://10.0.0.11:2379,https://10.0.0.12:2379,https://10.0.0.13:2379" \
set /coreos.com/network/config \
'{ "Network": "172.17.0.0/16", "Backend": {"Type": "vxlan"}}'

查看命令:
etcdctl \
--ca-file=/etc/etcd/ssl/ca.pem \
--cert-file=/etc/etcd/ssl/server.pem \
--key-file=/etc/etcd/ssl/server-key.pem \
--endpoints="https://10.0.0.11:2379,https://10.0.0.12:2379,https://10.0.0.13:2379" \
get /coreos.com/network/config 

 
5.启动Flannel
所有节点都操作
systemctl daemon-reload
systemctl start flanneld.service 
systemctl status flanneld.service 
systemctl enable flanneld.service 

6.检查
#查看设备每个节点获取的网段不一样 
ip a | grep flannel   

#查看env文件是否生成并和flannel保持一致
cat /run/flannel/subnet.env
```