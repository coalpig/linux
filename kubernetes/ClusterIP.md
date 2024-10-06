mysql-dp

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-dp
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

```

mysql-svc
mysql为了安全只能内网访问所以使用ClusterIP
```
apiVersion: v1
kind: Service
metadata:
  name: mysql-svc
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

