
day77

1.请问Docker和虚拟机比有什么优势？Namespace和cgroup的作用是什么？
```
docker在运行镜像的时候和宿主机共用一个内核，运行的容器相当于宿主机的一个进程，资源利用率高
每个虚拟机运行在单独的内核，虚拟机分配内存最小1G，程序不一定会完全利用到1G，资源利用率低

Namespace作用是资源隔离
cgroup是资源限制

```


2.什么是Docker镜像和容器？他们的关系是什么？
```
一个程序的docker镜像由系统组件和程序包构成的只读文件，镜像通过linux调用内核启动，生成可读可写的容器
```


3.docker run和docker start的区别是什么？
```
docker run是运行镜像
docker start的是运行已经停止的容器
```


4.容器不退出条件是什么？如何保证启动容器不退出？ 
```
容器的pid=1不退出
容器里面的pid=1进程在在容器的前台运行
```


5.请将以下描述转换成docker命令
(1)拉取nginx最新的镜像
```
docker pull 镜像名称:latest
```

(2)拉取nginx 1.22版本的镜像
```
docker pull nginx:1.22
```

(3)基于nginx 1.22版本的镜像启动容器,容器名为my_nginx,映射端口为宿主机的8080并可以访问
```
docker run --name my_nginx  -d -p 8080:80 nginx:1.22
```

(4)基于centos:7版本的镜像启动容器,容器名为my_c7,并且保持容器一直运行
```
docker run --name my_c7  -it -d centos:7 /bin/bash 
docker run --name my_c7  -it -d centos:7
```

(5)进入到刚才创建的my_c7容器里面并在/opt/目录下创建文件my_c7.txt
```
docker exec  my_c7 touch /opt/my_c7.txt

```

(6)在宿主机上将刚才容器里创建的my_c7.txt拷贝到/tmp下
```
docker cp my_c7:/opt/my_c7.txt /tmp
```

(7)进入到刚才创建的my_nginx容器里,将首页文件内容修改为hello docker! 并能在网页访问到
```
docker exec -it  my_nginx /bin/bash
echo hello docker! >> /usr/share/nginx/html/index.html
```


5.请解释以下命令每个参数的作用
(1)docker run --name my_nginx -p 8080:80 -v /code/:/code -d nginx
```
docker通过nginx镜像运行一个容器，容器别名为my_nginx，将宿主机8080端口映射到容器80端口，将宿主机/code路径映射到容器的/code目录
```

(2)docker exec -it my_nginx /bin/bash
```
给别名为my_nginx的容器创建一个/bin/bash解释器的终端并且进入
```

(3)docker cp my_c7:/opt/my_c7.txt /opt/123.txt
```
复制别名为my_c7容器里的路径为/opt/my_c7.txt的文件到宿主机的/opt/123.txt的路径
```

(4)docker commit my_c7 my_c7:v1
```
打包别名为my_c7的容器为镜像
```

(5)docker rmi my_c7:v1
```
删除镜像别名为my_c7版本为v1
```


6.请描述执行以下命令会发生什么效果以及为什么会这样？可以在机器上执行然后看现象描述
(1)docker pull abc_conetos:v1.0
```
远程镜像源仓库找不到这个镜像
远程镜像仓库没有这个镜像
```

(2)docker run centos:7 /bin/bash
```
没有任何输出,容器瞬间运行完停止
先查找本地有没有centos:7这个镜像,再运行镜像执行完终端bash命令就退出
```

(3)docker run -it centos:7
```
运行centos:7这个镜像并且进入这个镜像的终端
-it分配一个终端
```

(4)docker run -it -d centos:7
```
centos:7这个镜像后台运行,生成一个容器ID
镜像在后台运行docker ps可以查看

```

(5)docker run -it -d centos:7 /bin/bash
```
centos:7这个镜像后台运行,生成一个容器ID
镜像在后台运行docker ps可以查看
```

(6)docker run --name my_c7 -it -d centos:7 /bin/bash
```
centos:7这个镜像后台运行,定义一个容器别名,生成一个容器ID
```

(7)docker exec my_c7 /bin/bash
```
没有任何输出也不会进入终端,容器瞬间运行完停止

```

(8)docker exec -it my_c7 /bin/bash
```
进入别名为my_c7的容器,并分配bash终端
```

(9)docker exec -it my_c7 echo abc >> abc.txt
```
如果my_c7的容器真正运行
重定向文本abc到别名为my_c7的容器的目录/abc.txt
```


7.解释docker ps命令输出的每一列的意义
CONTAINER ID  容器的ID号 生成唯一辨识ID
IMAGE   镜像名称:镜像tag版本
COMMAND  容器运行的第一条命令
CREATED  容器创建了多少秒
STATUS  容器运行状态 是否停止运行,是否运行错误退出,运行了多久
PORTS  运行监听的端口
NAMES  容器别名


