首先需要部署好svc是实现的负载均衡web

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web1-dp
  labels:
    app: web1-dp
spec:
  replicas: 2 #创建两个pod做负载均衡
  selector:
    matchLabels:
      app: web1-dp
  template:
    metadata:
      name: web1-dp
      labels:
        app: web1-dp
    spec:
      containers:
      - name: web1-dp
        image: nginx
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
        lifecycle:
          postStart:
            exec:
              command: ["/bin/sh", "-c", "echo web1 $(hostname -I) > /usr/share/nginx/html/index.html"]
---
apiVersion: v1
kind: Service
metadata:
  name: web1-svc
spec:
  selector:
    app: web1-dp
  ports:
  - name: http
    protocol: TCP
    port: 80
    targetPort: 80
```

接着创建ingress规则的资源配置清单

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  namespace: default
spec:
  ingressClassName: nginx
  rules:                                   #转发规则
  - host: www.abc1.com
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: web1-svc
            port:
              number: 80                    
  - host: www.abc2.com                    #匹配的域名
    http:                                   #基于http协议解析
      paths:                                #基于路径进行匹配
      - path: /                             #匹配/路径
        pathType: ImplementationSpecific    #路径类型
        backend:                            #匹配后跳转的后端服务
          service:                          #设置后端跳转到Service的配置
            name: web2-svc                  #跳转到名为web2-svc的ClusterIP
            port:                           #跳转到的端口
              number: 80                    #Service端口号
```

pathType路径类型支持的类型：  

```
ImplementationSpecific 系统默认，由IngressClass控制器提供

Exact 精确匹配URL路径，区分大小写

Prefix 匹配URL路径的前缀，区分大小写
```

访问测试  

```
在windows上配置hosts解析：

nginx.k8s.com
```