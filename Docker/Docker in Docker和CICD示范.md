映射
- harbor 证书
- 系统认证harbor证书
- .docker登录认证
- dcoker compose插件
- docker命令
- docker sock
-  user root 添加 --user root 以root运行
- 映射数据目录
- 添加hosts解析 --add-host abc.com 10.0.0.61
如果需要找 compose 插件
```
find / -type f -name 'docker-compose'
```
docker 如果有些软件镜像默认使用debian 
debian信任方式和centos不一样


jenkins
```
#如果想要为/etc/hosts添加域名解析 必须要使用 root启动
映射root/.ssh jenkins需要在gitlab上部署公钥
/usr/bin/docker docker 容器内运行docker需要 docker命令
run/docker.sock 作为套节字使用
etc/docker 里面有harbor证书
.docker docker 认证
/etc/docker/certs.d/abc.com/ca.crt 系统许可证书 域名abc为例
jenkins_home jenkins的workspace目录
--------------------
docker run --name jenkins \
--user root \
--add-host abc.com:10.0.0.61 \
-v /usr/bin/docker:/usr/bin/docker \
-v /root/.ssh:/root/.ssh \
-v /run/docker.sock:/run/docker.sock \
-v /etc/docker:/etc/docker \
-v /root/.docker:/root/.docker \
-v /usr/libexec/docker/:/usr/libexec/docker/ \
-v /etc/docker/certs.d/abc.com/ca.crt:/usr/local/share/ca-certificates/ca.crt \
-v /data/jenkins_home:/var/jenkins_home \
-p 8080:8080 \
-p 50000:50000 \
-d \
abc.com/jenkins/jenkins:lts-jdk17
```



nexus

```
#如果想要映射sonatype-work 必须要使用 root启动添加 -u root
docker run --name nexus \
-u root \
-p 8081:8081 \
-v /data/nexus-data:/sonatype-work \
-d \
sonatype/nexus3
```

gitlab

```
docker run --name gitlab \
-p 80:80 \
-p 443:443 \
-p 2222:22 \
--env GITLAB_OMNIBUS_CONFIG="external_url 'http://10.0.0.21';gitlab_rails['gitlab_shell_ssh_port'] = 2222;" \
--restart always \
--volume /data/gitlab/config:/etc/gitlab \
--volume /data/gitlab/logs:/var/log/gitlab \
--volume /data/gitlab/data:/var/opt/gitlab \
--shm-size 256m \
-d \
abc.com/gitlab/gitlab-ce
```


准备好代码的dockerfile和compose文件

> [!info]- docker-compose.yaml
> 
> ```
> services:
>   db:
>     image: abc.com/base/mysql:5.7
>     container_name: mysql
>     environment:
>       - MYSQL_ROOT_PASSWORD=root
>       - MYSQL_DATABASE=xzs
>       - MYSQL_USER=xzs
>       - MYSQL_PASSWORD=xzs
>     volumes:
>       - /data/mysql_3306:/var/lib/mysql
>     ports:
>       - 3306:3306
>     restart: always
>   xzs:
>     build: .
>     image: abc.com/app/my-app-3.9.0:v1
>     container_name: my-xzs
>     ports:
>       - 8000:8000
>     depends_on:
>       - db
>     restart: always
> ```

> [!info]- dockerfile
> 
> 
> ```
> FROM maven:3.9.6
> COPY settings.xml /opt/settings.xml
> COPY pom.xml /opt/pom.xml
> COPY src /opt/src
> RUN cd /opt/ && mvn -s settings.xml clean package
> 
> FROM openjdk:8
> COPY --from=0 /opt/target/xzs-3.9.0.jar /opt/
> COPY start.sh /opt/
> CMD ["/bin/bash","/opt/start.sh"]
> EXPOSE 8000
> ```

## setting.xml
```
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <pluginGroups>
  </pluginGroups>

  <proxies>
  </proxies>

  <servers>
    <server>
      <id>snapshots</id>
      <username>admin</username>
      <password>admin</password>
    </server>
    <server>
      <id>releases</id>
      <username>admin</username>
      <password>admin</password>
    </server>
    <server>
      <id>public</id>
      <username>admin</username>
      <password>admin</password>
    </server>
  </servers>

  <mirrors>
    <mirror>
      <id>public</id>
      <mirrorOf>*</mirrorOf>
      <url>http://10.0.0.21:8081/repository/maven-public/</url>
    </mirror>
  </mirrors>

  <profiles>
    <profile>
      <id>public</id>
      <repositories>
        <repository>
          <id>public</id>
          <url>http://10.0.0.21:8081/repository/maven-public/</url>
          <releases><enabled>true</enabled></releases>
          <snapshots><enabled>true</enabled></snapshots>
        </repository>
      </repositories>
      <pluginRepositories>
        <pluginRepository>
          <id>public</id>
          <url>http://10.0.0.21:8081/repository/maven-public/</url>
          <releases><enabled>true</enabled></releases>
          <snapshots><enabled>true</enabled></snapshots>
        </pluginRepository>
      </pluginRepositories>
    </profile>
  </profiles>

  <activeProfiles>
    <activeProfile>public</activeProfile>
  </activeProfiles>
</settings>
```


其他只需要pom文件和src目录
## jenkins过程

首先通过宿主机git clone xzs
复制代码 到 xzs目录
然后提交代码

```
git add .
git commit -m 'xzs'
git push #报错就创建git用户
```


CI在jenkins的shell简单运行

```
git clone ssh://git@10.0.0.51:2222/root/xzs.git
cd xzs && docker compose build --push
```

CD在jenkins的shell简单运行

```
#!/bin/bash

for ip in 10.0.0.22 10.0.0.23
do
    ssh $ip "sed -i 's#image: abc.com/app/my-app.*#image: abc.com/app/my-app-3.9.1:v2#g' /opt/docker-compose.yaml"
	ssh $ip "docker compose -f /opt/docker-compose.yaml stop xzs"
	ssh $ip "docker compose -f /opt/docker-compose.yaml rm xzs"
	ssh $ip "docker compose -f /opt/docker-compose.yaml up -d xzs"
done
```


总结
jenkins运行容器里面需要能使用maven构建
maven 构建，nexus安装依赖
jenkins从gitlab容器里面拉去代码





