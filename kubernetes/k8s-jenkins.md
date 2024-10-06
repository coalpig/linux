首先创建pv-pvc
如果不创建pv-pvc可以直接创建volume 的hostpath


```
apiVersion: v1
kind: Namespace  #创建命名空间
metadata:
  name: jenkins
---
apiVersion: storage.k8s.io/v1   
kind: StorageClass                 #定义storage
metadata:
  name: jenkins-storage            #定义storage的名称
  namespace: jenkins
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
---
apiVersion: v1
kind: PersistentVolume  
metadata:
  name: jenkins-pv
  namespace: jenkins
  labels:
    type: local
spec:
  storageClassName: jenkins-storage
#  claimRef:
#    name: jenkins-pv-claim
#    namespace: devops-tools
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  local:
    path: /data/jenkins_home
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - node-01
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: jenkins-pvc
  namespace: jenkins
spec:
  storageClassName: jenkins-storage
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
```

接下来创建dp资源

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins-dp
  namespace: jenkins
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins-pod-label
  template:
    metadata:
      labels:
        app: jenkins-pod-label
    spec:
      securityContext:
            fsGroup: 1000
            runAsUser: 1000
      containers:
        - name: jenkins
          image: jenkins/jenkins:lts
          resources:
            limits:
              memory: "2Gi"
              cpu: "1000m"
            requests:
              memory: "500Mi"
              cpu: "500m"
          ports:
            - name: httpport
              containerPort: 8080
            - name: jnlpport
              containerPort: 50000
          livenessProbe:
            httpGet:
              path: "/login"
              port: 8080
            initialDelaySeconds: 90
            periodSeconds: 10
            timeoutSeconds: 5
            failureThreshold: 5
          readinessProbe:
            httpGet:
              path: "/login"
              port: 8080
            initialDelaySeconds: 60
            periodSeconds: 10
            timeoutSeconds: 5
            failureThreshold: 3
          volumeMounts:
            - name: jenkins-data
              mountPath: /var/jenkins_home
      volumes:
        - name: jenkins-data
          persistentVolumeClaim:
              claimName: jenkins-pvc
```

创建svc

```
apiVersion: v1
kind: Service
metadata:
  name: jenkins-svc
  namespace: jenkins
  annotations:
      prometheus.io/scrape: 'true'
      prometheus.io/path:   /
      prometheus.io/port:   '8080'
spec:
  selector:
    app: jenkins-pod-label
  type: NodePort
  ports:
    - port: 8080
      targetPort: 8080
      nodePort: 32000
```

创建ingress

```
apiVersion: v1
kind: Service
metadata:
  name: jenkins-svc
  namespace: jenkins
spec:
  selector:
    app: jenkins-pod-label
  ports:
  - name: http
    protocol: TCP
    port: 8080
    targetPort: 8080
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: jenkins-ingress
  namespace: jenkins
spec:
  ingressClassName: nginx
  rules:
  - host: www.jenkins.com
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: jenkins-svc
            port:
              number: 8080
```