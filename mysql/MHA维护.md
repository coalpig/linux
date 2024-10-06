# 第10章 MHA维护

## 1.master_ip_online_change_script功能

在线切换时，自动锁原主库，VIP自动切换

## 2.准备切换脚本

```
vim /usr/local/bin/master_ip_online_change

my $vip = "10.0.0.55/24";
my $key = "1";
my $ssh_start_vip = "/sbin/ifconfig eth0:$key $vip";
my $ssh_stop_vip = "/sbin/ifconfig eth0:$key $vip down";
my $ssh_Bcast_arp= "/sbin/arping -I eth0 -c 3 -A 10.0.0.55";
```

## 3.修改MHA配置文件

```
vim /etc/mha/app1.cnf
master_ip_online_change_script=/usr/local/bin/master_ip_online_change
```

## 4.停 MHA

```
masterha_stop  --conf=/etc/mha/app1.cnf 
```

## 5.检查repl

```
masterha_check_repl   --conf=/etc/mha/app1.cnf 
```

## 6.在线切换

```
masterha_master_switch  --conf=/etc/mha/app1.cnf --master_state=alive --new_master_host=10.0.0.51 --orig_master_is_new_slave --running_updates_limit=10000
```

## 7.重构binlogserver

```
[root@db-53 ~]# ps -ef |grep [m]ysqlbinlog
root      33698  23489  0 21:18 pts/0    00:00:00 mysqlbinlog -R --host=10.0.0.52 --user=mha --password=x x --raw --stop-never mysql-bin.000003
[root@db-53 ~]# kill 33698
[root@db-53 ~]# cd /data/binlog_server/
[root@db-53 binlog_server]# rm -rf *
[root@db-53 binlog_server]# mysqlbinlog  -R --host=10.0.0.51 --user=mha --password=mha --raw  --stop-never mysql-bin.000003 &
[1] 36893
```

## 8.启动MHA

```
[root@db-53 ~]# nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover  < /dev/null> /var/log/mha/app1/manager.log 2>&1 &
[2] 36915

[root@db-53 ~]# masterha_check_status   --conf=/etc/mha/app1.cnf 
app1 (pid:36915) is running(0:PING_OK), master:10.0.0.51
```