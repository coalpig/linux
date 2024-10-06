---
tags:
  - 知识点
---
安装Zabbix Proxy


概念

代理zabbix监控项的请求

多长时间
保持默认，可能是60秒

>[!proxy server配置]
>也就是代理主机配置

- 安装zabbix-proxy

```shell
rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm

sed -i 's#repo.zabbix.com#mirrors.tuna.tsinghua.edu.cn/zabbix#g' /etc/yum.repos.d/zabbix.repo

yum install zabbix-proxy-mysql mariadb-server
```

- 创建数据库以及账号

```shell
systemctl start mariadb.service 
mysqladmin password 123
mysql -uroot -p123

create database zabbix_proxy character set utf8 collate utf8_bin;
grant all privileges on zabbix_proxy.* to zabbix_proxy@localhost identified by 'zabbix_proxy';
flush privileges;
```

- 导入Zabbix_proxy数据至数据库中

```shell
zcat /usr/share/doc/zabbix-proxy-mysql-*/schema.sql.gz|mysql -uzabbix_proxy -pzabbix_proxy zabbix_proxy
```

- 配置zabbix-proxy


```shell
cat >/etc/zabbix/zabbix_proxy.conf<<EOF
ProxyMode=0
Server=10.0.0.61 #zabbix server的ip！
ServerPort=10051 #默认server端口
Hostname=proxy-61 #在server图形化页面显示的主机名
LogFile=/var/log/zabbix/zabbix_proxy.log
LogFileSize=0
PidFile=/var/run/zabbix/zabbix_proxy.pid
SocketDir=/var/run/zabbix
DBHost=localhost
DBName=zabbix_proxy
DBUser=zabbix_proxy
DBPassword=zabbix_proxy
ConfigFrequency=10
DataSenderFrequency=5
EOF
```

- 启动zabbix-proxy

```shell
systemctl restart zabbix-proxy.service
```

>[!zabbix客户端修改配置]
>也就是zabbix agent修改


```shell
cat >/etc/zabbix/zabbix_agentd.conf <<EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=10.0.0.6  #zabbix proxy的 ip
ServerActive=10.0.0.6 #zabbix proxy的 ip
Hostname=web-7
Include=/etc/zabbix/zabbix_agentd.d/*.conf
HostMetadata=web
EOF

systemctl restart zabbix-agent
```


