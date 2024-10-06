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
