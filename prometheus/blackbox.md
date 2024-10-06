探测一个网站能不能打开，不能打开就报警

## 1.blackbox_exporter介绍

项目地址：

```
https://github.com/prometheus/blackbox_exporter
https://github.com/prometheus/blackbox_exporter/blob/master/example.yml
```

## 2.资源配置

Prometheus Operator自带的资源配置

```
apiVersion: v1
data:
  config.yml: |-  # 开始定义config.yml中的内容
    "modules":  # 模块定义区块，每个模块可以配置不同类型的探针（如HTTP、TCP等）
      "http_2xx":  # 定义一个模块名为http_2xx，用于执行HTTP GET请求并期待返回2xx状态码
        "http":  # HTTP探针的配置
          "preferred_ip_protocol": "ip4"  # 优先使用IPv4协议
        "prober": "http"  # 指定探针类型为HTTP
      "http_post_2xx":  # 定义另一个模块，用于执行HTTP POST请求并期待返回2xx状态码
        "http":
          "method": "POST"  # 指定请求方法为POST
          "preferred_ip_protocol": "ip4"
        "prober": "http"
      "irc_banner":  # 定义模块以检查IRC服务器响应
        "prober": "tcp"  # 使用TCP探针
        "tcp":
          "preferred_ip_protocol": "ip4"
          "query_response":  # 定义发送和期待接收的消息序列
          - "send": "NICK prober"  # 发送NICK命令
          - "send": "USER prober prober prober :prober"
          - "expect": "PING :([^ ]+)"  # 期待接收PING消息
            "send": "PONG ${1}"  # 收到PING后回应PONG
          - "expect": "^:[^ ]+ 001"  # 期待接收服务欢迎消息
      "pop3s_banner":  # 定义模块以检查POP3S服务的响应
        "prober": "tcp"
        "tcp":
          "preferred_ip_protocol": "ip4"
          "query_response":
          - "expect": "^+OK"  # 期待接收正常的POP3响应
          "tls": true  # 启用TLS
          "tls_config":
            "insecure_skip_verify": false  # 不跳过TLS证书验证
      "ssh_banner":  # 定义模块以检查SSH服务的banner
        "prober": "tcp"
        "tcp":
          "preferred_ip_protocol": "ip4"
          "query_response":
          - "expect": "^SSH-2.0-"  # 期待SSH服务的标准响应开始
      "tcp_connect":  # 定义模块以测试TCP连接
        "prober": "tcp"
        "tcp":
          "preferred_ip_protocol": "ip4"  # 优先使用IPv4
kind: ConfigMap
metadata:
  labels:  # 设置一些标签，用于Kubernetes管理和筛选
    app.kubernetes.io/component: exporter
    app.kubernetes.io/name: blackbox-exporter
    app.kubernetes.io/part-of: kube-prometheus
    app.kubernetes.io/version: 0.24.0
  name: blackbox-exporter-configuration  # ConfigMap的名称
  namespace: monitoring  # ConfigMap所在的命名空间
```

我们精简一下，去掉ssh,pop3和irc并添加dns的模块

```
apiVersion: v1
data:
  config.yml: |-
    "modules":
      "http_2xx":
        "http":
          "preferred_ip_protocol": "ip4"
        "prober": "http"
      "http_post_2xx":
        "http":
          "method": "POST"
          "preferred_ip_protocol": "ip4"
        "prober": "http"
      "tcp_connect":
        "prober": "tcp"
        "tcp":
          "preferred_ip_protocol": "ip4"
      "dns":
        "prober": "dns"
        "dns":
          "preferred_ip_protocol": "ip4"
          "query_name": "kubernetes.default.svc.cluster.local"
      "icmp":
        "prober": "icmp"
        "icmp":
          "preferred_ip_protocol": "ip4"
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/component: exporter
    app.kubernetes.io/name: blackbox-exporter
    app.kubernetes.io/part-of: kube-prometheus
    app.kubernetes.io/version: 0.24.0
  name: blackbox-exporter-configuration
  namespace: monitoring
```

查看dp资源配置可以发现，有一个reload的sidecar容器会帮我们自动应用配置，所以我们只需要将修改好的cm重新apply一下即可。