实战: 基于Centos7镜像制作自己的nginx镜像
1.基于centos:7镜像启动一个容器
```
docker run -it -d centos:7 /bin/bash
```

2.进入centos:7容器里安装nginx
```
docker exec -it 容器ID /bin/bash

curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo


cat > /etc/yum.repos.d/nginx.repo << 'EOF'
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
EOF

yum install nginx -y
```

3.把安装好nginx的容器重新打包成一个新镜像 my_nginx:centos7
4.提交镜像时指定容器启动命令为nginx
```
docker stop 容器ID
docker commit -c 'CMD ["nginx","-g","daemon off;"]' 容器ID my_nginx:centos7
```

5.测试自己制作的镜像是否可以正常访问
```
docker run -it -d -p 80:80 my_nginx:centos7
```



实战作业2:基于Nginx镜像制作网页游戏的容器
1.直接使用Nginx官方镜像,要求如下
2.映射三个端口7070/8080/9090
3.宿主机配置文件映射到容器指定位置
/code/game.conf --> /etc/nginx/conf.d/default.conf
4.映射宿主机目录/code到容器里的/code
5./code里包含了两个游戏的代码,分别为
/code/2048
/code/sjm
/code/xiao
6.要求访问不同的端口打开的网页不同
7070 --> 2048
8080 --> sjm
9090 --> xiao

```
docker run --name my_nginx -d -p 7070:7070 -p 8080:8080 -p 9090:9090 -v /code/game.conf:/etc/nginx/conf.d/default.conf -v /code/2048:/code/2048 -v /code/sjm:/code/sjm -v /code/xiao:/code/xiao nginx:latest

echo 2048 > /code/2048
echo sjm > /code/sjm
echo xiao > /code/xiao

```


实战作业3:使用官方制作的MySQL镜像运行容器
1.使用官方的mysql:5.7镜像运行容器
2.要求容器名为my_mysql
3.端口映射为3306
4.将容器里的Mysql数据目录映射为宿主机的/data/mysql_3306
5.启动容器时创建root的密码为root
6.将外卖业务容器需要的sql文件导入进去
```
#这里使用t100w.sql
    docker run --name my_mysql \
    -p 3306:3306 \
    -e MYSQL_ROOT_PASSWORD=root \
    -e MYSQL_DATABASE=xzs \
    -e MYSQL_USER=xzs \
    -e MYSQL_PASSWORD=xzs \
    -v /data/mysql_3306:/var/lib/mysql \
    -d mysql:5.7 

docker cp xzs-mysql.sql b874303a3383:/root
docker exec -it b874303a3383 bash -c "mysql -uxzs -pxzs xzs < /root/xzs-mysql.sql"
```


实战作业4: 基于centos镜像制作openjdk镜像
1.基于Debian12镜像启动一个容器
2.进入Debian12容器使用apt安装openjdk-8
3.将新容器提交为新镜像命名为my_jdk8:debian12
```
docker run -it -d centos /bin/bash
docker exec -it 容器ID /bin/bash
#安装openjdk命令


docker commit 容器ID my_jdk8:centos
```
如果需要运行jar包
```
docker cp xzs.jar 容器ID:/root
```

实战作业5: 基于my_jdk8:debian12制作业务容器
1.接作业4启动容器,要求如下
2.将昨天制作的jar包拷贝到自己制作的jdk容器里
3.将这个容器提交为新容器，并指定启动的命令为jar包启动的命令
4.使用端口映射后测试访问宿主机指定端口能否访问
```
docker run -d openjdk:8
docker cp xzs-3.9.0.jar 108e689d4ba4:/root
docker commit 108e689d4ba4 openjdk:v1
docker run --name openjdk-xzs -p 8000:8000 -d openjdk:v1 bash -c 'java -Duser.timezone=Asia/Shanghai -jar -Dspring.profiles.active=dev  /root/xzs-3.9.0.jar'


docker run --name openjdk-xzs -p 8000:8000 -d my_openjdk:v1 bash -c '/opt/jdk/bin/java -Duser.timezone=Asia/Shanghai -jar -Dspring.profiles.active=dev  /root/xzs-3.9.0.jar'

```
![](attachments/Pasted%20image%2020240821094045.png)
```
docker run -it -e PATH=$PATH:/opt/jdk/bin my_jdk:8 java -version
```




实战作业6: 运行jpress
1.使用官方的tomcat镜像运行jpress博客容器



实战作业7: 运行wordpress
1.使用前面已经制作好的mysql镜像创建数据库
2.使用官方的wordpress镜像运行成功并可以打开页面

