```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-dp
  namespace: default
spec:
  selector:
    matchLabels:
      app: mysql 
  replicas: 1
  template: 
    metadata:
      name: mysql-pod
      namespace: default
      labels:
        app: mysql
    spec:
      volumes:
      - name: mysql-volume
        hostPath:
          path: /data/mysql
          type: DirectoryOrCreate 
      nodeSelector:
        disktype: SSD    
      containers:
      - name: mysql-pod
        image: mysql:5.7 
        ports:
        - name: mysql-port
          containerPort: 3306
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "123456" 
        volumeMounts:
        - mountPath: /var/lib/mysql
          name: mysql-volume
```