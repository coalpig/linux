
[Docker安装](../Docker/Docker安装.md)

```
第1章 Node节点安装配置Docker
以下操作都在node节点
以下操作都在node节点
以下操作都在node节点
以下操作都在node节点
以下操作都在node节点
以下操作都在node节点
以下操作都在node节点
以下操作都在node节点
以下操作都在node节点
以下操作都在node节点
以下操作都在node节点
以下操作都在node节点
以下操作都在node节点
以下操作都在node节点
以下操作都在node节点
以下操作都在node节点
以下操作都在node节点
以下操作都在node节点
以下操作都在node节点


1.安装docker-ce

yum -y install docker-ce-19.03.15 docker-ce-cli-19.03.15

2.创建镜像加速配置
mkdir /etc/docker -p
cat > /etc/docker/daemon.json <<EOF
    {
        "exec-opts": ["native.cgroupdriver=systemd"]
    }
EOF

3.修改启动文件
cat >/usr/lib/systemd/system/docker.service << 'EOF'
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target
[Service]
Type=notify
EnvironmentFile=/run/flannel/subnet.env
ExecStart=/usr/bin/dockerd $DOCKER_NETWORK_OPTIONS
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TimeoutStartSec=0
Delegate=yes
KillMode=process
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s
[Install]
WantedBy=multi-user.target
EOF

4.启动docker
systemctl daemon-reload
systemctl start docker.service 
systemctl status docker.service 
systemctl enable docker.service 

5.检查docker0和flannel.1设备网段是否一致
ip a
```