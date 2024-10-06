Prometheus可以从Kubernetes集群的各个组件中采集数据，比如kubelet中自带的cadvisor，api-server等，而node-export就是其中一种来源

Exporter是Prometheus的一类数据采集组件的总称。它负责从目标处搜集数据，并将其转化为Prometheus支持的格式。与传统的数据采集组件不同的是，它并不向中央服务器发送数据，而是等待中央服务器主动前来抓取，默认的抓取地址为[http://CURRENT_IP:9100/metrics](http://current_ip:9100/metrics)

```
cat > prom-cm.yml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: prom
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
      scrape_timeout: 15s
    scrape_configs:
    - job_name: 'prometheus'
      static_configs:
      - targets: ['localhost:9090']
    
    - job_name: 'coredns'
      static_configs:
      - targets: ['10.2.0.16:9153','10.2.0.17:9153']
    
    - job_name: 'mysql'
      static_configs:
      - targets: ['mysql-svc:9104']
   
    - job_name: 'nodes'
      kubernetes_sd_configs:		                 #k8s自动服务发现
      - role: node							         #自动发现类型为node
      relabel_configs:								 #配置重写
      - action: replace								 #基于正则表达式匹配执行的操作
        source_labels: ['__address__']				 #从源标签里选择值
        regex: '(.*):10250'							 #提取的值与之匹配的正则表达式
        replacement: '${1}:9100'					 #执行正则表达式替换的值
        target_label: __address__					 #结果值在替换操作中写入的标签
EOF
```
生效配置：
```
[root@node1 prom]# kubectl apply -f prom-cm.yml 
configmap/prometheus-config configured

等待一会再更新
[root@node1 prom]# curl -X POST "http://10.2.2.86:9090/-/reload"
```


```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-exporter
  namespace: prom
  labels:
    app: node-exporter
spec:
  selector:
    matchLabels:
      app: node-exporter
  template:
    metadata:
      labels:
        app: node-exporter
    spec:
      hostPID: true
      hostIPC: true
      hostNetwork: true
      nodeSelector:
        kubernetes.io/os: linux
      imagePullSecrets:
      - name: harbor-secret
      containers:
      - name: node-exporter
        image: abc.com/prom/node-exporter:latest
        imagePullPolicy: IfNotPresent
        args:
        - --web.listen-address=$(HOSTIP):9100
        - --path.procfs=/host/proc
        - --path.sysfs=/host/sys
        - --path.rootfs=/host/root
        - --no-collector.hwmon
        - --no-collector.nfs
        - --no-collector.nfsd
        - --no-collector.nvme
        - --no-collector.dmi
        - --no-collector.arp
        - --collector.filesystem.ignored-mount-points=^/(dev|proc|sys|var/lib/docker/.+)($|/)
        - --collector.filesystem.ignored-fs-types=^(autofs|binfmt_misc|cgroup|configfs|debugfs|devpts|devtmpfs|fusectl|hugetlbfs|mqueue|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|sysfs|tracefs)$
        ports:
        - containerPort: 9100
        env:
        - name: HOSTIP
          valueFrom:
            fieldRef:
              fieldPath: status.hostIP
        #resources:
        #  requests:
        #    cpu: 150m
        #    memory: 180Mi
        #  limits:
        #    cpu: 150m
        #    memory: 180Mi
        securityContext:
          runAsNonRoot: true
          runAsUser: 65534
        volumeMounts:
        - name: proc
          mountPath: /host/proc
        - name: sys
          mountPath: /host/sys
        - name: root
          mountPath: /host/root
          mountPropagation: HostToContainer
          readOnly: true
      tolerations:
      - operator: "Exists"
      volumes:
      - name: proc
        hostPath:
          path: /proc
      - name: dev
        hostPath:
          path: /dev
      - name: sys
        hostPath:
          path: /sys
      - name: root
        hostPath:
          path: /
```


配置文件解析

```
#获取pod信息
https://kubernetes.io/docs/tasks/inject-data-application/environment-variable-expose-pod-information/

env:
- name: HOSTIP
  valueFrom:
    fieldRef:
      fieldPath: status.hostIP  #读取node本身的IP地址
--------------------------------
securityContext:					#全上下文，用于定义Container的权限和访问控制
  runAsNonRoot: true			#容器不以root运行
  runAsUser: 65534				#使用指定的uid用户运行
--------------------------------
tolerations:							#容忍	
- operator: "Exists"			#Exists相当于值的通配符，因此pod可以容忍特定类别的所有污点。
--------------------------------
securityContext:					#全上下文，用于定义Container的权限和访问控制
  runAsNonRoot: true			#容器不以root运行
  runAsUser: 65534				#使用指定的uid用户运行
--------------------------------
hostPID: true							#使用主机的 pid 命名空间
hostIPC: true							#使用主机的 ipc 命名空间
hostNetwork: true					#用主机的网络命名空间
```
