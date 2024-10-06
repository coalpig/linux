```
第1章 部署ETCD
1.下载安装文件
master-02操作即可,安装好后发送给其他节点
cd /soft
#wget https://github.com/etcd-io/etcd/releases/download/v3.3.10/etcd-v3.3.10-linux-amd64.tar.gz
tar -xvf etcd-v3.3.10-linux-amd64.tar.gz
cd etcd-v3.3.10-linux-amd64/
cp etcd etcdctl /usr/local/bin/
etcdctl -v
scp /usr/local/bin/etcd* master-04:/usr/local/bin/
scp /usr/local/bin/etcd* master-03:/usr/local/bin/
ssh master-04 etcdctl -v
ssh master-03 etcdctl -v

2.编辑etcd配置文件
#配置文件解释
ETCD_NAME 节点名称, 如果有多个节点, 那么每个节点要修改为本节点的名称。
ETCD_DATA_DIR 数据目录
ETCD_LISTEN_PEER_URLS 集群通信监听地址
ETCD_LISTEN_CLIENT_URLS 客户端访问监听地址
ETCD_INITIAL_ADVERTISE_PEER_URLS 集群通告地址
ETCD_ADVERTISE_CLIENT_URLS 客户端通告地址
ETCD_INITIAL_CLUSTER 集群节点地址,如果多个节点那么逗号分隔
ETCD_INITIAL_CLUSTER_TOKEN 集群 Token
ETCD_INITIAL_CLUSTER_STATE 加入集群的当前状态，new 是新集群，existing 表示加入已有集群

=====master-02操作=====
mkdir -p /etc/etcd/{cfg,ssl}
cat >/etc/etcd/cfg/etcd.conf<<'EOF'
#[Member]
ETCD_NAME="master-02"
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="https://10.0.0.12:2380"
ETCD_LISTEN_CLIENT_URLS="https://10.0.0.12:2379,http://10.0.0.12:2390"
#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://10.0.0.12:2380"
ETCD_ADVERTISE_CLIENT_URLS="https://10.0.0.12:2379"
ETCD_INITIAL_CLUSTER="master-02=https://10.0.0.12:2380,master-03=https://10.0.0.13:2380,master-04=https://10.0.0.14:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"
EOF

########master-03操作
mkdir -p /etc/etcd/{cfg,ssl}
cat >/etc/etcd/cfg/etcd.conf<<'EOF'
#[Member]
ETCD_NAME="master-03"
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="https://10.0.0.13:2380"
ETCD_LISTEN_CLIENT_URLS="https://10.0.0.13:2379,http://10.0.0.13:2390"
#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://10.0.0.13:2380"
ETCD_ADVERTISE_CLIENT_URLS="https://10.0.0.13:2379"
ETCD_INITIAL_CLUSTER="master-02=https://10.0.0.12:2380,master-03=https://10.0.0.13:2380,master-04=https://10.0.0.14:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"
EOF

#master-04操作
mkdir -p /etc/etcd/{cfg,ssl}
cat >/etc/etcd/cfg/etcd.conf<<'EOF'
#[Member]
ETCD_NAME="master-04"
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="https://10.0.0.14:2380"
ETCD_LISTEN_CLIENT_URLS="https://10.0.0.14:2379,http://10.0.0.14:2390"
#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://10.0.0.14:2380"
ETCD_ADVERTISE_CLIENT_URLS="https://10.0.0.14:2379"
ETCD_INITIAL_CLUSTER="master-02=https://10.0.0.12:2380,master-03=https://10.0.0.13:2380,master-04=https://10.0.0.14:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"
EOF

3.复制证书到指定目录
#master-02操作
mkdir -p /etc/etcd/ssl/
\cp /root/etcd/*pem /etc/etcd/ssl/ -rf
ll /etc/etcd/ssl/
#复制 etcd 证书到每个节点
for i in master-03 master-04 node-03 node-04;do ssh $i mkdir -p /etc/etcd/{cfg,ssl};done
for i in master-03 master-04 node-03 node-04;do scp /etc/etcd/ssl/* $i:/etc/etcd/ssl/;done
for i in master-03 master-04 node-03 node-04;do ssh $i ls /etc/etcd/ssl;done

4.启动文件-三台master都操作
#三台master都操作
cat > /usr/lib/systemd/system/etcd.service << 'EOF'
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target
[Service]
Type=notify
EnvironmentFile=/etc/etcd/cfg/etcd.conf
ExecStart=/usr/local/bin/etcd \
--name=${ETCD_NAME} \
--data-dir=${ETCD_DATA_DIR} \
--listen-peer-urls=${ETCD_LISTEN_PEER_URLS} \
--listen-client-urls=${ETCD_LISTEN_CLIENT_URLS},http://127.0.0.1:2379 \
--advertise-client-urls=${ETCD_ADVERTISE_CLIENT_URLS} \
--initial-advertise-peer-urls=${ETCD_INITIAL_ADVERTISE_PEER_URLS} \
--initial-cluster=${ETCD_INITIAL_CLUSTER} \
--initial-cluster-token=${ETCD_INITIAL_CLUSTER_TOKEN} \
--initial-cluster-state=${ETCD_INITIAL_CLUSTER_STATE} \
--cert-file=/etc/etcd/ssl/server.pem \
--key-file=/etc/etcd/ssl/server-key.pem \
--peer-cert-file=/etc/etcd/ssl/server.pem \
--peer-key-file=/etc/etcd/ssl/server-key.pem \
--trusted-ca-file=/etc/etcd/ssl/ca.pem \
--peer-trusted-ca-file=/etc/etcd/ssl/ca.pem
Restart=on-failure
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

5.启动etcd-三台master都操作
systemctl daemon-reload
systemctl start etcd
systemctl status etcd
systemctl enable etcd

6.检查etcd集群健康状态
etcdctl \
--ca-file=/etc/etcd/ssl/ca.pem \
--cert-file=/etc/etcd/ssl/server.pem \
--key-file=/etc/etcd/ssl/server-key.pem \
--endpoints="https://10.0.0.12:2379" \
cluster-health
```