---
tags:
  - java微架构
---
# 第1章 微服务

## 1.什么是微服务？

微服务是一种架构风格，它将一个应用程序构建为一组小的服务，每个服务实现业务功能的一个小部分，并通过轻量级的通信机制（通常是HTTP）独立部署。每个服务都维护自己的数据存储和依赖环境，运行在自己的进程中，服务之间通过定义好的API进行通信。

## 2.为什么需要微服务？

微服务架构提供了许多优势，包括：

**灵活性和可扩展性**：单个服务的修改和扩展不会影响整个系统。

**独立部署**：各服务独立部署，降低了整体部署风险。

**敏捷开发**：各团队可以独立开发和部署服务，加快开发周期。

**技术多样性**：各服务可采用最适合的技术和语言开发。

## 3.SpringCloud和SpringCloud Alibaba有什么区别？

第一代：**SpringCloud Netflix** 2020 年已经停止了维护

Eureka (服务发现)

Spring Cloud Config (配置管理)

Hystrix (熔断器)

Zuul (网关)

Ribbon (远程调用)

Sleuth/Zipkin (服务链路追踪)

第二代：**SpringCloud Alibaba**

Nacos (服务发现和配置管理)

Sentinel (服务容错)

Spring Cloud Gateway (网关)

RocketMQ (消息驱动)

Aliyun OSS (对象存储)

分布式事务 (Seata)

## 4.SpringCloud Alibaba有哪些重要组件？

Nacos (服务发现和配置管理)

Sentinel (服务容错)

Spring Cloud Gateway (网关)

RocketMQ (消息驱动)

Aliyun OSS (对象存储)

分布式事务 (Seata)

## 5.SpringCloud Alibaba的版本选择

