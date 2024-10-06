# 第9章 MHA修复方案

### 1.确定三个数据库节点都在线

```
#db-51启动数据库
systemctl start mysqld
```

## 2.db-51修复主从复制关系

```
change master to 
master_host='10.0.0.52',
master_user='repl',
master_password='123' ,
MASTER_AUTO_POSITION=1;
start slave;
show slave status\G
```

## 3.判断VIP是否存在

```
#db-52确认是否存在VIP
ip a|grep 10.0.0.55
```

## 4.检查binlogserver并修复

```
ps -ef|grep mysqlbinlog
rm -rf /data/binlog_server/*
cd  /data/binlog_server/
mysql -e "show slave status \G"|grep "Master_Log"
mysqlbinlog  -R --host=10.0.0.51 --user=mha --password=mha --raw  --stop-never mysql-bin.000003 &
```

## 5.检查配置文件确认三个节点是否存在

```
#添加新节点到配置文件
masterha_conf_host --command=add --conf=/etc/mha/app1.cnf --hostname=10.0.0.51 --block=server1 --params="port=3306"
---------------------删除命令------------------
masterha_conf_host --command=delete --conf=/etc/mha/app1.cnf --block=server1
```

## 6.检查ssh互信和repl

```
masterha_check_ssh  --conf=/etc/mha/app1.cnf
masterha_check_repl  --conf=/etc/mha/app1.cnf
```

## 7.启动MHA

```
nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover  < /dev/null> /var/log/mha/app1/manager.log 2>&1 &
```

## 8.检查MHA

```
masterha_check_status   --conf=/etc/mha/app1.cnf 
```

