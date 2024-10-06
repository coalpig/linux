pv

```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: jenkins-pv-volume
  labels:
    type: local
spec:
  storageClassName: local-storage
  claimRef:
    name: jenkins-pv-claim
    namespace: devops
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  local:
    path: /data/jenkins
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
  name: jenkins-pv-claim
  namespace: devops
spec:
  storageClassName: local-storage
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
```

cluster-role

sa

cluster-role-bind

```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: jenkins-admin
rules:
  - apiGroups: [""]
    resources: ["*"]
    verbs: ["*"]
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jenkins-admin
  namespace: devops
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: jenkins-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: jenkins-admin
subjects:
- kind: ServiceAccount
  name: jenkins-admin
  namespace: devops
```

svc

```
apiVersion: v1
kind: Service
metadata:
  name: jenkins-svc
  namespace: devops
  labels:
    app: jenkins-svc
spec:
  selector:
    app: jenkins-server
  ports:
    - name: web
      port: 8080
      targetPort: httpport
    - name: agent
      port: 50000
      targetPort: jnlpport
```

dp

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins-server
  namespace: devops
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins-server
  template:
    metadata:
      labels:
        app: jenkins-server
    spec:
      nodeName: node-01
      imagePullSecrets:
      - name: harbor-secret
      securityContext:
            fsGroup: 1000
            runAsUser: 1000
      serviceAccountName: jenkins-admin
      initContainers:
      - name: fix-permissions
        image: abc.com/base/busybox
        imagePullPolicy: IfNotPresent
        command: ["sh", "-c", "chown -R 1000:1000 /var/jenkins_home"]
        securityContext:
          privileged: true
        volumeMounts:
        - name: jenkins-data
          mountPath: /var/jenkins_home
      containers:
      - name: jenkins-server
        # image: jenkins/jenkins:lts-jdk17
        image: abc.com/devops/jenkins:lts-jdk17
        imagePullPolicy: IfNotPresent
        resources:
          limits:
            memory: "500Mi"
            cpu: "500m"
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
      #volumes:
      #  - name: jenkins-data
      #    persistentVolumeClaim:
      #        claimName: jenkins-pv-claim
      volumes:
        - name: jenkins-data
          hostPath:
            path: /data/jenkins/
            type: DirectoryOrCreate
```

ingress

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: jenkins-ingress
  namespace: devops
spec:
  ingressClassName: nginx
  rules:
  - host: jenkins.local
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