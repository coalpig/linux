

## 1.vip故障转移脚本

```
上传脚本文件到/usr/local/bin 
\cp -a * /usr/local/bin
```

## 2.修改权限

```
chmod +x /usr/local/bin/*
```

## 3.替换字符

```
dos2unix /usr/local/bin/*
```

## 4.修改内容

```
vim  /usr/local/bin/master_ip_failover
my $vip = '10.0.0.55/24';
my $key = '1';
my $ssh_start_vip = "/sbin/ifconfig eth0:$key $vip";
my $ssh_stop_vip = "/sbin/ifconfig eth0:$key down";
my $ssh_Bcast_arp= "/sbin/arping -I eth0 -c 3 -A 10.0.0.55";
```

## 5.修改配置文件

```
vim /etc/mha/app1.cnf 
master_ip_failover_script=/usr/local/bin/master_ip_failover
```

## 6.重启mha

```
masterha_stop --conf=/etc/mha/app1.cnf
nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover  < /dev/null> /var/log/mha/app1/manager.log 2>&1 &
```

## 7.手工在主库添加VIP

```
ifconfig eth0:1 10.0.0.55/24
```

