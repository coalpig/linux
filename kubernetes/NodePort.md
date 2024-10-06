xzs-dp

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: xzs-dp
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
        image: xzs:3.9.0
        imagePullPolicy: IfNotPresent
        env:
        - name: WORDPRESS_DB_HOST
          value: "xzs-svc"
        - name: WORDPRESS_DB_USER
          value: "xzs"
        - name: WORDPRESS_DB_PASSWORD
          value: "xzs"
        - name: WORDPRESS_DB_NAME
          value: "xzs"
        ports:
        - containerPort: 8000

```

xzs-svc
前后端一体
xzs外网访问所以需要NodePort

```
apiVersion: v1
kind: Service
metadata:
  name: xzs-svc
spec:
  type: NodePort
  selector:
    app: xzs-dp
  ports:
  - name: xzs-svc
    protocol: TCP
    port: 8000
    targetPort: 8000
    nodePort: 30002
```
