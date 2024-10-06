step 0: 删除残留的docker
```
yum remove docker docker-common docker-selinux docker-engine
```

step 1: 安装必要的一些系统工具
```
yum install -y yum-utils device-mapper-persistent-data lvm2
```

Step 2: 添加软件源信息
```
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

Step 3替换成aliyun的源
```
sed -i 's+download.docker.com+mirrors.ustc.edu.cn/docker-ce+' /etc/yum.repos.d/docker-ce.repo
```


如果aliyun下载慢可以替换为中国科技大学的源(已经被关闭了)

```
vim /etc/yum.repos.d/docker-ce.repo
:%s#aliyun.com#ustc.edu.cn#g
```




Step 4: 更新并安装Docker-CE
```
yum clean all
yum makecache fast
yum -y install docker-ce
```

Step 5: 开启Docker服务
```
service docker start
```

注意：
官方软件源默认启用了最新的软件，您可以通过编辑软件源的方式获取各个版本的软件包。例如官方并没有将测试版本的软件源置为可用，您可以通过以下方式开启。同理可以开启各种测试版本等。
```
vim /etc/yum.repos.d/docker-ce.repo
将[docker-ce-test]下方的enabled=0修改为enabled=1
```


> 安装指定版本的Docker-CE:

Step 1: 查找Docker-CE的所有版本:

```
yum list docker-ce.x86_64 --showduplicates | sort -r
```

Step2: 安装指定版本的Docker-CE: (VERSION例如上面的17.03.0.ce.1-1.el7.centos)

```
sudo yum -y install docker-ce-[VERSION]
```



使用kubernetes官网的kubeadm安装k8s的话
k8s所有组件运行在docker容器里面
所以要安装Docker


注意!以下操作所有主机都执行

1）配置yum源

```
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
sed -i 's+download.docker.com+mirrors.aliyun.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo
yum makecache fast
```
如果阿里源慢可以配置成中国科技大学源

```
vim /etc/yum.repos.d/docker-ce.repo
:%s#aliyun.com#ustc.edu.cn#g
```
2）安装指定版本Docker

```
yum -y install docker-ce-20.10.15 docker-ce-cli-20.10.15
```

3）配置镜像加速

```
mkdir /etc/docker -p
cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": [
    "https://docker.m.daocloud.io",
    "https://dockerproxy.com",
    "https://docker.mirrors.ustc.edu.cn",
    "https://docker.nju.edu.cn",
    "https://docker.rainbond.cc",
    "https://hub.uuuadc.top",
    "https://docker.anyhub.us.kg",
    "https://dockerhub.jobcher.com",
    "https://docker.ckyl.me",
    "https://docker.awsl9527.cn"]
}
EOF
#吴楠推荐
cat > /etc/docker/daemon.json << 'EOF'
{
  "registry-mirrors": ["https://docker.rainbond.cc"]
}
EOF
```

4）设置开机自启动

```
systemctl enable docker && systemctl start docker
```
