---
tags:
  - ssh
---

- ~ Linux连接方式


>SSH连接

Telnet连接-不安全

本地显示器键盘支直连

为什么使用SSH？

>SSH服务: 

linux默认 安全性好 传输加密 默认端口号22



> TELNET服务：

网络设备上默认的是telnet 安全性较差 传输明文 默认不允许用root登录 默认端口号23 


- ~ 抓包演示


>抓包工具

Wireshark

tcpdump

> 安装telnet服务

```shell
yum install -y telnet-server

systemctl start telnet.socket

systemctl status telnet.socket 

netstat -lntup|grep 23

```