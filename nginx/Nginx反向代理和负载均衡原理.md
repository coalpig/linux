---
tags:
  - Nginx/反向代理
  - nginx/负载均衡
---
>Nginx反向代理

![](attachments/Pasted%20image%2020240824222707.png)

![](attachments/Pasted%20image%2020240824222727.png)

![](attachments/Pasted%20image%2020240824222739.png)

![](attachments/Pasted%20image%2020240824222750.png)










- ~ 什么是反向代理和负载均衡

后端有多个服务器，通过反向代理将用户流量均衡的分摊，实现负载均衡的效果

- ~ 实现反向代理和负载均衡的软件

HAproxy：只做反向代理

Nginx：既可以做web服务器，也可以做反向代理服务器，反向代理和负载均衡都是Nginx的模块