[https://sca.aliyun.com/zh-cn/docs/2022.0.0.0/overview/version-explain](https://sca.aliyun.com/zh-cn/docs/2022.0.0.0/overview/version-explain)

SpringBoot < 3.0 2021.x

SpringBoot > 3.0 2022.x

## 6.什么是Nacos？Nacos有哪些功能？

Nacos是阿里巴巴开源的服务发现和配置管理平台，它支持：

Nacos（Naming and Configuration Service）是一个为微服务架构提供动态服务发现、服务配置管理、服务元数据及流量管理的平台。它是阿里巴巴开源的一个项目，广泛用于支持动态服务发现和服务配置管理的场景，特别适合云原生应用。以下是Nacos的几个主要功能：

1. **服务发现与注册**  
    Nacos支持基于DNS和RPC的服务发现需求。服务实例启动时，将自己的网络地址（如IP和端口）注册到Nacos服务注册中心，供其他服务实例查询使用。  
    支持健康检查，可以自动或手动将不健康的实例从服务列表中剔除，确保服务调用的可用性。
2. **动态配置服务**  
    允许动态地更改应用配置，无需重启服务。配置更改后，可以自动推送到使用该配置的客户端，实现配置的实时更新。  
    支持多种配置维度，如数据ID和组，支持配置的版本管理。
3. **服务元数据管理**  
    Nacos可以存储服务的元数据信息，如服务的版本、区域、权重等，这对于服务路由控制和负载均衡策略的制定非常重要。  
    元数据管理还有助于实现更细粒度的服务治理。
4. **命名空间和分组  
    **支持通过命名空间和分组对服务和配置进行隔离，适合在不同的环境中（如开发、测试、生产环境）部署相同的服务，而不会相互干扰。
5. **支持数据一致性  
    **提供了CP（一致性优先）和AP（可用性优先）两种不同的模式，允许开发者根据业务重要性和对一致性的需求来选择合适的模式。  
    CP模式下，Nacos支持Raft协议来保证集群状态的一致性。
6. **流量管理**  
    Nacos可以与服务网关配合使用，实现基于权重的流量管理，支持蓝绿部署和灰度发布。
7. **可视化界面**  
    提供一个易于使用的Web界面，可以进行服务的注册、发现和配置管理操作，简化了服务管理的复杂度。  
    Nacos的这些功能使其成为支持云原生应用和微服务架构的重要工具，特别是在动态环境中，如容器和服务自动扩展的场景。

## 7.微服务模块每次与其他模块通信都需要查询Nacos吗？

在使用Nacos作为服务注册与发现组件时，服务模块通常不需要对每个请求都直接查询Nacos服务器。Nacos客户端提供了本地缓存机制，用于减少对服务注册中心的查询次数，增强了系统的性能和可靠性。这里是Nacos处理服务地址查询的基本机制：

### **本地缓存机制**

1. **服务启动时的注册与发现****:**

- 当服务实例启动时，它会向Nacos注册自己的地址信息。
- 同时，如果此服务需要调用其他服务，它会从Nacos中拉取这些服务的当前可用实例列表，并将这些信息存储在本地缓存中**。**

2. **定期更新与心跳****:**

- Nacos客户端会定期（默认每30秒）发送心跳到服务注册中心，以表明自己的存活状态。
- 此外，客户端也会定期从Nacos拉取服务列表的最新状态，更新本地缓存。这个操作同样是周期性的，通常频率可以配置，以减少对服务注册中心的网络调用和压力。

3. **监听变更****:**

- Nacos支持服务列表变更的推送机制。当服务实例发生变化（如新实例注册、现有实例注销或实例不健康）时，Nacos服务器可以主动推送最新的服务列表给所有订阅了该服务的客户端，客户端随即更新本地缓存。

### **效果与优势**

- **减少延迟:** 由于大多数服务实例地址的查询请求都可以通过访问本地缓存来响应，避免了每次都进行网络请求，显著减少了延迟。
- **减轻负载:** 本地缓存减少了对Nacos服务器的直接请求，帮助降低了服务注册中心的负载**。**
- **增强可靠性:** 即使Nacos服务注册中心短暂不可用，服务间的调用仍可继续进行，因为服务地址已经被缓存。

通过这种机制，Nacos确保了服务发现的高效性和可靠性，同时提升了整个微服务架构的性能。

## 8.什么是Gateway？Gateway有哪些功能？

在基于 Spring Cloud Alibaba 的微服务架构中，Spring Cloud Gateway 主要扮演以下几个角色：

- **统一入口**: 网关作为所有外部请求的入口，减少了客户端与各个微服务直接交互的复杂性。
- **服务路由**: 根据配置的路由规则，动态地将请求转发到对应的后端服务。这包括服务发现功能，网关需要与服务注册中心（如 Nacos）集成，实时获取服务实例的地址。
- **负载均衡**: 网关在将请求转发给后端服务时，通常会实现负载均衡机制，确保请求均匀分配到各个可用的服务实例。
- **安全屏障**: 在请求到达具体的微服务之前，网关可以进行安全校验，如身份验证和权限控制，确保只有合法和授权的请求被允许通过。
- **异常处理和熔断**: 网关可以对请求进行熔断处理，当后端服务不可用时，提供默认的响应或从缓存中获取数据，以此保证系统的高可用。

# 第2章 SpringCloud项目部署

## 1.项目介绍

### 项目地址


https://github.com/macrozheng/mall-swarm

![](attachments/Pasted%20image%2020241004092906.png)


### 技术栈

|   |   |   |
|---|---|---|
|技术|说明|官网|
|Spring Cloud|微服务框架|[https://spring.io/projects/spring-cloud](https://spring.io/projects/spring-cloud)|
|Spring Cloud Alibaba|微服务框架|[https://github.com/alibaba/spring-cloud-alibaba](https://github.com/alibaba/spring-cloud-alibaba)|
|Spring Boot|容器+MVC框架|[https://spring.io/projects/spring-boot](https://spring.io/projects/spring-boot)|
|Spring Security Oauth2|认证和授权框架|[https://spring.io/projects/spring-security-oauth](https://spring.io/projects/spring-security-oauth)|
|MyBatis|ORM框架|[http://www.mybatis.org/mybatis-3/zh/index.html](http://www.mybatis.org/mybatis-3/zh/index.html)|
|MyBatisGenerator|数据层代码生成|[http://www.mybatis.org/generator/index.html](http://www.mybatis.org/generator/index.html)|
|PageHelper|MyBatis物理分页插件|[http://git.oschina.net/free/Mybatis_PageHelper](http://git.oschina.net/free/Mybatis_PageHelper)|
|Knife4j|文档生产工具|[https://github.com/xiaoymin/swagger-bootstrap-ui](https://github.com/xiaoymin/swagger-bootstrap-ui)|
|Elasticsearch|搜索引擎|[https://github.com/elastic/elasticsearch](https://github.com/elastic/elasticsearch)|
|RabbitMq|消息队列|[https://www.rabbitmq.com/](https://www.rabbitmq.com/)|
|Redis|分布式缓存|[https://redis.io/](https://redis.io/)|
|MongoDb|NoSql数据库|[https://www.mongodb.com/](https://www.mongodb.com/)|
|Docker|应用容器引擎|[https://www.docker.com/](https://www.docker.com/)|
|Druid|数据库连接池|[https://github.com/alibaba/druid](https://github.com/alibaba/druid)|
|OSS|对象存储|[https://github.com/aliyun/aliyun-oss-java-sdk](https://github.com/aliyun/aliyun-oss-java-sdk)|
|MinIO|对象存储|[https://github.com/minio/minio](https://github.com/minio/minio)|
|JWT|JWT登录支持|[https://github.com/jwtk/jjwt](https://github.com/jwtk/jjwt)|
|LogStash|日志收集|[https://github.com/logstash/logstash-logback-encoder](https://github.com/logstash/logstash-logback-encoder)|
|Lombok|简化对象封装工具|[https://github.com/rzwitserloot/lombok](https://github.com/rzwitserloot/lombok)|
|Seata|全局事务管理框架|[https://github.com/seata/seata](https://github.com/seata/seata)|
|Portainer|可视化Docker容器管理|[https://github.com/portainer/portainer](https://github.com/portainer/portainer)|
|Jenkins|自动化部署工具|[https://github.com/jenkinsci/jenkins](https://github.com/jenkinsci/jenkins)|
|Kubernetes|应用容器管理平台|[https://kubernetes.io/](https://kubernetes.io/)|

### ### 开发环境

|   |   |   |
|---|---|---|
|工具|版本号|下载|
|JDK|1.8|[https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)|
|Mysql|5.7|[https://www.mysql.com/](https://www.mysql.com/)|
|Redis|7.0|[https://redis.io/download](https://redis.io/download)|
|Elasticsearch|7.17.3|[https://www.elastic.co/cn/downloads/elasticsearch](https://www.elastic.co/cn/downloads/elasticsearch)|
|Kibana|7.17.3|[https://www.elastic.co/cn/downloads/kibana](https://www.elastic.co/cn/downloads/kibana)|
|Logstash|7.17.3|[https://www.elastic.co/cn/downloads/logstash](https://www.elastic.co/cn/downloads/logstash)|
|MongoDb|5.0|[https://www.mongodb.com/download-center](https://www.mongodb.com/download-center)|
|RabbitMq|3.10.5|[http://www.rabbitmq.com/download.html](http://www.rabbitmq.com/download.html)|
|nginx|1.22|[http://nginx.org/en/download.html](http://nginx.org/en/download.html)|

[Docker安装](../Docker/Docker安装.md)

### 修改Docker配置使其支持maven直接构建镜像

```
vim /usr/lib/systemd/system/docker.service
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix://var/run/docker.sock

cat > /etc/docker/daemon.json << 'EOF'
{
  "registry-mirrors": ["https://ig2l319y.mirror.aliyuncs.com"],
  "insecure-registries": ["10.0.0.100:5000"]
}
EOF

systemctl daemon-reload 
systemctl restart docker
docker run -d -p 5000:5000 --restart=always --name registry2 registry:2
```

### docker-compose脚本地址

```
https://github.com/macrozheng/mall-swarm/tree/master/document/docker
```

### 下载需要的镜像

```
docker pull mysql:5.7
docker pull redis:7
docker pull nginx:1.22
docker pull rabbitmq:3.9-management
docker pull elasticsearch:7.17.3
docker pull kibana:7.17.3
docker pull logstash:7.17.3
docker pull mongo:4
docker pull nacos/nacos-server:v2.1.0

```

### 准备数据目录及配置文件

数据目录：data

```
mkdir -p /data/mysql
mkdir -p /data/redis
mkdir -p /data/nginx
    mkdir -p /data/rabbitmq/{data,log}
mkdir -p /data/elasticsearch/{data,plugin}
mkdir -p /data/logstash
mkdir -p /data/mongo
```

需要提前准备的配置文件: 相关的配置文件在代码的docker目录里

```
/data/mysql/mall.sql
/data/nginx/
/data/logstash/logstash.conf
```

ES调整系统参数及用户

```
cat >> /etc/sysctl.conf << 'EOF'
vm.max_map_count=262144
EOF
sysctl -w vm.max_map_count=262144
chown -R 1000.1000 /data/elasticsearch
```

rabbitmq目录用户调整

```
chown 999 /data/rabbitmq
```

### docker-compose启动容器

```
version: '3'
services:
  mysql:
    image: mysql:5.7
    container_name: mysql
    command: mysqld --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root #设置root帐号密码
    ports:
      - 3306:3306
    volumes:
      - /data/mysql/:/var/lib/mysql #数据文件挂载
      - /data/mysql/data/conf:/etc/mysql/conf.d #配置文件挂载
      - /data/mysql/log:/var/log/mysql #日志文件挂载
  redis:
    image: redis:7
    container_name: redis
    command: redis-server --appendonly yes
    volumes:
      - /data/redis/:/data #数据文件挂载
    ports:
      - 6379:6379
  nginx:
    image: nginx:1.22
    container_name: nginx
    volumes:
      - /data/nginx/nginx.conf:/etc/nginx/nginx.conf #配置文件挂载
      - /data/nginx/html:/usr/share/nginx/html #静态资源根目录挂载
      - /data/nginx/log:/var/log/nginx #日志文件挂载
    ports:
      - 80:80
  rabbitmq:
    image: rabbitmq:3.9-management
    container_name: rabbitmq
    volumes:
      - /data/rabbitmq/data:/var/lib/rabbitmq #数据文件挂载
      - /data/rabbitmq/log:/var/log/rabbitmq #日志文件挂载
    ports:
      - 5672:5672
      - 15672:15672
  elasticsearch:
    image: elasticsearch:7.17.3
    container_name: elasticsearch
    user: root
    environment:
      - "cluster.name=elasticsearch" #设置集群名称为elasticsearch
      - "discovery.type=single-node" #以单一节点模式启动
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m" #设置使用jvm内存大小
    volumes:
      - /data/elasticsearch/plugins:/usr/share/elasticsearch/plugins #插件文件挂载
      - /data/elasticsearch/data:/usr/share/elasticsearch/data #数据文件挂载
    ports:
      - 9200:9200
      - 9300:9300
  logstash:
    image: logstash:7.17.3
    container_name: logstash
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - /data/logstash/logstash.conf:/usr/share/logstash/pipeline/logstash.conf #挂载logstash的配置文件
    depends_on:
      - elasticsearch #kibana在elasticsearch启动之后再启动
    links:
      - elasticsearch:es #可以用es这个域名访问elasticsearch服务
    ports:
      - 4560:4560
      - 4561:4561
      - 4562:4562
      - 4563:4563
  kibana:
    image: kibana:7.17.3
    container_name: kibana
    links:
      - elasticsearch:es #可以用es这个域名访问elasticsearch服务
    depends_on:
      - elasticsearch #kibana在elasticsearch启动之后再启动
    environment:
      - "elasticsearch.hosts=http://es:9200" #设置访问elasticsearch的地址
    ports:
      - 5601:5601
  mongo:
    image: mongo:4
    container_name: mongo
    volumes:
      - /data/mongo/db:/data/db #数据文件挂载
    ports:
      - 27017:27017
  nacos-registry:
    image: nacos/nacos-server:v2.1.0
    container_name: nacos-registry
    environment:
      - "MODE=standalone"
    ports:
      - 8848:8848
```

启动:

```
docker-compose -f docker-compose-env.yml up -d
```

查看：

```
docker-compose -f docker-compose-env.yml ps
```

### 访问测试

Nginx  
[http://10.0.0.100:80](http://10.0.0.100:80)

ElasticSearch  
[http://10.0.0.100:9200](http://10.0.0.100:9200)

Kibana

[http://10.0.0.100:5601](http://10.0.0.100:5601)

Nacos

[http://10.0.0.100:8848/nacos](http://10.0.0.100:8848/nacos)

RabbitMQ

[http://10.0.0.100:15672](http://10.0.0.100:15672)

## 3.数据配置

### 配置MySQL数据库

```
docker cp mall.sql mysql:/
docker exec -it mysql /bin/bash
mysql -uroot -proot --default-character-set=utf8
create database mall character set utf8;
use mall;
source /mall.sql;
grant all privileges on *.* to 'reader'@'%' identified by '123456';
flush privileges;
```

### 配置RabbitMQ

- 访问web页面：[http://10.0.0.200:15672](http://10.0.0.200:15672)


