
### 4.1 创建config配置清单：

```
cat >nginx-configMap.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
  namespace: default
data:
  www.conf: |
    server {
            listen       80;
            server_name  www.cookzy.com;
            location / {
                root   /usr/share/nginx/html/www;
                index  index.html index.htm;
            }
        }
  blog.conf: |
    server {
            listen       80;
            server_name  blog.cookzy.com;
            location / {
                root   /usr/share/nginx/html/blog;
                index  index.html index.htm;
            }
        }
EOF
```

### 4.2 应用并查看清单:

```
kubectl create -f nginx-configMap.yaml
kubectl get cm
kubectl describe cm nginx-config
```

### 4.3 创建POD资源清单并引用configMap

```
cat >nginx-cm-volume-all.yaml <<EOF
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
    volumeMounts:
    - name: nginx-config
      mountPath: /etc/nginx/conf.d/

  volumes:
  - name: nginx-config
    configMap:
     name: nginx-config
     items: 
     - key: www.conf
       path: www.conf
     - key: blog.conf
       path: blog.conf
EOF
```

### 4.4 应用并查看:

```
kubectl create -f nginx-cm-volume-all.yaml
kubectl get pod
kubectl describe pod nginx-cm
```

进入容器内并查看：

```
kubectl exec -it nginx-cm /bin/bash
ls /etc/nginx/conf.d/
cat /etc/nginx/conf.d/www.conf
```

### 4.5 测试动态修改configMap会不会生效

```
kubectl edit cm nginx-config 
kubectl exec -it nginx-cm /bin/bash
ls /etc/nginx/conf.d/
cat /etc/nginx/conf.d/www.conf
```