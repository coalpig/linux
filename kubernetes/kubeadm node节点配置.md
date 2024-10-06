只在Node节点执行

1）node节点加入集群

刚才在master集群初始化的时候会生成一串命令，这个命令就是给node节点加入集群的指令。

```
kubeadm join 10.0.0.11:6443 --token 5o4ppz.1nc00crblixo80wt \
    --discovery-token-ca-cert-hash sha256:7de89716f538b97e4c64895f465e33b4c5d31d58b95cb21fc7aa3abd0a08833d 

```

如果当时没有保存，可以执行以下命令重新查看:

```
kubeadm token create --print-join-command
```

2）master节点查看节点信息

```
kubectl get nodes
```

3）master节点执行打标签命令

```
kubectl label nodes node-01 node-role.kubernetes.io/node=
kubectl label nodes node-02 node-role.kubernetes.io/node=
```

4）检查状态

```
[root@master-01 /mnt]# kubectl get nodes
NAME        STATUS   ROLES                  AGE    VERSION
master-01   Ready    control-plane,master   162m   v1.20.15
node-01     Ready    node                   148m   v1.20.15
node-02     Ready    node                   147m   v1.20.15
```

