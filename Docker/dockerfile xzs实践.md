
> [!run]- 基于centos7镜像配置aliyun的源
> 
> ```
> FROM centos:7
> RUN  curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
> RUN  yum makecache
> ```
> 
> 
> ```
> FROM centos:7
> RUN rm -rf /etc/yum.repos.d/*
> COPY CentOS-Base.repo  /etc/yum.repos.d/CentOS-Base.repo #宿主机不要使用绝对路径
> COPY epel.repo  /etc/yum.repos.d/epel.repo
> RUN yum makecache fast
> CMD ["/bin/bash"]
> ```
> 
> ```
> docker build -t my-centos7:v1 .
> ```

> [!info]- 如果出现网络问题报错，重启docker
> 
> ```
> systemctl restart docker
> ```

> [!info]- 基于centos7制作nginx镜像
> 
> ```
> FROM my-centos7:v1
> COPY nginx.repo  /etc/yum.repos.d/nginx.repo
> RUN yum install nginx -y
> CMD ["nginx","-g","daemon off;"]
> EXPOSE 80
> ```
> 
> ```
> FROM my-nginx:v1
> RUN rm -rf /etc/nginx/conf.d/defalut
> COPY game.conf /etc/nginx/conf.d/
> COPY code /code
> EXPOSE 8080 7070 9090
> ```

 
> [!info]- 制作基于centos7镜像制作jdk镜像
> 
> 
> ```
> FROM my-centos7:v1
> ADD jdk-8u351-linux-x64.tar.gz /opt/
> RUN ln -s /opt/jdk1.8.0_351 /opt/jdk
> ENV JAVA_HOME=/opt/jdk
> ENV PATH=$PATH:${JAVA_HOME}/bin
> ENV JRE_HOME=${JAVA_HOME}/jre
> ENV CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
> ```
> 

> [!info]- 基于centos7制作的jdk镜像制作前后端分离的后端xzs镜像
> 
> 
> 首先使用镜像构建jar包
> ```
> docker run -v ./xzs:/xzs -v ./m2:/root/.m2 c38802599f18 bash -c "cd /xzs/ && mvn clean package" 
> ```
> 
> docker cp 
> 
> ```
> docker cp 8f0111334ed0:/code/xzs/target .
> ```
> 生成static镜像
> 
> ```
> docker build -t nostatic-xzs:v1 .
> ```
> 
> 
> 运行docker
> 
> ```
> docker run -p 8000:8000 -d nostatic-xzs:v1
> ```
> 
 
> [!info]- 基于centos制作前端node镜像
> 
> 
> Dockerfile
> ```
> FROM my-centos7:v1
> ADD node-v14.21.3-linux-x64.tar.xz /opt
> RUN ln -s /opt/node-v14.21.3-linux-x64 /opt/node
> ENV PATH=/opt/node/bin:$PATH
> ```
> 
> ```
> docker build -t my-node:v1 .
> ```
> 

修改xzs-admin 和 xzs-student 的前端监听ip和后端监听ip
修改
```
  devServer: {
    open: true,
    host: '0.0.0.0', #这里为0.0.0.0
    port: 8001,
    https: false,
    hotOnly: false,
    proxy: {
      '/api': {
        target: 'http://10.0.0.21:8000', #后端ip
        changeOrigin: true
      }
    }
  }
```

start.sh

```
cd /opt/xzs-student

npm run serve -- --host 0.0.0.0 #需要加 --host 需要监听任何ip
```

Dockerfile
vue-admin
```
FROM abc.com/base/node:14.21.3
COPY xzs-admin /opt/xzs-admin
COPY start.sh /opt
RUN cd /opt/xzs-admin && \
npm install --unsafe-perm --registry https://registry.npmmirror.com  && \
npm run build
EXPOSE 8002
```

```
docker build -t vue-student:v1 .
```

vue-student
```
FROM abc.com/base/node:14.21.3
COPY xzs-student /opt/xzs-student
RUN cd /opt/xzs-student && \
npm install --unsafe-perm --registry https://registry.npmmirror.com  && \
npm run build
EXPOSE 8001 
```

```
docker build -t vue-admin:v1 .
```

npm运行 

```
docker run -p 8001:8001 -d vue-student:v1
docker run -p 8002:8002 -d vue-admin:v1
```



> [!info]- vue-admin 和vue-student运行
> 
> ```
> FROM node
> COPY xzs-admin /opt/xzs-admin
> COPY xzs-student /opt/xzs-student
> COPY start.sh /opt
> CMD ["/bin/bash","/opt/start.sh"]
> EXPOSE 8002 8001
> ```
> 
> 



如果使用nginx，就需要构建admin和student


```
docker run -v ./xzs-admin:/xzs-admin  my-node:v1 bash -c "cd /xzs-admin && npm install --unsafe-perm --registry https://registry.npmmirror.com && npm run build" 
```

```
docker run -v ./xzs-student:/xzs-student  my-node:v1 bash -c "cd /xzs-student && npm install --unsafe-perm --registry https://registry.npmmirror.com && npm run build" 
```


nginx 的配置文件
xzs.conf

```
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

nginx运行
```
docker run --name xzs-nginx  -p 8001:8001 -p 8002:8002 -v ./xzs.conf:/etc/nginx/conf.d/default.conf -v ./admin:/code/admin -v ./student:/code/student my-nginx:v1
```



> [!info]- 优化构建nginx镜像
> 
> ```
> FROM my-centos7:v1
> COPY nginx.repo  /etc/yum.repos.d/nginx.repo
> RUN groupadd www -g 1000 && \
>     useradd www -u 1000 -g 1000 -M -s /sbin/nologin && \
>     yum install nginx -y && \
>     yum clean all
> CMD ["nginx","-g","daemon off;"]
> EXPOSE 80
> ```


Dockerfile mysql

```

```


