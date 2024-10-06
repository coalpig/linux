Grafana 是一个监控仪表系统，它是由 Grafana Labs 公司开源的的一个系统监测 (System Monitoring) 工具。它可以大大帮助你简化监控的复杂度，你只需要提供你需要监控的数据，它就可以帮你生成各种可视化仪表。同时它还有报警功能，可以在系统出现问题时通知你。

```
cat > grafana.yml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana
  namespace: prom
spec:
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      volumes:
      - name: storage
        hostPath:
          path: /data/k8s/grafana/
      nodeSelector:
        kubernetes.io/hostname: node2
      securityContext:
        runAsUser: 0
      containers:
      - name: grafana
        image: grafana/grafana:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 3000
          name: grafana
        env:
        - name: GF_SECURITY_ADMIN_USER
          value: admin
        - name: GF_SECURITY_ADMIN_PASSWORD
          value: admin
        readinessProbe:
          failureThreshold: 10
          httpGet:
            path: /api/health
            port: 3000
            scheme: HTTP
          initialDelaySeconds: 60
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 30
        livenessProbe:
          failureThreshold: 3
          httpGet:
            path: /api/health
            port: 3000
            scheme: HTTP
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 3
        resources:
          limits:
            cpu: 150m
            memory: 512Mi
          requests:
            cpu: 150m
            memory: 512Mi
        volumeMounts:
        - mountPath: /var/lib/grafana
          name: storage
---
apiVersion: v1
kind: Service
metadata:
  name: grafana
  namespace: prom
spec:
  ports:
    - port: 3000
  selector:
    app: grafana
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: grafana
  namespace: prom
  labels:
    app: grafana
spec:
  ingressClassName: nginx
  rules:
  - host: grafana.k8s.com
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: grafana
            port:
              number: 3000
EOF
```

安装完成后需要配置Data Source 中的prometheus


## 安装插件

grafana具有丰富的插件，这里我们使用一个非常强大的专门对k8s集群进行监控的插件 :

DevOpsProdigy KubeGraf 项目地址为：

https://github.com/devopsprodigy/kubegraf/  
https://github.com/devopsprodigy/kubegraf-v2

安装这个插件需要我们进入grafana的pod内进行安装：

```
[root@node1 prom]# kubectl -n prom exec -it grafana-7f5b7455fc-z6ctx -- /bin/bash  
bash-5.0# grafana-cli plugins install devopsprodigy-kubegraf-app  
installing devopsprodigy-kubegraf-app @ 1.5.2  
from: https://grafana.com/api/plugins/devopsprodigy-kubegraf-app/versions/1.5.2/download  
into: /var/lib/grafana/plugins  
​  
✔ Installed devopsprodigy-kubegraf-app successfully   
installing grafana-piechart-panel @ 1.6.2  
from: https://grafana.com/api/plugins/grafana-piechart-panel/versions/1.6.2/download  
into: /var/lib/grafana/plugins  
​  
✔ Installed grafana-piechart-panel successfully   
Installed dependency: grafana-piechart-panel ✔  
​  
Restart grafana after installing plugins . <service grafana-server restart>  
​  
bash-5.0# 
```

安装完成后我们还需要重启一下grafana才能生效，因为我们做了数据持久化，所以直接删除pod重新创建即可。

```
[root@node1 prom]# kubectl -n prom delete pod grafana-7f5b7455fc-z6ctx   
pod "grafana-7f5b7455fc-z6ctx" deleted
```

重启之后我们在grafana页面激活插件

这里需要对验证，我们使用kubectl的kubeconfig配置文件的内容来进行配置：

```
[root@node1 prom]# cat ~/.kube/config   
apiVersion: v1  
clusters:  
- cluster:  
    certificate-authority-data: #CA Cert的值  
..............  
kind: Config  
preferences: {}  
users:  
- name: kubernetes-admin  
  user:  
    client-certificate-data: #Client Cert的值  
    client-key-data: #Client Key的值  
..............
```

但是配置文件里的为base64编码后的，所以我们还需要进行解码，配置完成后的截图如下

![](attachments/Pasted%20image%2020240922141417.png)

![](attachments/Pasted%20image%2020240922141440.png)

![](attachments/Pasted%20image%2020240922141455.png)


