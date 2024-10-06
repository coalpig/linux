# 第1章 jumpserver介绍

## 1.什么是堡垒机/跳板机

堡垒机就是统⼀一设备运维⼊入⼝口，⽀支持管理理Linux、Windows、Unix、MacOS等设备资源，实现对服务器器资源操作管理理的集中认证，集中控制，集中审计。提升运维管理理⽔水平。

## 2.为什么要用堡垒机/跳板机

现在互联⽹网企业，往往都拥有⼤大量量服务器器，如何安全并⾼高效的管理理这些服务器器是每个系统运维或安全运维⼈人员必要⼯工作。
现在⽐比较常⻅见的⽅方案是搭建堡垒机环境作为线上服务器器的⼊入⼝口，所有服务器器只能通过堡垒机进⾏行行登陆访问。 
说句句⼤大⽩白话: 就是监控运维⼈人员、开发⼈人员对服务器器的命令操作。出了了事故能找到具体责任⼈人。

## 3.跳板机的特性

1.精细化的资源与功能授权，让运维⼈人员各司其职。 
2.体系化的指令审计规则，让运维操作安全可控。 
3.⽀支持多重身份认证，让⾮非法访问⽆无所遁形。 
4.主机账号统⼀一管理理，SSH密钥对⼀一键批量量下发。

# 第2章 jumpserver安装

## 1.方法1 docker安装

```bash
docker pull docker.io/jumpserver/jms_all
docker run --name Jumpserver -d -p 80:80 -p 2222:2222 docker.io/jumpserver/jms_all:latest
```

进入容器修改配置

```bash
docker exec -it Jumpserver /bin/bash
docker restart Jumpserver
```

## 2.方法2 官网脚本安装

```bash
curl -sSL https://github.com/jumpserver/jumpserver/releases/download/v2.5.3/quick_start.sh | sh
```

# 第3章 jumpserver应用

## 1.启动访问

```bash
JumpServer 部署完成
请到 /opt/setuptools 目录执行 ./jmsctl.sh start 启动 

[root@node1 ~]# cd /opt/setuptools/
[root@node1 setuptools]# ls
config.conf  config_example.conf  jmsctl.sh  LICENSE  README.md  scripts  v2.5.3
[root@node1 setuptools]# ./jmsctl.sh start
       __                     _____
      / /_  ______ ___  ____ / ___/___  ______   _____  _____
 __  / / / / / __ `__ \/ __ \\__ \/ _ \/ ___/ | / / _ \/ ___/
/ /_/ / /_/ / / / / / / /_/ /__/ /  __/ /   | |/ /  __/ /
\____/\__,_/_/ /_/ /_/ .___/____/\___/_/    |___/\___/_/
                    /_/

                                         Version:  v2.5.3  

MySQL   start   ........................ [ OK ]
Redis   Start   ........................ [ OK ]
Docke.  Start   ........................ [ OK ]
Core    Start   ........................ [ OK ]
Koko    Start   ........................ [ OK ]
Guaca.  Start   ........................ [ OK ]
Nginx   Start   ........................ [ OK ]

MySQL   Check   ........................ [ OK ]
Redis   Check   ........................ [ OK ]
Docke.  Check   ........................ [ OK ]
Nginx   Check   ........................ [ OK ]
Py3     Check   ........................ [ OK ]
Core    Check   ........................ [ OK ]
Koko    Check   ........................ [ OK ]
Guaca.  Check   ........................ [ OK ]

JumpServer 启动成功! 
Web 登陆信息: http://10.0.0.11:80
SSH 登录信息: ssh admin@10.0.0.11 -p2222
初始用户名密码: admin admin 

[如果你是云服务器请在安全组放行 80 和 2222 端口] 

[root@node1 setuptools]#
```



![img](./attachments/image-20201214063558704.png)

## 2.配置邮箱

![img](./attachments/1717388854939-7c80e628-9529-4832-b645-e73c2ca2c112.png)

## 3.创建用户组

![img](./attachments/image-20201214064307230.png)

![img](./attachments/image-20201214064407965.png)

## 4.创建用户

![img](./attachments/1716348848069-30614794-08c0-4f36-93b8-e80891dbdcc2.png)

![img](./attachments/image-20201214064834313.png)

密码会通过邮件发送到邮箱里

![img](./attachments/1716348872192-4f1a12c6-810d-4296-8b11-48ac94a19cd4.png)



![img](./attachments/image-20201214065032347.png)



![img](./attachments/1716348892330-0f61d0cc-82e4-4a3d-a7e0-feaadd53a84d.png)

## 4.资产管理

![img](./attachments/image-20201214065312320.png)



![img](./attachments/image-20201214065606775.png)

## 5.用户管理

```bash
注意:
1.创建管理理⽤用户使⽤用root⽤用户名 
2.创建系统⽤用户:运维组,开发组,总监组各创建⼀一个 
3.只有运维组的系统⽤用户的sudo权限是/bin/su,其他组的系统⽤用户使⽤用默认
```

### 创建管理用户

![img](./attachments/image-20201214065804859.png)

### 创建系统用户

![img](./attachments/image-20201214070536523.png)

![img](./attachments/image-20201214070658219.png)

## 6.资产管理

### 创建资产

![img](./attachments/image-20201214070859926.png)

![img](./attachments/image-20201214070953453.png)

## 7.权限管理

### 创建授权规则

![img](./attachments/image-20201214071120183.png)

## 8.配置终端登陆

![img](./attachments/image-20201214071444974.png)

![img](./attachments/image-20201214073230127.png)

![img](./attachments/image-20201214073247737.png)

![img](./attachments/image-20201214073205114.png)

## 9.会话管理

会话管理可以看到当前有哪些正在连接的会话并且可以实时的同步监控会话内容，也可以随时断开会话

![img](./attachments/image-20201214073820332.png)

## 10.命令记录

历史会话⾥里里⾯面记录了了哪个⽤用户在什什么时间⽤用什什么系统⽤用户登录了了哪台主机，执⾏行行了了多少条命令，以及操作的视频都记录了了下来.这样操作⼈人员操作了了什什么，事后都能清清楚楚的知道.也可以说，谁想对系统做破坏，都有证据找到责任⼈人.

![img](./attachments/image-20201214073539412.png)