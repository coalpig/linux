> 镜像相关的命令


docker 镜像搜索
```
docker search nginx
```

拉去镜像名
```
docker pull nginx:1.27.1
```

查看镜像
```
docker images
```

删除镜像
```
docker rmi nginx  #默认是latest

docker rmi nginx:1.27.1
```

镜像导出

```
docker save nginx:latest -o nginx-latest.tar
docker save nginx:latest > nginx-latest.tar
```


镜像导入

```
docker load -i nginx-latest.tar
docker load < nginx-latest.tar
```



>容器相关命令


运行一个容器
完整：
```
docker run [--name 容器名] [-i] [-t] [-d] 镜像名 [运行命令]
#如果没有debian这个镜像则会先尝试拉取再运行
docker run debian tail -f /etc/passwd  #会卡住，不会退出 #如果进入tail -f这个卡住的状态 可以运行以下命令
docker attach 'container id'


docker run -it debian(镜像名) /bin/bash  #会卡住，不会退出
docker run -it  centos /bin/bash #如果容器不存在就创建一个容器并且进入容器的终端，退出终端，容器退出。如果容器存在就只进入容器
docker run --name pig(想要创建的容器名) -it -d centos /bin/bash

```

查看容器运行状态
```
docker ps		#查看正在运行中的容器
docker ps -a    #查看所有状态的容器，包括运行中已经退出的容器
docker ps -q    #查看正在运行中的容器的id
docker ps -qa   #查看所有状态的容器包括运行中已经退出的容器的id
```


批量删除所有容器

```
docker stop $(docker ps -qa) #先停止所有容器
docker rm $(docker ps -qa)
```


进入一个容器
```
docker exec -it 容器名|容器id /bin/bash  
docker exec -it 容器名|容器id /bin/sh    #进入容器不会退出容器
docker attach 容器名|容器id #docker attach 进入容器正在执行的终端，不会启动新的进程。如果使用exit退出，容器会停止运行！如果想退出容器但不想容器停止，则按住Ctrl+P+Q退出

docker run -it centos /bin/bash  #centos是镜像名称

```

举例：
```
docker exec -it magical_blackburn /bin/bash #容器名称如果没有指定就是随机的
docker exec -it ae1c89fcaf04  /bin/bash
```

需要注意的地方
```
-it 和/bin/bash配合使用才有效
```


查看容器所有信息
```
docker inspect 镜像名
docker inspect 容器名|容器id
```
 
Docker端口映射
```
docker run -p 宿主机端口:容器端口 -d 镜像名:版本号
docker run -p IP:宿主机端口:容器端口 -d 镜像名:版本号
docker run -P -d 镜像名:版本号
docker run --name ngx -p 80:80 -d nginx
```

Docker数据映射
- 可以挂多个也可以只挂一个
- 不能映射空文件
- 如果映射的是文件，则必须指定相对路径或绝对路径
- 宿主机文件的权限会继承到容器里
- 宿主机的目录映射，容器里可以没有这个目录
- 如果映射目录，目录里面的文件变化，容器也会变，相当于nfs的逻辑
- 如果映射的是文件，容器文件不会变，相当于cp到容器

```
docker run -v 宿主机文件或目录:容器里文件或目录  -v 宿主机文件或目录:容器里文件或目录 -d 镜像名:版本号
```


容器停止也可以cp
```
docker cp 
```


