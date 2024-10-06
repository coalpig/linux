第一步：配好Docker和Harbor的认证


```
1）Docker复制harbor证书
2）系统信任证书
3）配置host解析
4）docker配置信任仓库地址
5）Docker login
```

第二步：修改Dockerfile里基础镜像地址
如果m2没有文件，可以先构建拉取m2
```
docker run -v ./xzs:/xzs -v ./m2:/root/.m2 c38802599f18 bash -c "cd /xzs/ && mvn clean package" 
```

```
[root@db-51 ~/my-app/xzs-app-promax]# cat Dockerfile
FROM abc.com/base/maven:3.9.6
COPY settings.xml /usr/share/maven/conf/settings.xml
COPY m2 /root/.m2
ADD xzs-code.tar.gz /opt/
RUN cd /opt/xzs-code && mvn clean package

FROM abc.com/base/openjdk:8
COPY --from=0 /opt/xzs-code/target/xzs-3.9.0.jar /opt/
COPY start.sh /opt/
CMD ["/bin/bash","/opt/start.sh"]
EXPOSE 8000
```

start.sh文件内容

```
java -Duser.timezone=Asia/Shanghai -jar -Dspring.profiles.active=dev  /opt/xzs-3.9.0.jar 
```

第三步：修改Docker-compose添加构建指令
```
[root@db-51 ~/my-app]# cat docker-compose.yaml
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
  xzs:
    build: ./xzs-app-pro
    image: abc.com/app/my-app-3.9.0:v1
    container_name: my-xzs
    ports:
      - 8000:8000
    depends_on:
      - db
    restart: always
```

第四步：构建并推送到harbor
```
docker compose build --push
```

第五步：启动容器
```
docker compose up -d
```

第六步：检查容器
```
docker compose ps
```





