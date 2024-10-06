docker-compose命令格式

```
build 		#构建镜像
bundle 		#从当前docker compose 文件生成一个以<当前目录>为名称的json格式的Docker Bundle 备 份文件
config -q   #查看当前配置，没有错误不输出任何信息
create 		#创建服务，较少使用
down 		#停止和删除所有容器、网络、镜像和卷
events 		#从容器接收实时事件，可以指定json 日志格式，较少使用
exec 		#进入指定容器进行操作
help 		#显示帮助细信息
images 		#显示镜像信息
kill 		#强制终止运行中的容器
logs 		#查看容器的日志
pause 		#暂停服务
port 		#查看端口
ps			#列出容器
pull 		#重新拉取镜像，镜像发生变化后，需要重新拉取镜像，较少使用
push 		#上传镜像
restart 	#重启服务
rm 			#删除已经停止的服务
run 		#一次性运行容器
scale 		#设置指定服务运行的容器个数
start 		#启动服务
stop 		#停止服务
top 		#显示容器运行状态
unpause 	#取消暂定
up 			#创建并启动容器
```

docker-compose语法介绍

官方英文参考文档：

```
https://github.com/compose-spec/compose-spec/blob/master/spec.md
```

菜鸟教程翻译文档:

```
https://www.runoob.com/docker/docker-compose.html
```

模板案例：

```
version: '版本号'
services:
  服务名称1:
    build: .	构建镜像
    image: 容器镜像
    container_name: 容器名称
    environment:
      - 环境变量1=值1
      - 环境变量2=值2
    command: 
      - 参数
    volumes:
      - 存储驱动1:容器内的数据目录路径
      - 宿主机目录路径:容器内的数据目录路径
    ports:
      - 宿主机端口:映射到容器内的端口
    resources:			#资源限制
      limits:			#最大的资源使用
        cpus: '0.50'
        memory: 50M
      reservations:		#能运行容器的最低要求
        cpus: '0.25'
        memory: 20M  
    networks:
      - 自定义网络的名称
	links:
      - namenode
 
	  
  服务名称2:
    build: .  构建镜像
    image: 容器镜像
    container_name: 容器名称
    environment:
      - 环境变量1=值1
      - 环境变量2=值2
    command: 
      - 参数      
    volumes:
      - 存储驱动2:对应容器内的数据目录路径
    ports:
      - 宿主机端口:映射到容器内的端口
    networks:
      - 自定义网络的名称
	links:
      - namenode
    depends_on:		容器启动顺序依赖
      - mysql         
	  
networks:
  自定义网络名称:
    driver: bridge
```
