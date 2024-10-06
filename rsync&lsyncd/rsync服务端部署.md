---
tags:
  - rsync
---
# Rsync服务端部署

## 第一步：安装

```shell
yum install rsync -y
```

## 第二步：编写配置文件

```shell
cat > /etc/rsyncd.conf << 'EOF'

uid = www

gid = www

port = 873

fake super = yes

use chroot = no

max connections = 200

timeout = 600

ignore errors

read only = false

list = false

auth users = rsync_backup

secrets file = /etc/rsync.passwd

log file = /var/log/rsyncd.log



[backup]

path = /backup



[data]

path = /data

EOF
```

## 第三步：创建用户

```shell
groupadd -g 1000 www

useradd -u 1000 -g 1000 -M -s /sbin/nologin www
```

## 第四步：创建目录并更改所属用户和用户组

```shell
mkdir /{data,backup} -p

chown -R www:www /data

chown -R www:www /backup
```

## 第五步：创建密码文件

```shell
echo "rsync_backup:abc" >> /etc/rsync.passwd
```

## 第六步：修改密码文件权限

```shell
chmod 600 /etc/rsync.passwd
```

## 第七步：启动服务 

```shell
systemctl start rsyncd
```

## 第八步：检查

```shell
systemctl status rsyncd
```
