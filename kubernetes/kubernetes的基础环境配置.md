1）配置host解析

```
cat > /etc/hosts << EOF
10.0.0.11   master-01
10.0.0.21   node-01
10.0.0.22   node-02
EOF
```

2）关闭防火墙

```
systemctl  stop  firewalld   NetworkManager 
systemctl  disable  firewalld   NetworkManager
```

3）关闭SELinux

```
setenforce 0
sed -i 's#SELINUX=disabled#SELINUX=disabled#g' /etc/selinux/config
getenforce
```

4）更新阿里源

使用阿里源，可能比较慢
```
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo
sed -i '/aliyuncs/d' /etc/yum.repos.d/*
yum makecache fast
```

配置中国科技大学base和阿里云epel
```
cat > /etc/yum.repos.d/CentOS-Base.repo <<'EOF'
# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the
# remarked out baseurl= line instead.
#
#

[base]
name=CentOS-$releasever - Base
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra
baseurl=https://mirrors.ustc.edu.cn/centos-vault/centos/$releasever/os/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#released updates
[updates]
name=CentOS-$releasever - Updates
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates&infra=$infra
baseurl=https://mirrors.ustc.edu.cn/centos-vault/centos/$releasever/updates/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras&infra=$infra
baseurl=https://mirrors.ustc.edu.cn/centos-vault/centos/$releasever/extras/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus&infra=$infra
baseurl=https://mirrors.ustc.edu.cn/centos-vault/centos/$releasever/centosplus/$basearch/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
EOF
wget -O /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo
yum makecache fast
```
5）确保网络通畅

```
ping -c 1 www.baidu.com
ping -c 1 master-01
ping -c 1 node-01
ping -c 1 node-02
```

6）配置时间同步

```
yum install chrony -y
systemctl start chronyd
systemctl enable chronyd
date
```

7）关闭SWAP分区

```
swapoff -a
sed -i '/swap/d' /etc/fstab
free -h
```

8）升级系统内核

```
# 阿里云下载网址：
https://mirrors.aliyun.com/elrepo/archive/kernel/el7/x86_64/RPMS/
# 下载以下2个包，在浏览器下载比较快
kernel-lt-5.4.278-1.el7.elrepo.x86_64.rpm
kernel-lt-devel-5.4.278-1.el7.elrepo.x86_64.rpm

# rpm安装
rpm -ivh kernel-lt-5.4.278-1.el7.elrepo.x86_64.rpm
rpm -ivh kernel-lt-devel-5.4.278-1.el7.elrepo.x86_64.rpm

# 确认已安装内核版本
rpm -qa | grep kernel

# 设置默认引导启动哪个内核
grub2-mkconfig -o /boot/grub2/grub.cfg
awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg
grub2-set-default 0

# 重启并检查
reboot
uname -r
```


