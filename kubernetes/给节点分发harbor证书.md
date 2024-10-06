

1）拷贝harbor证书所有node节点都操作

```
scp -r 10.0.0.61:/etc/docker/certs.d/ /etc/docker/
cp /etc/docker/certs.d/abc.com/ca.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust
```

2）node节点重启docker

```
systemctl restart docker.socket
```

3）配置hosts解析（所有Node节点）

```
vim /etc/hosts
10.0.0.61 abc.com
```

4）登录Harbor（只要一台node查看即可）

```
[root@node-01 ~]# docker login abc.com
Username: admin
Password:
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

5）将Docker登录信息（只要一台node查看即可）（PS: 改成你自己的码@cow）

```
[root@node-01 ~]# cat /root/.docker/config.json |base64
ewoJImF1dGhzIjogewoJCSJsdWZmeS5jb20iOiB7CgkJCSJhdXRoIjogIllXUnRhVzQ2U0dGeVltOXlNVEl6TkRVPSIKCQl9Cgl9Cn0=
```

6）创建并secrets资源

注意：secret资源是区分命名空间的

```
cat > harbor-secret.yaml << 'EOF'
apiVersion: v1
kind: Secret
metadata:
  name: harbor-secret
data:
  .dockerconfigjson: ewoJImF1dGhzIjogewoJCSJsdWZmeS5jb20iOiB7CgkJCSJhdXRoIjogIllXUnRhVzQ2U0dGeVltOXlNVEl6TkRVPSIKCQl9Cgl9Cn0=
type: kubernetes.io/dockerconfigjson
EOF
kubectl apply -f harbor-secret.yaml
```

7）编写资源配置清单

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-dp
  labels:
    app: nginx-dp
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-dp
  template:
    metadata:
      name: nginx-dp
      labels:
        app: nginx-dp
    spec:
      imagePullSecrets:
      - name: harbor-secret    
      containers:
      - name: nginx
        image: abc.com/base/nginx
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
```