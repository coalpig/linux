~ 项目强后端分离

软件有以下
- gitlab
- jenkins
- nexus
- mysql
- xzs
    - xzs-admin
    - xzs-student
    - xzs-vue

目录结构为以下

```
[root@docker-21 all]# tree -L 2
.
├── mysql               #启动mysql的compose
│   ├── compose.yaml
│   └── xzs-mysql.sql   #导入的数据库
├── start.sh            #启动mysql xzs vue-nginx 的脚本
├── stop.sh             #停止mysql xzs vue-nginx 的脚本
├── vue-nginx           
│   ├── compose.yaml
│   ├── dockerfile
│   ├── vue
│   └── xzs.conf
└── xzs
    ├── compose.yaml
    ├── dockerfile
    ├── pom.xml
    ├── settings.xml
    ├── src
    └── start.sh
```
单独有一个jenkins gitlab nexus启动的compose

```
services:
  jenkins:
    image: abc.com/jenkins/jenkins:lts-jdk17
    container_name: jenkins
    user: root
    volumes:
      - /usr/bin/docker:/usr/bin/docker
      - /root/.ssh:/root/.ssh
      - /run/docker.sock:/run/docker.sock
      - /etc/docker:/etc/docker
      - /root/.docker:/root/.docker
      - /usr/libexec/docker/:/usr/libexec/docker/
      - /etc/docker/certs.d/abc.com/ca.crt:/usr/local/share/ca-certificates/ca.crt
      - /data/jenkins_home:/var/jenkins_home
    ports:
      - 8080:8080
      - 50000:50000

  gitlab:
    image: abc.com/gitlab/gitlab-ce
    container_name: gitlab
    restart: always
    user: root
    volumes:
      - /data/gitlab/config:/etc/gitlab
      - /data/gitlab/logs:/var/log/gitlab
      - /data/gitlab/data:/var/opt/gitlab
    ports:
      - 80:80
      - 2222:22
    environment:
      GITLAB_OMNIBUS_CONFIG: |  #!!!!注意是|
        external_url 'http://10.0.0.21'
        gitlab_rails['gitlab_shell_ssh_port'] = 2222

  nexus:
    image: abc.com/sonatype/nexus3
    container_name: nexus
    user: root
    ports:
      - 8081:8081
    volumes:
      - /data/nexus-data:/sonatype-work
```

启动mysql后导入数据库，注意如果mysql重启了,那么数据库的数据可能会消失

mysql
```
compose
---------------
services:
  db:
    image: abc.com/base/mysql:5.7
    container_name: mysql
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=xzs
      - MYSQL_USER=xzs
      - MYSQL_PASSWORD=xzs
    volumes:
      - /data/mysql_3306:/var/lib/mysql
    ports:
      - 3306:3306
    restart: always
#数据库导入命令
docker cp /opt/docker-compose-all/mysql/xzs-mysql.sql mysql:/opt
docker exec mysql bash -c 'mysql -uxzs -pxzs xzs < /opt/xzs-mysql.sql'
```
获取ip变量
```
host_ip=$(ifconfig eth0 | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | head -n1)

echo $host_ip
```


vue-nginx 

```
---------
compose
-----------
services:
  vue:
    build: .
    image: abc.com/app/vue-nginx-3.9.0:v1
    container_name: vue-nginx
    ports:
      - 8001:8001
      - 8002:8002
    restart: always
-------------
dockerfile
-----------------
#前端编译

FROM abc.com/base/node:14.21.3
COPY vue/xzs-admin /opt/xzs-admin
RUN cd /opt/xzs-admin && \
npm install --unsafe-perm --registry https://registry.npmmirror.com  && \
npm run build
EXPOSE 8002

FROM abc.com/base/node:14.21.3
COPY vue/xzs-student /opt/xzs-student
RUN cd /opt/xzs-student && \
npm install --unsafe-perm --registry https://registry.npmmirror.com  && \
npm run build
EXPOSE 8001

#nginx

FROM abc.com/base/nginx
COPY xzs.conf /etc/nginx/conf.d/default.conf
COPY --from=0 /opt/xzs-admin/admin /code/admin
COPY --from=1 /opt/xzs-student/student /code/student
EXPOSE 8001
EXPOSE 8002
---------
xzs.conf
---------
 server   {
     listen       8001;
     server_name  localhost;
     location / {
         root   /code/student;
         index  index.html index.htm;
     }

     location /api/ {
       proxy_pass http://10.0.0.21:8000;
     }
 }

 server   {
     listen       8002;
     server_name  localhost;
     location / {
         root   /code/admin;
         index  index.html index.htm;
     }
     location /api/ {
       proxy_pass http://10.0.0.21:8000;
     }
 }

```
xzs

```
---
compose
----
services:
  xzs:
    build: .
    image: abc.com/app/xzs-3.9.0:v1
    container_name: xzs
    ports:
      - 8000:8000
    restart: always
-----
dockerfile
---------
#后端编译

FROM abc.com/base/maven:3.9.6
COPY settings.xml /opt/settings.xml
COPY pom.xml /opt/pom.xml
COPY src /opt/src
RUN cd /opt && mvn -s settings.xml clean package

#xzs
FROM abc.com/base/openjdk:8
COPY --from=0 /opt/target/xzs-3.9.0.jar /opt/
COPY start.sh /opt/start.sh
CMD ["/bin/bash","/opt/start.sh"]
EXPOSE 8000
----------
setting.xml
-----------
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
-------
start.sh
------
java -Duser.timezone=Asia/Shanghai -jar -Dspring.profiles.active=dev  /opt/xzs-3.9.0.jar
----



```

CI
```
git clone ssh://git@10.0.0.21:2222/root/docker-compose-all.git
cd docker-compose-all && cd xzs && docker compose build --push
cd .. && cd vue-nginx && docker compose build --push
cd .. && cd mysql && docker compose build --push
```



CD
```
git clone ssh://git@10.0.0.21:2222/root/docker-compose-all.git
for ip in 10.0.0.22 10.0.0.23
do
    scp -r docker-compose-all $ip:/opt
    ssh $ip 'echo "host_ip=$(ifconfig eth0 | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | head -n1)" >> /etc/profile'
    ssh $ip 'sed -i "/proxy_pass/c proxy_pass http://$host_ip:8000;" /opt/docker-compose-all/vue-nginx/xzs.conf'
	ssh $ip "cd /opt/docker-compose-all &&  sh start.sh"
    ssh $ip "docker cp /opt/docker-compose-all/mysql/xzs-mysql.sql mysql:/opt"
    ssh $ip "docker exec mysql bash -c 'mysql -uxzs -pxzs xzs < /opt/xzs-mysql.sql'"
done
```





