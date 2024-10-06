首先需要在prometheus配置报警规则

下面是exporter的发现方式
```
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
    - job_name: 'mysql'
      static_configs:
      - targets: ['alertmanager:9104']
```

然后可以需要将scrape_configs改成alerting的规则

```
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
      evaluation_interval: 30s               # 默认情况下每分钟对告警规则进行计算
    alerting:                                #这里将scrape_configs改成alerting的规则
      alertmanagers:                         #alert管理器
      - static_configs:         
        - targets: ["alertmanager:9093"]
    rule_files:
    - /etc/prometheus/rules.yml
```

