
### 2.1 创建命令

```
kubectl create configmap --help
kubectl create configmap nginx-config --from-literal=nginx_port=80 --from-literal=server_name=nginx.cookzhang.com
kubectl get cm
kubectl describe cm nginx-config
```

关键参数：

```
kubectl create configmap nginx-config \                     #创建名为nginx-config的configmap资源类型
 --from-literal=nginx_port=80 \                             #创建变量，key为nginx_port，value值为80
 --from-literal=server_name=nginx.cookzhang.com    					#创建变量，key为server_name，value值为nginx.cookzhang.com
```

### 2.2 POD环境变量形式引用configMap

```
kubectl explain pod.spec.containers.env.valueFrom.configMapKeyRef

cat >nginx-cm.yaml <<EOF
apiVersion: v1
kind: Pod
metadata: 
  name: nginx-cm
spec:
  containers:

  - name: nginx-pod
    image: nginx:1.14.0
    ports:
    - name: http 
      containerPort: 80
      env:
      - name: NGINX_PORT
        valueFrom:
          configMapKeyRef:
            name: nginx-config
            key: nginx_port
      - name: SERVER_NAME
        valueFrom:
          configMapKeyRef:
            name: nginx-config
            key: server_name 
EOF

kubectl create -f nginx-cm.yaml
```

关键参数：

```
valueFrom:									引用变量
  configMapKeyRef:					引用congfigmap
    name: nginx-config			引用的congfigmap名称
    key: nginx_port					应用congfigmap里的具体的key
```

### 2.3 查看pod是否引入了变量

```
[root@node1 ~/confimap]# kubectl exec -it nginx-cm /bin/bash
root@nginx-cm:~# echo ${NGINX_PORT}
80
root@nginx-cm:~# echo ${SERVER_NAME}
nginx.cookzhang.com
root@nginx-cm:~# printenv |egrep "NGINX_PORT|SERVER_NAME"
NGINX_PORT=80
SERVER_NAME=nginx.cookzhang.com
```

注意：

变量传递的形式，修改confMap的配置，POD内并不会生效  
因为变量只有在创建POD的时候才会引用生效，POD一旦创建好，环境变量就不变了
