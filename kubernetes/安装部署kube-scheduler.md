```
第1章 安装部署kube-scheduler
master-1操作完成然后发送给其他master
1.创建kube-scheduler配置文件
#配置解释
--bind-address=0.0.0.0 启动绑定地址
--master 连接本地 apiserver(非加密端口)
--leader-elect=true：集群运行模式，启用选举功能；被选为 leader 的节点负责处理工作，其它节点为阻塞状态

#创建命令
cat >/etc/kubernetes/cfg/kube-scheduler.cfg<<'EOF'
KUBE_SCHEDULER_OPTS="--logtostderr=true \
--v=4 \
--bind-address=0.0.0.0 \
--master=127.0.0.1:8080 \
--leader-elect"
EOF

2.创建kube-scheduler启动文件
cat >/usr/lib/systemd/system/kube-scheduler.service<<'EOF'
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/kubernetes/kubernetes

[Service]
EnvironmentFile=/etc/kubernetes/cfg/kube-scheduler.cfg
ExecStart=/usr/local/bin/kube-scheduler $KUBE_SCHEDULER_OPTS
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

3.发送给其他master节点
for i in master-03 master-04;do scp /etc/kubernetes/cfg/kube-scheduler.cfg $i:/etc/kubernetes/cfg/kube-scheduler.cfg;done
for i in master-03 master-04;do scp /usr/lib/systemd/system/kube-scheduler.service $i:/usr/lib/systemd/system/kube-scheduler.service;done

4.启动kube-scheduler
systemctl daemon-reload
systemctl start kube-scheduler.service
systemctl status kube-scheduler.service
systemctl enable kube-scheduler.service

5.查看组件信息
[root@master-1 ~]# kubectl get cs
NAME                 STATUS      MESSAGE                                                                                     ERROR
controller-manager   Unhealthy   Get http://127.0.0.1:10252/healthz: dial tcp 127.0.0.1:10252: connect: connection refused   
scheduler            Healthy     ok                                                                                          
etcd-2               Healthy     {"health":"true"}                                                                           
etcd-1               Healthy     {"health":"true"}                                                                           
etcd-0               Healthy     {"health":"true"}

```