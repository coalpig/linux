

## 1.Docker资源限制说明

```
https://docs.docker.com/config/containers/resource_constraints/
```

## 2.容器的内存限制

Docker限制内存相关参数:

```
-m  允许容器使用的最大内存，单位有k,m,g
--oom-kill-disable	
```

下载压测工具镜像：

```
docker pull lorel/docker-stress-ng
```

压测工具参数说明：

```
#查看帮助说明
docker run --name mem_test -it --rm lorel/docker-stress-ng

#常用参数
 -m N, --vm N            启动N个workers，默认一个256M内存
```

创建一个没有内存限制的容器：

```
#启动一个前台窗口任务
docker run --name mem_test -it lorel/docker-stress-ng --vm 2

#另开一个窗口查看
CONTAINER ID   NAME      CPU %     MEM USAGE / LIMIT     MEM %     NET I/O      BLOCK I/O   PIDS
49493229356b   c1        99.46%    514.2MiB / 1.934GiB   25.96%    1.1kB / 0B   0B / 0B     5
```

创建一个限制了内存大小的容器

```
#启动一个前台窗口任务
docker run --name mem_test --rm -m 300m -it lorel/docker-stress-ng --vm 2

#新开窗口查看
CONTAINER ID   NAME       CPU %     MEM USAGE / LIMIT   MEM %     NET I/O     BLOCK I/O   PIDS
7d1a3b482a3a   mem_test   98.75%    294.9MiB / 300MiB   98.30%    656B / 0B   0B / 0B     5
```

## 3.容器的CPU限制

官方文档：

```
https://docs.docker.com/config/containers/resource_constraints/
```

Docker限制CPU相关参数：

```
--cpus=<value>
```

查看宿主机CPU核数:

```
[root@docker-11 ~]# lscpu 
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                4
```

压测工具命令：

```
#不限制容器的CPU使用，压测工具开启4个CPU
docker run --name cpu_test -it --rm lorel/docker-stress-ng --cpu 4

#新开窗口查看CPU占用情况
CONTAINER ID   NAME       CPU %     MEM USAGE / LIMIT     MEM %     NET I/O      BLOCK I/O     PIDS
8701e7f14f6f   cpu_test   402.31%   9.973MiB / 1.934GiB   0.50%     1.1kB / 0B   1.58MB / 0B   5

#限制容器只能使用1.5个CPU
docker run --cpus 1.5 --name cpu_test -it --rm lorel/docker-stress-ng --cpu 4 

#查看容器运行状态
CONTAINER ID   NAME       CPU %     MEM USAGE / LIMIT    MEM %     NET I/O     BLOCK I/O   PIDS
ae710912bb3e   cpu_test   149.31%   14.9MiB / 1.934GiB   0.75%     656B / 0B   0B / 0B     5
```
