
创建容器
```
docker run -it centos:latest /bin/bash
```

安装sshd
```
yum search ssh
如果搜不到直接配置阿里云centos8
yum -y install openssh-server -y
```


启动sshd服务：

```
/usr/sbin/sshd -D

```

发现报错

```
1. Could not load host key: /etc/ssh/ssh_host_rsa_key
    
2. Could not load host key: /etc/ssh/ssh_host_ecdsa_key
    
3. Could not load host key: /etc/ssh/ssh_host_ed25519_key
```

依次执行下列命令：   

-t 是生成密钥的类型
-f生成路径
-N 密钥密码为空
```
 ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ""
    
ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ""
    
ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
```

编辑sshd_config配置文件

```cobol
vim /etc/ssh/sshd_config
找到UsePAM yes这一段配置，将其改成UsePAM no
```


修改root的密码，如果不能passwd

```
yum -y install passwd
```


改完密码执行exit命令退出，这时会回到宿主机器的shell，

执行下列命令将容器提交到镜像，也就是生成镜像
生成后可以使用docker images查看

```
docker commit containerid cent #cent是镜像名
docker images
```



通过docker run启动一个新的容器，参数-d表示后台运行，-p表示docker到主机的端口的映射

```
docker run -d -p 10022:22 cent /usr/sbin/sshd -D
```



也可以不生成镜像，镜像的终端运行以下命令，新开一个宿主机终端这样就可以连接ssh了

```
/usr/sbin/sshd -D
```
