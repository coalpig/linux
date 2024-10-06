首先创建命名空间

```
apiVersion: v1
kind: Namespace
metadata:
  name: xzs
```

使用命令方式创建configmap

application.yml

application-dev.yml
再这两个文件的目录下执行
这是为了创建一个configmap

```
kubectl -n xzs create configmap xzs-cm  --from-file=application=./application.yml --from-file=application-dev=./application-dev.yml
```


创建xzs-dp和xzs-svc
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: xzs-dp
  namespace: xzs
  labels:
    app: xzs-dp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: xzs-dp
  template:
    metadata:
      name: xzs-dp
      labels:
        app: xzs-dp
    spec:
      containers:
      - name: xzs-dp
        image: xzs:v1
        command:
        imagePullPolicy: IfNotPresent
        env:
        - name: WORDPRESS_DB_HOST
          value: "mysql-svc.xzs"
        - name: WORDPRESS_DB_USER
          value: "xzs"
        - name: WORDPRESS_DB_PASSWORD
          value: "xzs"
        - name: WORDPRESS_DB_NAME
          value: "xzs"
        ports:
        - containerPort: 8000

        command: ["java" ]
        args :
        - "-Duser.timezone=Asia/Shanghai"
        - "-Dspring.config.location=/config/"
        - "-Dspring.config.name=application"
        - "-Dspring.profiles.active=dev"
        - "-jar"
        - "/opt/xzs-3.9.0.jar"

        volumeMounts:
        - name: xzs-cm
          mountPath: /config
      volumes:
      - name: xzs-cm
        configMap:
         name: xzs-cm
         items:
         - key: application
           path: application.yml
         - key: application-dev
           path: application-dev.yml
---
apiVersion: v1
kind: Service
metadata:
  name: xzs-svc
  namespace: xzs
spec:
  type: ClusterIP
  selector:
    app: xzs-dp
  ports:
  - name: http
    protocol: TCP
    port: 8000
    targetPort: 8000
```

创建xzs-ingress

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: xzs-ingress
  namespace: xzs
spec:
  ingressClassName: nginx
  rules:
  - host: www.xzs.com
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: xzs-svc
            port:
              number: 8000
```

链接数据库

创建mysql-dp
mysql-svc

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-dp
  namespace: xzs
  labels:
    app: mysql-dp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql-dp
  template:
    metadata:
      name: mysql-dp
      labels:
        app: mysql-dp
    spec:
      nodeName: node-01
      volumes:
      - name: mysql-data
        hostPath:
          path: /data/xzs
          type: Directory
      containers:
      - name: mysql-dp
        image: mysql:8.0
        imagePullPolicy: IfNotPresent
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "root"
        - name: MYSQL_DATABASE
          value: "xzs"
        - name: MYSQL_USER
          value: "xzs"
        - name: MYSQL_PASSWORD
          value: "xzs"
        volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
        ports:
        - containerPort: 3306
---
apiVersion: v1
kind: Service
metadata:
  name: mysql-svc
  namespace: xzs
spec:
  type: ClusterIP
  selector:
    app: mysql-dp
  ports:
  - name: http
    protocol: TCP
    port: 3306
    targetPort: 3306
```



