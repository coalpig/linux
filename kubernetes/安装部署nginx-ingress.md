官方的Nginx-ingress对k8s是有版本要求的，注意选择适合你的版本：
ingress官方--> https://github.com/kubernetes/ingress-nginx

| Supported | Ingress-NGINX version | k8s supported version        | Alpine Version | Nginx Version | Helm Chart Version |
| :-------: | --------------------- | ---------------------------- | -------------- | ------------- | ------------------ |
|    🔄     | **v1.11.2**           | 1.30, 1.29, 1.28, 1.27, 1.26 | 3.20.0         | 1.25.5        | 4.11.2             |
|    🔄     | **v1.11.1**           | 1.30, 1.29, 1.28, 1.27, 1.26 | 3.20.0         | 1.25.5        | 4.11.1             |
|    🔄     | **v1.11.0**           | 1.30, 1.29, 1.28, 1.27, 1.26 | 3.20.0         | 1.25.5        | 4.11.0             |
|    🔄     | **v1.10.4**           | 1.30, 1.29, 1.28, 1.27, 1.26 | 3.20.0         | 1.25.5        | 4.10.4             |
|    🔄     | **v1.10.3**           | 1.30, 1.29, 1.28, 1.27, 1.26 | 3.20.0         | 1.25.5        | 4.10.3             |
|    🔄     | **v1.10.2**           | 1.30, 1.29, 1.28, 1.27, 1.26 | 3.20.0         | 1.25.5        | 4.10.2             |
|    🔄     | **v1.10.1**           | 1.30, 1.29, 1.28, 1.27, 1.26 | 3.19.1         | 1.25.3        | 4.10.1             |
|    🔄     | **v1.10.0**           | 1.29, 1.28, 1.27, 1.26       | 3.19.1         | 1.25.3        | 4.10.0             |
|           | v1.9.6                | 1.29, 1.28, 1.27, 1.26, 1.25 | 3.19.0         | 1.21.6        | 4.9.1              |
|           | v1.9.5                | 1.28, 1.27, 1.26, 1.25       | 3.18.4         | 1.21.6        | 4.9.0              |
|           | v1.9.4                | 1.28, 1.27, 1.26, 1.25       | 3.18.4         | 1.21.6        | 4.8.3              |
|           | v1.9.3                | 1.28, 1.27, 1.26, 1.25       | 3.18.4         | 1.21.6        | 4.8.*              |
|           | v1.9.1                | 1.28, 1.27, 1.26, 1.25       | 3.18.4         | 1.21.6        | 4.8.*              |
|           | v1.9.0                | 1.28, 1.27, 1.26, 1.25       | 3.18.2         | 1.21.6        | 4.8.*              |
|           | v1.8.4                | 1.27, 1.26, 1.25, 1.24       | 3.18.2         | 1.21.6        | 4.7.*              |
|           | v1.7.1                | 1.27, 1.26, 1.25, 1.24       | 3.17.2         | 1.21.6        | 4.6.*              |
|           | v1.6.4                | 1.26, 1.25, 1.24, 1.23       | 3.17.0         | 1.21.6        | 4.5.*              |
|           | v1.5.1                | 1.25, 1.24, 1.23             | 3.16.2         | 1.21.6        | 4.4.*              |
|           | v1.4.0                | 1.25, 1.24, 1.23, 1.22       | 3.16.2         | 1.19.10†      | 4.3.0              |
|           | v1.3.1                | 1.24, 1.23, 1.22, 1.21, 1.20 | 3.16.2         | 1.19.10†      | 4.2.5              |
|           |                       |                              |                |               |                    |
|           |                       |                              |                |               |                    |
kubernetes使用的是1.20对应版本1.3.1

我们可以直接使用kubernetes官方自带的nginx-ingress控制清单来部署

```
wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.1/deploy/static/provider/kind/deploy.yaml -O nginx-ingress-v1.3.1.yaml
 
访问不了的话:
wget https://github.com/kubernetes/ingress-nginx/archive/refs/tags/controller-v1.3.1.tar.gz
```


 将nginx-ingress-v1.3.1.yaml下载下来后得到资源配置清单
     