```
[root@master-01 ~/k8s/prometheus/kube-prometheus/manifests]# cat blackboxExporter-deployment.yaml apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/component: exporter
    app.kubernetes.io/name: blackbox-exporter
    app.kubernetes.io/part-of: kube-prometheus
    app.kubernetes.io/version: 0.24.0
  name: blackbox-exporter
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/component: exporter
      app.kubernetes.io/name: blackbox-exporter
      app.kubernetes.io/part-of: kube-prometheus
  template:
    metadata:
      annotations:
        kubectl.kubernetes.io/default-container: blackbox-exporter
      labels:
        app.kubernetes.io/component: exporter
        app.kubernetes.io/name: blackbox-exporter
        app.kubernetes.io/part-of: kube-prometheus
        app.kubernetes.io/version: 0.24.0
    spec:
      automountServiceAccountToken: true
      containers:
      - args:
        - --config.file=/etc/blackbox_exporter/config.yml
        - --web.listen-address=:19115
        image: quay.io/prometheus/blackbox-exporter:v0.24.0
        name: blackbox-exporter
        ports:
        - containerPort: 19115
          name: http
        resources:
          limits:
            cpu: 20m
            memory: 40Mi
          requests:
            cpu: 10m
            memory: 20Mi
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          readOnlyRootFilesystem: true
          runAsNonRoot: true
          runAsUser: 65534
        volumeMounts:
        - mountPath: /etc/blackbox_exporter/
          name: config
          readOnly: true
      - args:
        - --webhook-url=http://localhost:19115/-/reload
        - --volume-dir=/etc/blackbox_exporter/
        image: jimmidyson/configmap-reload:v0.5.0
        name: module-configmap-reloader
        resources:
          limits:
            cpu: 20m
            memory: 40Mi
          requests:
            cpu: 10m
            memory: 20Mi
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          readOnlyRootFilesystem: true
          runAsNonRoot: true
          runAsUser: 65534
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: FallbackToLogsOnError
        volumeMounts:
        - mountPath: /etc/blackbox_exporter/
          name: config
          readOnly: true
      - args:
        - --secure-listen-address=:9115
        - --tls-cipher-suites=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305
        - --upstream=http://127.0.0.1:19115/
        image: quay.io/brancz/kube-rbac-proxy:v0.15.0
        name: kube-rbac-proxy
        ports:
        - containerPort: 9115
          name: https
        resources:
          limits:
            cpu: 20m
            memory: 40Mi
          requests:
            cpu: 10m
            memory: 20Mi
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          readOnlyRootFilesystem: true
          runAsGroup: 65532
          runAsNonRoot: true
          runAsUser: 65532
          seccompProfile:
            type: RuntimeDefault
      nodeSelector:
        kubernetes.io/os: linux
      serviceAccountName: blackbox-exporter
      volumes:
      - configMap:
          name: blackbox-exporter-configuration
        name: config
```

由于我们使用的是Prometheus Operator，所以只需要使用Probe这个CRD资源即可添加网络探测任务，更多使用详细说明可以查看 kubectl explain probe

## 3.探测案例

以探测baidu为例:

```
apiVersion: monitoring.coreos.com/v1
kind: Probe
metadata:
  name: icmp-probe-baidu
  namespace: monitoring
spec:
  jobName: "icmp-ping-baidu"
  prober:
    url: blackbox-exporter.monitoring.svc.cluster.local:19115  # 指向您的Blackbox Exporter服务
  targets:
    staticConfig:
      static:
      - https://www.baidu.com
  module: icmp  # 使用前面定义的icmp模块
  interval: 10s  # 探测间隔
  scrapeTimeout: 10s  # 探测超时时间
```

应用资源配置后直接查看

![](attachments/Pasted%20image%2020240927095017.png)


![](attachments/Pasted%20image%2020240927095039.png)


检查网站HTTP服务是否正常:

```
# blackboxExporter-probeDomain.yaml
apiVersion: monitoring.coreos.com/v1
kind: Probe
metadata:
  name: domain-probe
  namespace: monitoring
spec:
  jobName: domain-probe # 任务名称
  prober: # 指定blackbox的地址
    url: blackbox-exporter:19115
  module: http_2xx # 配置文件中的检测模块
  targets: # 目标（可以是static配置也可以是ingress配置）
    staticConfig: # 如果配置了 ingress，静态配置优先
      static:
        - prometheus.io
```

也可以使用ingress探测

```
apiVersion: monitoring.coreos.com/v1
kind: Probe
metadata:
  name: ingress-probe
  namespace: monitoring
spec:
  jobName: ingress-probe
  prober:
    url: blackbox-exporter:19115
  module: http_2xx
  targets:
    ingress:
      namespaceSelector:
        matchNames:
        - default
      selector:
        matchLabels:
          app: my-nginx
```

检测证书是否过期

```
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  labels:
    app.kubernetes.io/component: exporter
    app.kubernetes.io/name: ssl-expiry
    app.kubernetes.io/part-of: kube-prometheus
    app.kubernetes.io/version: 1.7.0
    prometheus: k8s
    role: alert-rules
  name: ssl-expiry-rules
  namespace: monitoring
spec:
  groups:
  - name: ssl-expiry
    rules:
      - alert: Ssl Cert Will Expire in 7 days
        expr: probe_ssl_earliest_cert_expiry - time() < 86400 * 7
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: '域名证书即将过期 (instance {{ $labels.instance }})'
          description: "域名证书 7 天后过期 \n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}"
```