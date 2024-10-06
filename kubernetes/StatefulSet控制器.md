[https://kubernetes.io/zh-cn/docs/concepts/workloads/controllers/statefulset/](https://kubernetes.io/zh-cn/docs/concepts/workloads/controllers/statefulset/)

[https://kubernetes.io/zh-cn/docs/concepts/services-networking/service/#headless-services](https://kubernetes.io/zh-cn/docs/concepts/services-networking/service/#headless-services)

[https://kubernetes.io/zh-cn/docs/tutorials/stateful-application/basic-stateful-set/](https://kubernetes.io/zh-cn/docs/tutorials/stateful-application/basic-stateful-set/)

[https://blog.nashtechglobal.com/how-to-set-up-a-2-node-elasticsearch-cluster-on-kubernetes-minikube/](https://blog.nashtechglobal.com/how-to-set-up-a-2-node-elasticsearch-cluster-on-kubernetes-minikube/)

[https://www.processon.com/view/link/66e155c15b0abf01932963a4?cid=66e0f355df5e372d74ea06b9](https://www.processon.com/view/link/66e155c15b0abf01932963a4?cid=66e0f355df5e372d74ea06b9)

### 1）有状态和无状态服务介绍

```
有状态服务：

无状态服务：
```

### 2）StatefulSet介绍

StatefulSet类似于前面我们学的Replica

### 3）Headless Service

```
正常流程：
域名 --> ClsterIP --> Pod

Headless Service:
域名 --> Pod
```

### 4）定义Headless Service

```
cat > nginx-svc.yaml << 'EOF'
 apiVersion: v1
 kind: Service
 metadata:
   name: nginx
   namespace: default
   labels:
     app: nginx
 spec:
   selector:
     app: nginx
   ports:
   - name: http
     port: 80
   clusterIP: None    
 EOF
```

唯一的区别就是 clusterIP: None

### 5）StatefulSet

创建pv:

```
cat > nginx-pv.yaml << 'EOF'
 apiVersion: v1
 kind: PersistentVolume
 metadata:
   name: pv01
 spec:
   capacity:
     storage: 1Gi
   accessModes:
   - ReadWriteOnce
   hostPath:
     path: /tmp/pv01
 ---
 apiVersion: v1
 kind: PersistentVolume
 metadata:
   name: pv02
 spec:
   capacity:
     storage: 1Gi
   accessModes:
   - ReadWriteOnce
   hostPath:
     path: /tmp/pv02
 EOF
```

创建资源配置清单：

```
cat > nginx-sf.yaml << 'EOF'
 apiVersion: apps/v1
 kind: StatefulSet
 metadata:
   name: web
   namespace: default
 spec:
   serviceName: "nginx"
   replicas: 2
   selector:
     matchLabels:
       app: nginx
   template:
     metadata:
       labels:
         app: nginx
     spec:
       containers:
       - name: nginx
         image: nginx:1.7.9
         ports:
         - name: web
           containerPort: 80
         volumeMounts:
         - name: www
           mountPath: /usr/share/nginx/html
   volumeClaimTemplates:
   - metadata:
       name: www
     spec:
       accessModes: [ "ReadWriteOnce" ]
       resources:
         requests:
           storage: 1Gi
 EOF
```

部署mongo

```
# storageclass-fast.yaml
 ---
 apiVersion: storage.k8s.io/v1
 kind: StorageClass
 metadata:
   name: fast
 provisioner: kubernetes.io/glusterfs
 parameters:
   resturl: "http://<heketi-rest-url>"
 
 # mongo-headless-service.yaml
 ---
 apiVersion: v1
 kind: Service
 metadata:
   name: mongo
   labels:
     name: mongo
 spec:
   ports:
   - port: 27017
     targetPort: 27017
   clusterIP: None
   selector:
     role: mongo
 
 # statefulset-mongo.yaml
 ---
 apiVersion: apps/v1
 kind: StatefulSet
 metadata:
   name: mongo
 spec:
   serviceName: "mongo"
   replicas: 3
   template:
     metadata:
       labels:
         role: mongo
         environment: test
     spec:
       terminationGracePeriodSeconds: 10
       containers:
       - name: mongo
         image: mongo
         command:
         - mongod
         - "--replSet"
         - rs0
         - "--smallfiles"
         - "--noprealloc"
         ports:
         - containerPort: 27017
         volumeMounts:
         - name: mongo-persistent-storage
           mountPath: /data/db
       - name: mongo-sidecar
         image: cvallance/mongo-k8s-sidecar
         env:
         - name: MONGO_SIDECAR_POD_LABELS
           value: "role=mongo,environment=test"
         - name: KUBERNETES_MONGO_SERVICE_NAME
           value: "mongo"
   volumeClaimTemplates:
   - metadata:
       name: mongo-persistent-storage
       annotations:
         volume.beta.kubernetes.io/storage-class: "fast"
     spec:
       accessModes: [ "ReadWriteOnce" ]
       resources:
         requests:
           storage: 1Gi
```
