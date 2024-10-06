官方项目地址

```
https://github.com/kubernetes/dashboard
```

下载配置文件并应用

```
wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.4/aio/deploy/recommended.yaml
```

应用资源配置

```
kubectl create -f recommended.yaml
```

查看创建的pod

```
[root@node1 k8s]# kubectl -n kubernetes-dashboard get pods
NAME                                         READY   STATUS    RESTARTS   AGE
dashboard-metrics-scraper-7b59f7d4df-62m6s   1/1     Running   0          62s
kubernetes-dashboard-665f4c5ff-4twq7         1/1     Running   0          62s
```
