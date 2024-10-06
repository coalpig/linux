

## 1.准备脚本

```
vim /usr/local/bin/send_report
my $smtp='smtp.qq.com';
my $mail_from='526195417@qq.com';
my $mail_user='526195417';
my $mail_pass='njwygmkbvzlubiji';
my $mail_to='526195417@qq.com';
```

## 2.修改配置文件

```
vim /etc/mha/app1.cnf 
report_script=/usr/local/bin/send_report
```

## 3.重启MHA

```
masterha_stop --conf=/etc/mha/app1.cnf
nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover  < /dev/null> /var/log/mha/app1/manager.log 2>&1 &
```

