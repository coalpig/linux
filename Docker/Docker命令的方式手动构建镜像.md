有时候官方的镜像软件没有达到需求，所以可以基于官方的镜像制作属于自己的镜像，这个时候就可以手动构建镜像
安装配置需求过程
- 构建镜像的思路是先pull拉取镜像，然后进入容器的终端
- 安装配置需要的软件
- 提交容器为新的镜像，容器停止了也可以提交
- 测试镜像是否可以使用
- 也可以选择是否将镜像导出

相关命令

```
docker run -it -d centos
docker exec -it 容器ID /bin/bash
docker commit 容器ID centos:v1
docker save -o centos_v1.tar centos
```

