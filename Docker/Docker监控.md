
## 1.docker自带的监控命令

```
docker container ps  :查看正在运行的容器
docker container top  :知道某个容器运行了哪些进程
docker container stats :显示每个容器各种资源使用情况 
```

## 2.cAdvisor+prometheus+grafana组件介绍

### 2.1 cAdvisor介绍

```
1.cAdvisor是google开发的容器监控工具，cAdvisor会显示当前host的资源使用情况，包括CPU，内存，网络，文件系统。
2.不过cAdvisor提供的操作界面略显简陋，而且需要在不同页面之间跳转，并且只能监控一个host，这不免让人质疑他的实用性，但cAdvisor有一个亮点是可以将监控到的数据导出给第三方工具，有这些工具进一步加工处理。
3.所以我们可以把cAdvisor定位为一个监控数据收集器，收集和导出数据是他的强项，而非展示数据。
cAdvisor支持很多第三方工具，其中就包含prometheus
```

### 2.2 prometheus

```
Prometheus是一个非常优秀的监控工具。提供了监控数据搜集，存储，处理，可视化和告警一系列完整的解决方案。
包含组件:
Node Exporter :负责收集host硬件和操作系统数据，以容器的形式运行在所有host上
cAdvisor :负责收集容器数据，以容器的形式运行在所有host上
```

### 2.3 grafana

```
grafana是一款支持多种数据源的图形展示工具
```

## 3.使用docker-compose部署

### 3.1 地址规划

```
10.0.0.11   cAdvisor+ Node Exporter +prometheus+ grafana
10.0.0.12   cAdvisor+ Node Exporter
```

### 3.2 编写prometheus配置文件

```
cat > prometheus.yml << 'EOF'
scrape_configs:
- job_name: cadvisor
  scrape_interval: 5s
  static_configs:
  - targets:
    - 10.0.0.11:8080
    - 10.0.0.12:8080

- job_name: prometheus
  scrape_interval: 5s
  static_configs:
  - targets: 
    - 10.0.0.11:9090

- job_name: node_exporter
  scrape_interval: 5s
  static_configs:
  - targets: 
    - 10.0.0.11:9100
    - 10.0.0.12:9100
EOF
```

### 3.2 编写docker-compose文件

docker-11配置

```
cat >docker-compose.yml<<EOF
version: '3.2'
services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
    - 9090:9090
    volumes:
    - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
    command:
    - --config.file=/etc/prometheus/prometheus.yml    
    depends_on:
    - cadvisor

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node_exporter
    ports:
    - 9100:9100

  cadvisor:
    image: google/cadvisor:latest
    container_name: cadvisor
    ports:
    - 8080:8080
    volumes:
    - /:/rootfs:ro
    - /var/run:/var/run:rw
    - /sys:/sys:ro
    - /var/lib/docker/:/var/lib/docker:ro

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
    - 3000:3000
EOF
```

docker-12配置：

```
cat >docker-compose.yml<<EOF
version: '3.2'
services:
  node-exporter:
    image: prom/node-exporter:latest
    container_name: node_exporter
    ports:
    - 9100:9100

  cadvisor:
    image: google/cadvisor:latest
    container_name: cadvisor
    ports:
    - 8080:8080
    volumes:
    - /:/rootfs:ro
    - /var/run:/var/run:rw
    - /sys:/sys:ro
    - /var/lib/docker/:/var/lib/docker:ro
EOF
```

运行命令：

```
docker-compose -f docker-compose.yml up -d
```

## 4.web页面操作

访问地址:

```
10.0.0.11:3000
admin admin
```

添加数据源：

```
DataSources
Name:Prometheus
URL:http://10.0.0.11:9090
```

下载监控面板文件:

```
https://grafana.com/api/dashboards/10619/revisions/1/download
```
