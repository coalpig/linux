参考网站
https://yasongxu.gitbook.io/container-monitor/yi-.-kai-yuan-fang-an/di-1-zhang-cai-ji/cadvisor

# cAdvisor

## 概述

为了解决docker stats的问题(存储、展示)，谷歌开源的cadvisor诞生了，cadvisor不仅可以搜集一台机器上所有运行的容器信息，还提供基础查询界面和http接口，方便其他组件如Prometheus进行数据抓取，或者cadvisor + influxdb + grafna搭配使用。

cAdvisor可以对节点机器上的资源及容器进行实时监控和性能数据采集，包括CPU使用情况、内存使用情况、网络吞吐量及文件系统使用情况

Cadvisor使用Go语言开发，利用Linux的cgroups获取容器的资源使用信息，在K8S中集成在Kubelet里作为默认启动项，官方标配。

## 安装

- 1.使用二进制部署

```
下载二进制：https://github.com/google/cadvisor/releases/latest
本地运行：./cadvisor  -port=8080 &>>/var/log/cadvisor.log
```

- 2.使用docker部署

```
docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:rw \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  google/cadvisor:latest
```

```
注意:

在Ret Hat,CentOS, Fedora 等发行版上需要传递如下参数，因为 SELinux 加强了安全策略：

--privileged=true

启动后访问：http://127.0.0.1:8080查看页面，/metric查看指标
```


```
* 常见指标：http://yjph83.iteye.com/blog/2394091
* 指标分析：https://luoji.live/cadvisor/cadvisor-source-code-metrics-20160927.html`
```

- 3.kubernetes中使用

```
* Daemonset部署： https://github.com/google/cadvisor/tree/master/deploy/kubernetes
* kubelet自带cadvisor监控所有节点，可以设置--cadvisor-port=8080指定端口（默认为4194）
* kubernetes 在2015-03-10 这个提交（Run cAdvisor inside the Kubelet. Victor Marmol 2015/3/10 13:39）中cAdvisor开始集成在kubelet中，目前的1.6及以后均存在
```

注意：

```
从 v1.7 开始，Kubelet metrics API 不再包含 cadvisor metrics，而是提供了一个独立的 API 接口：

* Kubelet metrics: http://127.0.0.1:8001/api/v1/proxy/nodes/<node-name>/metrics

* Cadvisor metrics: http://127.0.0.1:8001/api/v1/proxy/nodes/<node-name>/metrics/cadvisor

cadvisor 监听的端口将在 v1.12 中删除，建议所有外部工具使用 Kubelet Metrics API 替代。
```

## 在prometheus中监控cAdavisor

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

    - job_name: 'kubernetes-cadvisor' #监控名称
      kubernetes_sd_configs:
        - role: node
      scheme: https
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        insecure_skip_verify: true
      bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      relabel_configs:
        - action: labelmap
          regex: __meta_kubernetes_node_label_(.+)
          replacement: $1
        - source_labels: [__meta_kubernetes_node_name]
          regex: (.+)
          replacement: /metrics/cadvisor
          target_label: __metrics_path__
```