> [!info]
> nginx-ingress-v1.3.1.yaml
> 
> ```
> apiVersion: v1
> kind: Namespace
> metadata:
>   labels:
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>   name: ingress-nginx
> ---
> apiVersion: v1
> automountServiceAccountToken: true
> kind: ServiceAccount
> metadata:
>   labels:
>     app.kubernetes.io/component: controller
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>     app.kubernetes.io/part-of: ingress-nginx
>     app.kubernetes.io/version: 1.3.1
>   name: ingress-nginx
>   namespace: ingress-nginx
> ---
> apiVersion: v1
> kind: ServiceAccount
> metadata:
>   labels:
>     app.kubernetes.io/component: admission-webhook
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>     app.kubernetes.io/part-of: ingress-nginx
>     app.kubernetes.io/version: 1.3.1
>   name: ingress-nginx-admission
>   namespace: ingress-nginx
> ---
> apiVersion: rbac.authorization.k8s.io/v1
> kind: Role
> metadata:
>   labels:
>     app.kubernetes.io/component: controller
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>     app.kubernetes.io/part-of: ingress-nginx
>     app.kubernetes.io/version: 1.3.1
>   name: ingress-nginx
>   namespace: ingress-nginx
> rules:
> - apiGroups:
>   - ""
>   resources:
>   - namespaces
>   verbs:
>   - get
> - apiGroups:
>   - ""
>   resources:
>   - configmaps
>   - pods
>   - secrets
>   - endpoints
>   verbs:
>   - get
>   - list
>   - watch
> - apiGroups:
>   - ""
>   resources:
>   - services
>   verbs:
>   - get
>   - list
>   - watch
> - apiGroups:
>   - networking.k8s.io
>   resources:
>   - ingresses
>   verbs:
>   - get
>   - list
>   - watch
> - apiGroups:
>   - networking.k8s.io
>   resources:
>   - ingresses/status
>   verbs:
>   - update
> - apiGroups:
>   - networking.k8s.io
>   resources:
>   - ingressclasses
>   verbs:
>   - get
>   - list
>   - watch
> - apiGroups:
>   - ""
>   resourceNames:
>   - ingress-controller-leader
>   resources:
>   - configmaps
>   verbs:
>   - get
>   - update
> - apiGroups:
>   - ""
>   resources:
>   - configmaps
>   verbs:
>   - create
> - apiGroups:
>   - coordination.k8s.io
>   resourceNames:
>   - ingress-controller-leader
>   resources:
>   - leases
>   verbs:
>   - get
>   - update
> - apiGroups:
>   - coordination.k8s.io
>   resources:
>   - leases
>   verbs:
>   - create
> - apiGroups:
>   - ""
>   resources:
>   - events
>   verbs:
>   - create
>   - patch
> ---
> apiVersion: rbac.authorization.k8s.io/v1
> kind: Role
> metadata:
>   labels:
>     app.kubernetes.io/component: admission-webhook
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>     app.kubernetes.io/part-of: ingress-nginx
>     app.kubernetes.io/version: 1.3.1
>   name: ingress-nginx-admission
>   namespace: ingress-nginx
> rules:
> - apiGroups:
>   - ""
>   resources:
>   - secrets
>   verbs:
>   - get
>   - create
> ---
> apiVersion: rbac.authorization.k8s.io/v1
> kind: ClusterRole
> metadata:
>   labels:
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>     app.kubernetes.io/part-of: ingress-nginx
>     app.kubernetes.io/version: 1.3.1
>   name: ingress-nginx
> rules:
> - apiGroups:
>   - ""
>   resources:
>   - configmaps
>   - endpoints
>   - nodes
>   - pods
>   - secrets
>   - namespaces
>   verbs:
>   - list
>   - watch
> - apiGroups:
>   - coordination.k8s.io
>   resources:
>   - leases
>   verbs:
>   - list
>   - watch
> - apiGroups:
>   - ""
>   resources:
>   - nodes
>   verbs:
>   - get
> - apiGroups:
>   - ""
>   resources:
>   - services
>   verbs:
>   - get
>   - list
>   - watch
> - apiGroups:
>   - networking.k8s.io
>   resources:
>   - ingresses
>   verbs:
>   - get
>   - list
>   - watch
> - apiGroups:
>   - ""
>   resources:
>   - events
>   verbs:
>   - create
>   - patch
> - apiGroups:
>   - networking.k8s.io
>   resources:
>   - ingresses/status
>   verbs:
>   - update
> - apiGroups:
>   - networking.k8s.io
>   resources:
>   - ingressclasses
>   verbs:
>   - get
>   - list
>   - watch
> ---
> apiVersion: rbac.authorization.k8s.io/v1
> kind: ClusterRole
> metadata:
>   labels:
>     app.kubernetes.io/component: admission-webhook
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>     app.kubernetes.io/part-of: ingress-nginx
>     app.kubernetes.io/version: 1.3.1
>   name: ingress-nginx-admission
> rules:
> - apiGroups:
>   - admissionregistration.k8s.io
>   resources:
>   - validatingwebhookconfigurations
>   verbs:
>   - get
>   - update
> ---
> apiVersion: rbac.authorization.k8s.io/v1
> kind: RoleBinding
> metadata:
>   labels:
>     app.kubernetes.io/component: controller
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>     app.kubernetes.io/part-of: ingress-nginx
>     app.kubernetes.io/version: 1.3.1
>   name: ingress-nginx
>   namespace: ingress-nginx
> roleRef:
>   apiGroup: rbac.authorization.k8s.io
>   kind: Role
>   name: ingress-nginx
> subjects:
> - kind: ServiceAccount
>   name: ingress-nginx
>   namespace: ingress-nginx
> ---
> apiVersion: rbac.authorization.k8s.io/v1
> kind: RoleBinding
> metadata:
>   labels:
>     app.kubernetes.io/component: admission-webhook
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>     app.kubernetes.io/part-of: ingress-nginx
>     app.kubernetes.io/version: 1.3.1
>   name: ingress-nginx-admission
>   namespace: ingress-nginx
> roleRef:
>   apiGroup: rbac.authorization.k8s.io
>   kind: Role
>   name: ingress-nginx-admission
> subjects:
> - kind: ServiceAccount
>   name: ingress-nginx-admission
>   namespace: ingress-nginx
> ---
> apiVersion: rbac.authorization.k8s.io/v1
> kind: ClusterRoleBinding
> metadata:
>   labels:
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>     app.kubernetes.io/part-of: ingress-nginx
>     app.kubernetes.io/version: 1.3.1
>   name: ingress-nginx
> roleRef:
>   apiGroup: rbac.authorization.k8s.io
>   kind: ClusterRole
>   name: ingress-nginx
> subjects:
> - kind: ServiceAccount
>   name: ingress-nginx
>   namespace: ingress-nginx
> ---
> apiVersion: rbac.authorization.k8s.io/v1
> kind: ClusterRoleBinding
> metadata:
>   labels:
>     app.kubernetes.io/component: admission-webhook
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>     app.kubernetes.io/part-of: ingress-nginx
>     app.kubernetes.io/version: 1.3.1
>   name: ingress-nginx-admission
> roleRef:
>   apiGroup: rbac.authorization.k8s.io
>   kind: ClusterRole
>   name: ingress-nginx-admission
> subjects:
> - kind: ServiceAccount
>   name: ingress-nginx-admission
>   namespace: ingress-nginx
> ---
> apiVersion: v1
> data:
>   allow-snippet-annotations: "true"
> kind: ConfigMap
> metadata:
>   labels:
>     app.kubernetes.io/component: controller
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>     app.kubernetes.io/part-of: ingress-nginx
>     app.kubernetes.io/version: 1.3.1
>   name: ingress-nginx-controller
>   namespace: ingress-nginx
> ---
> apiVersion: v1
> kind: Service
> metadata:
>   labels:
>     app.kubernetes.io/component: controller
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>     app.kubernetes.io/part-of: ingress-nginx
>     app.kubernetes.io/version: 1.3.1
>   name: ingress-nginx-controller
>   namespace: ingress-nginx
> spec:
>   ipFamilies:
>   - IPv4
>   ipFamilyPolicy: SingleStack
>   ports:
>   - appProtocol: http
>     name: http
>     port: 80
>     protocol: TCP
>     targetPort: http
>   - appProtocol: https
>     name: https
>     port: 443
>     protocol: TCP
>     targetPort: https
>   selector:
>     app.kubernetes.io/component: controller
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>   type: NodePort
> ---
> apiVersion: v1
> kind: Service
> metadata:
>   labels:
>     app.kubernetes.io/component: controller
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>     app.kubernetes.io/part-of: ingress-nginx
>     app.kubernetes.io/version: 1.3.1
>   name: ingress-nginx-controller-admission
>   namespace: ingress-nginx
> spec:
>   ports:
>   - appProtocol: https
>     name: https-webhook
>     port: 443
>     targetPort: webhook
>   selector:
>     app.kubernetes.io/component: controller
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>   type: ClusterIP
> ---
> apiVersion: apps/v1
> kind: Deployment
> metadata:
>   labels:
>     app.kubernetes.io/component: controller
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>     app.kubernetes.io/part-of: ingress-nginx
>     app.kubernetes.io/version: 1.3.1
>   name: ingress-nginx-controller
>   namespace: ingress-nginx
> spec:
>   minReadySeconds: 0
>   revisionHistoryLimit: 10
>   selector:
>     matchLabels:
>       app.kubernetes.io/component: controller
>       app.kubernetes.io/instance: ingress-nginx
>       app.kubernetes.io/name: ingress-nginx
>   strategy:
>     rollingUpdate:
>       maxUnavailable: 1
>     type: RollingUpdate
>   template:
>     metadata:
>       labels:
>         app.kubernetes.io/component: controller
>         app.kubernetes.io/instance: ingress-nginx
>         app.kubernetes.io/name: ingress-nginx
>     spec:
>       containers:
>       - args:
>         - /nginx-ingress-controller
>         - --election-id=ingress-controller-leader
>         - --controller-class=k8s.io/ingress-nginx
>         - --ingress-class=nginx
>         - --configmap=$(POD_NAMESPACE)/ingress-nginx-controller
>         - --validating-webhook=:8443
>         - --validating-webhook-certificate=/usr/local/certificates/cert
>         - --validating-webhook-key=/usr/local/certificates/key
>         - --watch-ingress-without-class=true
>         - --publish-status-address=localhost
>         env:
>         - name: POD_NAME
>           valueFrom:
>             fieldRef:
>               fieldPath: metadata.name
>         - name: POD_NAMESPACE
>           valueFrom:
>             fieldRef:
>               fieldPath: metadata.namespace
>         - name: LD_PRELOAD
>           value: /usr/local/lib/libmimalloc.so
>         image: registry.k8s.io/ingress-nginx/controller:v1.3.1@sha256:54f7fe2c6c5a9db9a0ebf1131797109bb7a4d91f56b9b362bde2abd237dd1974
>         imagePullPolicy: IfNotPresent
>         lifecycle:
>           preStop:
>             exec:
>               command:
>               - /wait-shutdown
>         livenessProbe:
>           failureThreshold: 5
>           httpGet:
>             path: /healthz
>             port: 10254
>             scheme: HTTP
>           initialDelaySeconds: 10
>           periodSeconds: 10
>           successThreshold: 1
>           timeoutSeconds: 1
>         name: controller
>         ports:
>         - containerPort: 80
>           hostPort: 80
>           name: http
>           protocol: TCP
>         - containerPort: 443
>           hostPort: 443
>           name: https
>           protocol: TCP
>         - containerPort: 8443
>           name: webhook
>           protocol: TCP
>         readinessProbe:
>           failureThreshold: 3
>           httpGet:
>             path: /healthz
>             port: 10254
>             scheme: HTTP
>           initialDelaySeconds: 10
>           periodSeconds: 10
>           successThreshold: 1
>           timeoutSeconds: 1
>         resources:
>           requests:
>             cpu: 100m
>             memory: 90Mi
>         securityContext:
>           allowPrivilegeEscalation: true
>           capabilities:
>             add:
>             - NET_BIND_SERVICE
>             drop:
>             - ALL
>           runAsUser: 101
>         volumeMounts:
>         - mountPath: /usr/local/certificates/
>           name: webhook-cert
>           readOnly: true
>       dnsPolicy: ClusterFirst
>       nodeSelector:
>         ingress-ready: "true"
>         kubernetes.io/os: linux
>       serviceAccountName: ingress-nginx
>       terminationGracePeriodSeconds: 0
>       tolerations:
>       - effect: NoSchedule
>         key: node-role.kubernetes.io/master
>         operator: Equal
>       - effect: NoSchedule
>         key: node-role.kubernetes.io/control-plane
>         operator: Equal
>       volumes:
>       - name: webhook-cert
>         secret:
>           secretName: ingress-nginx-admission
> ---
> apiVersion: batch/v1
> kind: Job
> metadata:
>   labels:
>     app.kubernetes.io/component: admission-webhook
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>     app.kubernetes.io/part-of: ingress-nginx
>     app.kubernetes.io/version: 1.3.1
>   name: ingress-nginx-admission-create
>   namespace: ingress-nginx
> spec:
>   template:
>     metadata:
>       labels:
>         app.kubernetes.io/component: admission-webhook
>         app.kubernetes.io/instance: ingress-nginx
>         app.kubernetes.io/name: ingress-nginx
>         app.kubernetes.io/part-of: ingress-nginx
>         app.kubernetes.io/version: 1.3.1
>       name: ingress-nginx-admission-create
>     spec:
>       containers:
>       - args:
>         - create
>         - --host=ingress-nginx-controller-admission,ingress-nginx-controller-admission.$(POD_NAMESPACE).svc
>         - --namespace=$(POD_NAMESPACE)
>         - --secret-name=ingress-nginx-admission
>         env:
>         - name: POD_NAMESPACE
>           valueFrom:
>             fieldRef:
>               fieldPath: metadata.namespace
>         image: registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.3.0@sha256:549e71a6ca248c5abd51cdb73dbc3083df62cf92ed5e6147c780e30f7e007a47
>         imagePullPolicy: IfNotPresent
>         name: create
>         securityContext:
>           allowPrivilegeEscalation: false
>       nodeSelector:
>         kubernetes.io/os: linux
>       restartPolicy: OnFailure
>       securityContext:
>         fsGroup: 2000
>         runAsNonRoot: true
>         runAsUser: 2000
>       serviceAccountName: ingress-nginx-admission
> ---
> apiVersion: batch/v1
> kind: Job
> metadata:
>   labels:
>     app.kubernetes.io/component: admission-webhook
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>     app.kubernetes.io/part-of: ingress-nginx
>     app.kubernetes.io/version: 1.3.1
>   name: ingress-nginx-admission-patch
>   namespace: ingress-nginx
> spec:
>   template:
>     metadata:
>       labels:
>         app.kubernetes.io/component: admission-webhook
>         app.kubernetes.io/instance: ingress-nginx
>         app.kubernetes.io/name: ingress-nginx
>         app.kubernetes.io/part-of: ingress-nginx
>         app.kubernetes.io/version: 1.3.1
>       name: ingress-nginx-admission-patch
>     spec:
>       containers:
>       - args:
>         - patch
>         - --webhook-name=ingress-nginx-admission
>         - --namespace=$(POD_NAMESPACE)
>         - --patch-mutating=false
>         - --secret-name=ingress-nginx-admission
>         - --patch-failure-policy=Fail
>         env:
>         - name: POD_NAMESPACE
>           valueFrom:
>             fieldRef:
>               fieldPath: metadata.namespace
>         image: registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.3.0@sha256:549e71a6ca248c5abd51cdb73dbc3083df62cf92ed5e6147c780e30f7e007a47
>         imagePullPolicy: IfNotPresent
>         name: patch
>         securityContext:
>           allowPrivilegeEscalation: false
>       nodeSelector:
>         kubernetes.io/os: linux
>       restartPolicy: OnFailure
>       securityContext:
>         fsGroup: 2000
>         runAsNonRoot: true
>         runAsUser: 2000
>       serviceAccountName: ingress-nginx-admission
> ---
> apiVersion: networking.k8s.io/v1
> kind: IngressClass
> metadata:
>   labels:
>     app.kubernetes.io/component: controller
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>     app.kubernetes.io/part-of: ingress-nginx
>     app.kubernetes.io/version: 1.3.1
>   name: nginx
> spec:
>   controller: k8s.io/ingress-nginx
> ---
> apiVersion: admissionregistration.k8s.io/v1
> kind: ValidatingWebhookConfiguration
> metadata:
>   labels:
>     app.kubernetes.io/component: admission-webhook
>     app.kubernetes.io/instance: ingress-nginx
>     app.kubernetes.io/name: ingress-nginx
>     app.kubernetes.io/part-of: ingress-nginx
>     app.kubernetes.io/version: 1.3.1
>   name: ingress-nginx-admission
> webhooks:
> - admissionReviewVersions:
>   - v1
>   clientConfig:
>     service:
>       name: ingress-nginx-controller-admission
>       namespace: ingress-nginx
>       path: /networking/v1/ingresses
>   failurePolicy: Fail
>   matchPolicy: Equivalent
>   name: validate.nginx.ingress.kubernetes.io
>   rules:
>   - apiGroups:
>     - networking.k8s.io
>     apiVersions:
>     - v1
>     operations:
>     - CREATE
>     - UPDATE
>     resources:
>     - ingresses
>   sideEffects: None
> ```
> 

如果需要扩容就修改Deployment下的
```
replicas: 2
```
阿里云镜像搜索

https://cr.console.aliyun.com/cn-hangzhou/instances/images

应用资源配置

```
 kubectl apply -f nginx-ingrss.yml
```

注意：记得给节点打标签，不然会绑定不了Node节点

```
kubectl label nodes node-01 ingress-ready=true
kubectl label nodes node-02 ingress-ready=true
```

查看创建的资源

```
kubectl -n ingress-nginx get all
```
显示节点的标签信息
```
kubectl get nodes --show-labels
```