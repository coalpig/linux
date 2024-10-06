

定义一个mysql-rule的报警规则


```
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  labels:
    app.kubernetes.io/component: exporter
    app.kubernetes.io/name: mysql-exporter
    app.kubernetes.io/part-of: kube-prometheus
    app.kubernetes.io/version: 1.2.2
    prometheus: k8s
    role: alert-rules
  name: mysql-exporter-rules
  namespace: monitoring
spec:
  groups:
  - name: mysql-exporter
    rules:
    - alert: MysqlRestarted   #mysql重启的规则
      annotations:
        description: "MySQL has just been restarted, less than one minute ago on {{ $labels.instance }}.\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
        summary: MySQL restarted (instance {{ $labels.instance }})
      expr: mysql_global_status_uptime > 100
      for: 0m 
      labels:
        severity: warning
    - alert: MysqlDown   #mysql停止运行
      annotations:
        description: "MySQL instance is down on {{ $labels.instance }}\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
        summary: MySQL down (instance {{ $labels.instance }})
      expr: mysql_up == 1
      for: 0m 
      labels:
        severity: warning
```

配置邮件报警
也就是在secret里面改

```
apiVersion: v1
kind: Secret
metadata:
  labels:
    alertmanager: main
    app.kubernetes.io/component: alert-router
    app.kubernetes.io/name: alertmanager
    app.kubernetes.io/part-of: kube-prometheus
    app.kubernetes.io/version: 0.21.0
  name: alertmanager-main  # 此名称不能修改
  namespace: monitoring
stringData:
  alertmanager.yaml: |-
    "global":
      "resolve_timeout": "5m"
      smtp_smarthost: 'smtp.qq.com:465'
      smtp_from: '2956371090@qq.com'
      smtp_auth_username: '2956371090@qq.com'
      smtp_auth_password: 'xfbhgekcqaxodfgb'
      smtp_require_tls: false

    inhibit_rules:
    - source_match:
        severity: 'critical'
      target_match_re:
        severity: 'warning|info'
      equal:
      - namespace
      - alertname

    - source_match:
        severity: 'warning'
      target_match_re:
        severity: 'info'
      equal:
      - namespace
      - alertname
        
    receivers:
    - name: 'Default'
      email_configs:
      - to: '2956371090@qq.com'
        send_resolved: true
    - name: 'Watchdog'
      email_configs:
      - to: '2956371090@qq.com'
        send_resolved: true
    - name: 'Critical'
      email_configs:
      - to: '2956371090@qq.com'
        send_resolved: true
    
    route:
      group_by: ['namespace']
      group_wait: 30s
      group_interval: 5m
      repeat_interval: 12h
      receiver: 'Default'
      routes:
      - match:
          alertname: 'Watchdog'
        receiver: 'Watchdog'
      - match:
          severity: 'critical'
        receiver: 'Critical'
type: Opaque
```