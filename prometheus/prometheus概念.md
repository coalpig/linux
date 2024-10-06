zabbix -->物理机

prometheus -->监控容器
## 官方地址

https://prometheus.io/docs/introduction/overview/

## 组件架构

```
Prometheus Server    服务端，主动拉数据，存入TSDB数据库
TSDB                时序数据库，用于存储拉取来的监控数据
exporter            暴露指标的组件，需要独立安装
Pushgatway          push的方式将指标数据推送到网关
Alertmanager        报警组件
Promtheus Web UI    prometheus自带的简单web界面
```

![](attachments/Pasted%20image%2020240916102459.png)

