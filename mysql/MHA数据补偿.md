

## 1.创建必要目录(db-53)

```
mkdir -p /data/binlog_server/
chown -R mysql.mysql /data/*
cd  /data/binlog_server/
```

## 2.拉取最新日志

注意：拉取日志的起点,需要按照目前从库的已经获取到的二进制日志点为起点

```
mysql -e "show slave status \G"|grep "Master_Log"
mysqlbinlog  -R --host=10.0.0.51 --user=mha --password=mha --raw  --stop-never mysql-bin.000003 &
ll /data/binlog_server
```

## 3.MHA配置文件设置

```
vim /etc/mha/app1.cnf 
[binlog1]
no_master=1
hostname=10.0.0.53
master_binlog_dir=/data/binlog_server/
```

## 4.重启MHA

```
masterha_stop  --conf=/etc/mha/app1.cnf 
nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover  < /dev/null> /var/log/mha/app1/manager.log 2>&1 &
```

