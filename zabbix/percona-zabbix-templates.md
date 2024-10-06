安装percona-zabbix-templates

php环境配置
```
yum install php php-mysql -y
```

安装
```shell
rpm -ivh percona
```

分析目录

- 进入安装目录会发现有2个目录，一个是脚本目录，一个是模版目录
- 
- 其中脚本目录里有2个脚本，用来获取数据库信息
- 
- 可以tree 查看一下安装的目录  
- 
- 修改get_mysql_stats_wrapper.sh数据库登陆信息第19行添加mysql账号密码  
-  
- 修改ss_get_mysql_stats.php 配置的mysql账号密码
- 

复制自定义监控项配置文件到zabbix-agent的配置目录

```
cp userparameter_percona_mysql.conf /etc/zabbix/zabbix_agentd.conf #监控目录
```

重启agent

```
systemctl restart zabbix-agent 
```

测试key，这里是要在客户端测试，也就是zabbix-server的主机测试

```
zabbix_get -s 10.0.0.x -k MySQL.Sort-scan
```


