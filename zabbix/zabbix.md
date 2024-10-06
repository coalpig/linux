---
aliases:
  - 监控
tags:
  - 图形化工具
---

>[!zabbix主动模式和被动模式]-
  zabbix获取数据默认为==被动模式==，100个监控项要100个来回，也就是一个一个的请求，要一个数据项返回一个，过多的消耗资源。如果是==主动模式==，如果有100个监控项1个回合，将所需要的100个打包，然后一次发过去，发过去之后，客户端全部执行完再一次返回给服务端。首先要[[zabbix主动模式]]，并且修改模板，防止旧模板被覆盖

>[!percona-zabbix-templates，批量导入mysql模板]

percona公司的软件在数据库工具出名，mysql数据库的备份XBK(xtrabackup)也是percona公司的，mysql的监控项非常多，如果使用[[percona-zabbix-templates|percona-zabbix-templates]]，就能高效的监控项，首先服务端安装[[percona-zabbix-templates]]，客户端导入[[zbx_percona_mysql_template]]，在服务端安装[[percona-zabbix-templates|percona-zabbix-templates]]的时候，percona官方会自带xml模板，官方自带的模板有问题，可以使用网友修改的[[zbx_percona_mysql_template|zbx_percona_mysql_template]]模板


>[!自动发现]

[[自动发现]]是zabbix的server通过划定的ip段主动扫描发现装有zabbix agent的机器

>[!自动注册]

[[自动注册]]

> [!Zabbix Proxy]


[[Zabbix Proxy]]可以代表Zabbix server收集性能和可用性数据。 通过这种方式，proxy可以自己承担一些收集数据的负载，并==减轻Zabbix Serve==r的负担。

此外，当所有agents和proxy都向一个Zabbix server报告并且所有数据都集中收集时，使用Proxy代理是实现集中式和分布式监控的最简单方法。

[[Zabbix Proxy|Zabbix proxy]] 可以被使用作为:

- 监控远程位置
- 监控通信不可靠的位置
- 在监视数千个设备时卸载Zabbix服务器
- 简化分布式监控的维护


![[attachments/Pasted image 20240806094537.png]]





```
1. name:
    
    Admin
    
2. password:
    
    zabbix
    
3. autologin:
    
    1
    
4. enter:
    
    Sign in
```

zabbix
做过哪些优化
调参数需要分析
通过这个图来调整
如果发现百分比过大
举个例子，范围太大，间隔时间太短
修改自动发现的进程数，降低zabbix压力


tps实际处理速度

qps请求次数