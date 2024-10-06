# SSH 动态端口转发（SOCKS代理）

## 1.转发命令

ssh -D 本地端口 -C -N 用户名@海外服务器地址

参数解释：

**-D 本地端口**: 指定本地监听端口，例如**1080**，这将用作SOCKS代理端口。

**-C**: 启用压缩。

**-N**: 不执行远程命令，只进行端口转发。

**用户名@海外服务器地址**: 你的海外Linux服务器的用户名和地址。

# Squid代理服务器

## 1.在海外Linux服务器上安装Squid

apt-get update

apt-get install squid

## 2.创建密码文件：

apt-get install apache2-utils # Debian/Ubuntu上安装apache2-utils

htpasswd -c /etc/squid/passwd 用户名

## 3.修改配置文件

vim /etc/squid/squid.conf

auth_param basic program /usr/lib/squid3/basic_ncsa_auth /etc/squid/passwd

auth_param basic realm Proxy

acl authenticated proxy_auth REQUIRED

http_access allow authenticated

## 4.重启Squid服务

systemctl restart squid

# Linux配置代理

## 1.启动代理

export HTTP_PROXY="http://海外服务器地址:1080"

export HTTPS_PROXY="http://海外服务器地址:1080"

## 2.取消代理

unset HTTP_PROXY

unset HTTPS_PROXY