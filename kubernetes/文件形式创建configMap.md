
### 3.1 创建配置文件：

```
cat >www.conf <<EOF
server {
        listen       80;
        server_name  www.cookzy.com;
        location / {
            root   /usr/share/nginx/html/www;
            index  index.html index.htm;
        }
    }
EOF
```

创建configMap资源：

```
kubectl create configmap nginx-www --from-file=www.conf=./www.conf 
```

查看cm资源

```
kubectl get cm
kubectl describe cm nginx-www
```

### 3.2 编写pod并以存储卷挂载模式引用configMap的配置

![](https://cdn.nlark.com/yuque/0/2024/png/830385/1725446821908-4cca6246-6c08-4716-b15c-fdafb1a017f2.png?x-oss-process=image%2Fwatermark%2Ctype_d3F5LW1pY3JvaGVp%2Csize_39%2Ctext_6Lev6aOe5a2m5Z-O%2Ccolor_FFFFFF%2Cshadow_50%2Ct_80%2Cg_se%2Cx_10%2Cy_10)

```
cat >nginx-cm-volume.yaml <<EOF
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
    - name: nginx-www
      mountPath: /etc/nginx/conf.d/
  volumes:
  - name: nginx-www
    configMap:
     name: nginx-www
     items: 
     - key: www.conf
       path: www.conf
EOF
```

关键参数：

```
volumes:                             #定义存储卷
   - name: nginx-www             		 #名称
     configMap:                      #引用configMap资源
      name: nginx-www            		 #引用名为nginx-www的configMap资源
      items:                         #引用configMap里的具体的内容
      - key: www.conf            		 #引用名为nginx-www的configMap里的key为www.conf的值
        path: www.conf           		 #使用key名称作为挂载文件名
```

### 3.3 测试效果

1.进到容器内查看文件

```
kubectl exec -it nginx-cm /bin/bash
cat /etc/nginx/conf.d/www.conf
```

2.动态修改

```
configMap
kubectl edit cm nginx-www
```

3.再次进入容器内观察配置会不会自动更新

```
cat /etc/nginx/conf.d/www.conf 
nginx -T
```
