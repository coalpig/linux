首先要先创建命名空间
再创建configmap

```
apiVersion: v1
kind: Namespace
metadata:
  name: nginx
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-cm
  namespace: nginx
  labels:
    app: nginx-cm
data:
  sjm.conf: |
    server {
        listen  80;
        server_name  k8s.sjm.local;
    location / {
      root /code/sjm;
      index index.html;
    }
    }
  2048.conf: |
    server {
        listen  80;
        server_name  k8s.2048.local;
    location / {
      root /code/2048;
      index index.html;
    }
    }
  xiao.conf: |
    server {
        listen  80;
        server_name  k8s.xiao.local;
    location / {
      root /code/xiao;
      index index.html;
    }
    }
```

接下来创建dp

```
apiVersion: apps/v1
kind: Deployment #副本类型
metadata:
  name: nginx-dp #副本的名称
  labels:
    app: nginx-dp #副本的标签
  namespace: nginx
spec:
  # 按你的实际情况修改副本数
  replicas: 1 #复本数量
  selector:
    matchLabels:
      app: nginx-dp #pod的标签
  template:
    metadata:
      name: nginx-dp #pod的名称
      labels:
        app: nginx-dp #pod的标签
    spec:
      containers:
      - name: nginx-dp #容器名称
        image: nginx
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
        volumeMounts:
        - name: nginx-cm
          mountPath: /etc/nginx/conf.d/
        - name: nginx-code
          mountPath: /code/
      volumes:
      - name: nginx-cm
        configMap:
          name: nginx-cm
      - name: nginx-code
        hostPath:
          path: /code/nginx/
          type: Directory
```

创建svc

```
apiVersion: v1
kind: Service
metadata:
  name: web-svc
  namespace: nginx
spec:
  selector:
    app: nginx-dp
  ports:
  - name: http
    protocol: TCP
    port: 80
    targetPort: 80
```

创建ingress

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  namespace: nginx
spec:
  ingressClassName: nginx
  rules:
  - host: k8s.sjm.local
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: web-svc
            port:
              number: 80
  - host: k8s.2048.local
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: web-svc
            port:
              number: 80
  - host: k8s.xiao.local
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: web-svc
            port:
              number: 80
```