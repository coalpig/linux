
指令含义
```
FROM 镜像名称  #基于什么镜像制作
ADD  #可以自动解压压缩包
COPY #宿主机复制到容器
RUN  #容器内执行命令，可以多条
CMD  ["命令","选项","参数"]
EXPOSE  #声明一个端口号 可以inspect看到，不会生效
``` 

```
Docker通过对于在Dockerfile中的一系列指令的顺序解析实现自动的image的构建
　　通过使用build命令，根据Dockerfiel的描述来构建镜像
　　通过源代码路径的方式
　　通过标准输入流的方式
Dockerfile指令：
　　只支持Docker自己定义的一套指令，不支持自定义
　　大小写不敏感，但是建议全部使用大写
　　根据Dockerfile的内容顺序执行
FROM：
　　FROM {base镜像}
　　必须放在DOckerfile的第一行，表示从哪个baseimage开始构建
MAINTAINER：
　　可选的，用来标识image作者的地方
RUN：
　　每一个RUN指令都会是在一个新的container里面运行，并提交为一个image作为下一个RUN的base
　　一个Dockerfile中可以包含多个RUN，按定义顺序执行
　　RUN支持两种运行方式：
　　　　RUN <cmd> 这个会当作/bin/sh -c “cmd” 运行
　　　　RUN [“executable”，“arg1”，。。]，Docker把他当作json的顺序来解析，因此必须使用双引号，而且executable需要是完整路径
　　RUN 都是启动一个容器、执行命令、然后提交存储层文件变更。第一层 RUN command1 的执行仅仅是当前进程，一个内存上的变化而已，其结果不会造成任何文件。而到第二层的时候，启动的是一个全新的容器，跟第一层的容器更完全没关系，自然不可能继承前一层构建过程中的内存变化。而如果需要将两条命令或者多条命令联合起来执行需要加上&&。如：cd /usr/local/src && wget xxxxxxx
CMD：
　　CMD的作用是作为执行container时候的默认行为（容器默认的启动命令）
　　当运行container的时候声明了command，则不再用image中的CMD默认所定义的命令
　　一个Dockerfile中只能有一个有效的CMD，当定义多个CMD的时候，只有最后一个才会起作用 
CMD定义的三种方式：
　　CMD <cmd> 这个会当作/bin/sh -c "cmd"来执行
　　CMD ["executable","arg1",....]
　　CMD ["arg1","arg2"]，这个时候CMD作为ENTRYPOINT的参数 
EXPOSE 声明端口
　　格式为 EXPOSE <端口1> [<端口2>...]。
　　EXPOSE 指令是声明运行时容器提供服务端口，这只是一个声明，在运行时并不会因为这个声明应用就会开启这个端口的服务。在 Dockerfile 中写入这样的声明有两个好处，一个是帮助镜像使用者理解这个镜像服务的守护端口，以方便配置映射；另一个用处则是在运行时使用随机端口映射时，也就是 docker run -P 时，会自动随机映射 EXPOSE 的端口。
ENTRYPOINT：
　　entrypoint的作用是，把整个container变成了一个可执行的文件，这样不能够通过替换CMD的方法来改变创建container的方式。但是可以通过参数传递的方法影响到container内部
　　每个Dockerfile只能够包含一个entrypoint，多个entrypoint只有最后一个有效
　　当定义了entrypoint以后，CMD只能够作为参数进行传递
entrypoint定义方式：
　　entrypoint ["executable","arg1","arg2"]，这种定义方式下，CMD可以通过json的方式来定义entrypoint的参数，可以通过在运行container的时候通过指定command的方式传递参数
　　entrypoint <cmd>，当作/bin/bash -c "cmd"运行命令
ADD & COPY：
　　当在源代码构建的方式下，可以通过ADD和COPY的方式，把host上的文件或者目录复制到image中
　　ADD和COPY的源必须在context路径下
　　当src为网络URL的情况下，ADD指令可以把它下载到dest的指定位置，这个在任何build的方式下都可以work
　　ADD相对COPY还有一个多的功能，能够进行自动解压压缩包
ENV：
　　ENV key value
　　用来设置环境变量，后续的RUN可以使用它所创建的环境变量
　　当创建基于该镜像的container的时候，会自动拥有设置的环境变量 
WORKDIR：
　　用来指定当前工作目录（或者称为当前目录）
　　当使用相对目录的情况下，采用上一个WORKDIR指定的目录作为基准 
USER：
　　指定UID或者username，来决定运行RUN指令的用户 
ONBUILD：
　　ONBUILD作为一个trigger的标记，可以用来trigger任何Dockerfile中的指令
　　可以定义多个ONBUILD指令
　　当下一个镜像B使用镜像A作为base的时候，在FROM A指令前，会先按照顺序执行在构建A时候定义的ONBUILD指令
　　ONBUILD <DOCKERFILE 指令> <content>
VOLUME：
　　用来创建一个在image之外的mount point，用来在多个container之间实现数据共享
　　运行使用json array的方式定义多个volume
　　VOLUME ["/var/data1","/var/data2"]
　　或者plain text的情况下定义多个VOLUME指令
```