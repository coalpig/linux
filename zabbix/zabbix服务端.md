1.思考监控项是否都是必要的
- 减少监控项可以减少压力

2.监控项的间隔调大一点
- 在一段时间采集的监控项就少一点

3.分布式架构减轻MySQL压力
- zabbix-proxy

4.MySQL主从复制+读写分离


5.被动模式改为主动模式
[zabbix主动模式](zabbix主动模式.md)

6.调整zabbix-server配置参数
- 在[自动发现](自动发现.md)的时候,会有很高的占用率
![](attachments/Pasted%20image%2020240807105654.png)

- vim /etc/zabbix/zabbix_server.conf 

![](attachments/Pasted%20image%2020240807105935.png)
- 然后重启zabbix-server
![](attachments/Pasted%20image%2020240807110203.png)
- 内存调优
![](attachments/Pasted%20image%2020240807110536.png)
- 图形化操作

![](attachments/Pasted%20image%2020240807110851.png)

