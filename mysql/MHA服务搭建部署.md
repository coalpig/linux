

## 1.创建软连接

```
ln -s /opt/mysql/bin/mysqlbinlog /usr/bin/mysqlbinlog
ln -s /opt/mysql/bin/mysql /usr/bin/mysql
rm -rf /root/.ssh/
```

## 2.节点互信-所有机器都操作

```
yum install sshpass -y
ssh-keygen -f /root/.ssh/id_rsa -N ''
sshpass -p '123' ssh-copy-id 10.0.0.51 -o StrictHostKeyChecking=no
sshpass -p '123' ssh-copy-id 10.0.0.52 -o StrictHostKeyChecking=no
sshpass -p '123' ssh-copy-id 10.0.0.53 -o StrictHostKeyChecking=no
```

## 3.各节点验证-所有机器都操作

```
ssh 10.0.0.51 hostname
ssh 10.0.0.52 hostname
ssh 10.0.0.53 hostname
```

## 4.所有节点安装node软件

```
yum install perl-DBD-MySQL -y
rpm -ivh mha4mysql-node-0.58-0.el7.centos.noarch.rpm
```

## 5.db-53安装Manager软件

```
yum install -y perl-Config-Tiny epel-release perl-Log-Dispatch perl-Parallel-ForkManager perl-Time-HiRes
yum install -y mha4mysql-manager-0.58-0.el7.centos.noarch.rpm
```

## 6.在db-51主库中创建mha需要的用户

```
grant all privileges on *.* to mha@'10.0.0.%' identified by 'mha';
select user,host from mysql.user;
```

## 7.Manager配置文件准备(db-53)

```
#创建配置文件目录
mkdir -p /etc/mha

#创建日志目录
mkdir -p /var/log/mha/app1

#编辑mha配置文件
cat > /etc/mha/app1.cnf <<EOF
[server default]
manager_log=/var/log/mha/app1/manager
manager_workdir=/var/log/mha/app1
master_binlog_dir=/data/binlogs/
user=mha            
password=mha
ping_interval=2
repl_password=123
repl_user=repl
ssh_user=root
[server1]
hostname=10.0.0.51
port=3306                                  
[server2]            
hostname=10.0.0.52
port=3306
[server3]
hostname=10.0.0.53
port=3306
EOF

#配置文件解释
[server default]
manager_log=/var/log/mha/app1/manager         # MHA的工作日志设置
manager_workdir=/var/log/mha/app1             # MHA工作目录        
master_binlog_dir=/data/binlog                # 主库的binlog目录
user=mha                                      # 监控用户                      
password=mha                                  # 监控密码
ping_interval=2                               # 心跳检测的间隔时间
repl_password=123                             # 复制用户
repl_user=repl                                # 复制密码
ssh_user=root                                 # ssh互信的用户
[server1]                                     # 节点信息....
```

## 8.状态检查（db-53）

```
masterha_check_ssh   --conf=/etc/mha/app1.cnf
masterha_check_repl  --conf=/etc/mha/app1.cnf
```


![](attachments/Pasted%20image%2020240824204047.png)

![](attachments/Pasted%20image%2020240824204102.png)

## 9.开启MHA-manager（db-53）

```
nohup masterha_manager --conf=/etc/mha/app1.cnf --remove_dead_master_conf --ignore_last_failover  < /dev/null> /var/log/mha/app1/manager.log 2>&1 &
```

## 10.查看MHA状态

```
[root@db-53 ~]# masterha_check_status --conf=/etc/mha/app1.cnf
app1 (pid:12009) is running(0:PING_OK), master:10.0.0.51
```

