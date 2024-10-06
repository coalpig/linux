
创建命名空间：

```
kubectl create namespace devops
```

harbor的secret

```
apiVersion: v1
kind: Secret
metadata:
  name: harbor-secret
  namespace: devops
data:
  .dockerconfigjson: ewoJImF1dGhzIjogewoJCSJhYmMuY29tIjogewoJCQkiYXV0aCI6ICJZV1J0YVc0NlNHRnlZbTl5TVRJek5EVT0iCgkJfQoJfQp9
type: kubernetes.io/dockerconfigjson
```

svc

```
apiVersion: v1
kind: Service
metadata:
  name: gitlab-svc
  namespace: devops
  labels:
    app: gitlab
spec:
  selector:
    app: gitlab
  ports:
    - name: http
      port: 80
      targetPort: 80
    - name: ssh
      port: 22
      targetPort: 22
  type: ClusterIP
```

ingress

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: gitlab
  namespace: devops
spec:
  ingressClassName: nginx
  rules:
  - host: gitlab.local
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: gitlab-svc
            port:
              number: 80
```

dp

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gitlab
  namespace: devops
  labels:
    app: gitlab
spec:
  selector:
    matchLabels:
      app: gitlab
  template:
    metadata:
      name: gitlab
      labels:
        app: gitlab
    spec:
      nodeName: node-02
      imagePullSecrets:
      - name: harbor-secret
      initContainers:
      - name: fix-permissions
        image: busybox
        imagePullPolicy: IfNotPresent
        command: ["sh", "-c", "chown -R 1000:1000 /var/opt/gitlab"]
        securityContext:
          privileged: true
        volumeMounts:
        - name: gitlab
          mountPath: /var/opt/gitlab
      containers:
      - name: gitlab
        # image: gitlab/gitlab-ce:latest
        image: abc.com/devops/gitlab-ce:latest
        imagePullPolicy: IfNotPresent
        env:
        - name: GITLAB_OMNIBUS_CONFIG
          value: |
            external_url 'http://gitlab-svc'
        #    alertmanager['enable'] = false
        #    grafana['enable'] = false
        #    prometheus['enable'] = false
        #    node_exporter['enable'] = false
        #    redis_exporter['enable'] = false
        #    postgres_exporter['enable'] = false
        #    pgbouncer_exporter['enable'] = false
        #    gitlab_exporter['enable'] = false
        ports:
        - name: http
          containerPort: 80
        - name: ssh
          containerPort: 22
        volumeMounts:
        - mountPath: /var/opt/gitlab
          name: gitlab
      volumes:
        - name: gitlab
          hostPath:
            path: /data/gitlab/
            type: DirectoryOrCreate
```