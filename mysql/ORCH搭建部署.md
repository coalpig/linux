

## 1.建立ssh互信

1）每个节点上执行以下命令生成ssh密钥

```
ssh-keygen -f /root/.ssh/id_rsa -N ''
```

2）免交互分发公钥

```
yum install sshpass -y
sshpass -p "123" ssh-copy-id 10.0.0.51 -o StrictHostKeyChecking=no
sshpass -p "123" ssh-copy-id 10.0.0.52 -o StrictHostKeyChecking=no
sshpass -p "123" ssh-copy-id 10.0.0.53 -o StrictHostKeyChecking=no
```

3）验证

```
ssh 10.0.0.51 'hostname'
ssh 10.0.0.52 'hostname'
ssh 10.0.0.53 'hostname'
```

## 2.部署ORCH后端MySQL多实例环境--注意！所有ORCH机器都操作！

```
#1.创建配置文件
cat > /etc/my_3307.cnf << 'EOF'
[mysqld]
port=3307
user=mysql
basedir=/opt/mysql
datadir=/data/mysql_3307
socket=/tmp/mysql_3307.sock

[mysql]
socket=/tmp/mysql_3307.sock

[client]
socket=/tmp/mysql_3307.sock
EOF

#2.创建数据目录
mkdir /data/mysql_3307 -p
chown -R mysql:mysql /data/mysql_3307/

#3.MySQL数据初始化
mysqld --initialize-insecure --user=mysql --basedir=/opt/mysql --datadir=/data/mysql_3307/

#4.写入启动脚本
cat >/etc/systemd/system/mysqld_3307.service <<EOF
[Unit]
Description=MySQL Server
Documentation=man:mysqld(8)
Documentation=http://dev.mysql.com/doc/refman/en/using-systemd.html
After=network.target
After=syslog.target
[Install]
WantedBy=multi-user.target
[Service]
User=mysql
Group=mysql
ExecStart=/opt/mysql/bin/mysqld_safe --defaults-file=/etc/my_3307.cnf
LimitNOFILE = 5000
EOF

#5.启动MySQL
systemctl daemon-reload 
systemctl start mysqld_3307.service
systemctl status mysqld_3307.service
mysqladmin -S /tmp/mysql_3307.sock password 123
mysql -uroot -p123 -S /tmp/mysql_3307.sock 
```

## 3.部署Orchestrator

1）被管理的业务数据库的主库上创建账号--注意！只在51操作！业务数据库3306

```
mysql -uroot -p123
CREATE USER 'orchestrator'@'%' IDENTIFIED BY 'orchestrator';
GRANT SUPER, PROCESS, REPLICATION SLAVE, RELOAD ON *.* TO 'orchestrator'@'%';
GRANT SELECT ON mysql.slave_master_info TO 'orchestrator'@'%';
GRANT SELECT ON meta.* TO 'orchestrator'@'%';
flush privileges;
```

2）创建ORCH数据库和用户--注意！所有ORCH机器都操作！ORCH数据库3307

```
mysql -uroot -p123 -S /tmp/mysql_3307.sock
CREATE DATABASE orchestrator;
GRANT all privileges ON orchestrator.* TO 'orchestrator'@'127.0.0.1' IDENTIFIED BY 'orchestrator'; 
flush privileges;
```

3）安装部署ORCH软件--注意！所有ORCH机器都操作！

第一步：解压并创建日志目录

```
tar -zxf /opt/orchestrator-3.2.6-linux-amd64.tar.gz -C /mnt/
cp -r /mnt/usr/local/orchestrator /usr/local/
mkdir /usr/local/orchestrator/log
```

第二步：创建用户并授权目录--注意！所有ORCH机器都操作！

```
groupadd -g 10008 orchestrator
useradd orchestrator -u 10008 -g 10008 -m -s /bin/bash
chown -R orchestrator:orchestrator /usr/local/orchestrator
```

第三步：写入环境变量并生效--注意！所有ORCH机器都操作！

```
echo 'PATH=$PATH:/usr/local/orchestrator:/usr/local/orchestrator/resources/bin' >> /etc/profile
source /etc/profile
```

第四步：编辑ORCH配置文件--注意！有坑！每个机器配置都不一样！

脚本来自国外网友:

[https://www.percona.com/blog/orchestrator-moving-vips-during-failover/](https://www.percona.com/blog/orchestrator-moving-vips-during-failover/)

[https://github.com/theTibi/orchestrator_vip/tree/master](https://github.com/theTibi/orchestrator_vip/tree/master)

注意：

#"RaftBind":"10.0.0.51" 每个机器改成自己的IP

```
cat > /usr/local/orchestrator/orchestrator.conf.json << 'EOF'
{
  "Debug": true,
  "EnableSyslog": false,
  "ListenAddress": ":3000",
  "MySQLTopologyUser": "orchestrator",
  "MySQLTopologyPassword": "orchestrator",
  "MySQLTopologyCredentialsConfigFile": "",
  "MySQLTopologySSLPrivateKeyFile": "",
  "MySQLTopologySSLCertFile": "",
  "MySQLTopologySSLCAFile": "",
  "MySQLTopologySSLSkipVerify": true,
  "MySQLTopologyUseMutualTLS": false,
  "MySQLOrchestratorHost": "127.0.0.1",
  "MySQLOrchestratorPort": 3307,
  "MySQLOrchestratorDatabase": "orchestrator",
  "MySQLOrchestratorUser": "orchestrator",
  "MySQLOrchestratorPassword": "orchestrator",
  "MySQLOrchestratorCredentialsConfigFile": "",
  "MySQLOrchestratorSSLPrivateKeyFile": "",
  "MySQLOrchestratorSSLCertFile": "",
  "MySQLOrchestratorSSLCAFile": "",
  "MySQLOrchestratorSSLSkipVerify": true,
  "MySQLOrchestratorUseMutualTLS": false,
  "MySQLConnectTimeoutSeconds": 1,
  "DefaultInstancePort": 3307,
  "DiscoverByShowSlaveHosts": true,
  "InstancePollSeconds": 5,
  "DiscoveryIgnoreReplicaHostnameFilters": [
    "a_host_i_want_to_ignore[.]example[.]com",
    ".*[.]ignore_all_hosts_from_this_domain[.]example[.]com",
    "a_host_with_extra_port_i_want_to_ignore[.]example[.]com:3307"
  ],
  "UnseenInstanceForgetHours": 240,
  "SnapshotTopologiesIntervalHours": 0,
  "InstanceBulkOperationsWaitTimeoutSeconds": 10,
  "HostnameResolveMethod": "none",
  "MySQLHostnameResolveMethod": "@@report_host",
  "SkipBinlogServerUnresolveCheck": true,
  "ExpiryHostnameResolvesMinutes": 60,
  "RejectHostnameResolvePattern": "",
  "ReasonableReplicationLagSeconds": 10,
  "ProblemIgnoreHostnameFilters": [],
  "VerifyReplicationFilters": false,
  "ReasonableMaintenanceReplicationLagSeconds": 20,
  "CandidateInstanceExpireMinutes": 60,
  "AuditLogFile": "",
  "AuditToSyslog": false,
  "RemoveTextFromHostnameDisplay": ".mydomain.com:3307",
  "ReadOnly": false,
  "AuthenticationMethod": "",
  "HTTPAuthUser": "admin",
  "HTTPAuthPassword": "Admin#123456",
  "AuthUserHeader": "",
  "PowerAuthUsers": [
    "*"
  ],
  "ClusterNameToAlias": {
    "127.0.0.1": "test suite"
  },
  "ReplicationLagQuery": "",
  "DetectClusterAliasQuery": "select replace(substr(@@hostname, 1, instr(@@hostname, 'mysql')-2), '-', '_')",
  "DetectClusterDomainQuery": "",
  "DetectInstanceAliasQuery": "",
  "DetectPromotionRuleQuery": "",
  "DataCenterPattern": "[.]([^.]+)[.][^.]+[.]mydomain[.]com",
  "PhysicalEnvironmentPattern": "[.]([^.]+[.][^.]+)[.]mydomain[.]com",
  "PromotionIgnoreHostnameFilters": [],
  "DetectSemiSyncEnforcedQuery": "",
  "ServeAgentsHttp": false,
  "AgentsServerPort": ":3001",
  "AgentsUseSSL": false,
  "AgentsUseMutualTLS": false,
  "AgentSSLSkipVerify": false,
  "AgentSSLPrivateKeyFile": "",
  "AgentSSLCertFile": "",
  "AgentSSLCAFile": "",
  "AgentSSLValidOUs": [],
  "UseSSL": false,
  "UseMutualTLS": false,
  "SSLSkipVerify": false,
  "SSLPrivateKeyFile": "",
  "SSLCertFile": "",
  "SSLCAFile": "",
  "SSLValidOUs": [],
  "URLPrefix": "",
  "StatusEndpoint": "/api/status",
  "StatusSimpleHealth": true,
  "StatusOUVerify": false,
  "AgentPollMinutes": 60,
  "UnseenAgentForgetHours": 6,
  "StaleSeedFailMinutes": 60,
  "SeedAcceptableBytesDiff": 8192,
  "PseudoGTIDPattern": "",
  "PseudoGTIDPatternIsFixedSubstring": false,
  "PseudoGTIDMonotonicHint": "asc:",
  "DetectPseudoGTIDQuery": "",
  "BinlogEventsChunkSize": 10000,
  "SkipBinlogEventsContaining": [],
  "ReduceReplicationAnalysisCount": true,
  "FailureDetectionPeriodBlockMinutes": 1,
  "FailMasterPromotionOnLagMinutes": 0,
  "RecoveryPeriodBlockSeconds": 60,
  "RecoveryIgnoreHostnameFilters": [],
  "RecoverMasterClusterFilters": [
    "*"
  ],
  "RecoverIntermediateMasterClusterFilters": [
    "*"
  ],
  "OnFailureDetectionProcesses": [
    "echo 'Detected {failureType} on {failureCluster}. Affected replicas:{countSlaves}' >> /usr/local/orchestrator/log/recovery.log"
  ],
  "PreGracefulTakeoverProcesses": [
    "echo 'Planned takeover about to take place on {failureCluster}. Master will switch to read_only' >> /usr/local/orchestrator/log/recovery.log"
  ],
  "PreFailoverProcesses": [
    "echo 'Will recover from {failureType} on {failureCluster}' >> /usr/local/orchestrator/log/recovery.log"
  ],
  "PostFailoverProcesses": [
    "echo 'Recovered from {failureType} on {failureCluster}. Failed: {failedHost}:{failedPort}; Successor: {successorHost}: {successorPort}; failureClusterAlias:{failureClusterAlias}' >> /usr/local/orchestrator/log/recovery.log",
    "/usr/local/orchestrator/orch_hook.sh {failureType} {failureClusterAlias} {failedHost} {successorHost} >> /usr/local/orchestrator/log/recovery_orch_hook.log"
  ],
  "PostUnsuccessfulFailoverProcesses": [],
  "PostMasterFailoverProcesses": [
    "echo 'Recovered from {failureType} on {failureCluster}. Failed: {failedHost}:{failedPort}; Promoted: {successorHost}:{successorPort}' >> /usr/local/orchestrator/log/recovery.log"
  ],
  "PostIntermediateMasterFailoverProcesses": [
    "echo 'Recovered from {failureType} on {failureCluster}. Failed: {failedHost}:{failedPort}; Successor: {successorHost}:{successorPort}' >> /usr/local/orchestrator/log/recovery.log"
  ],
  "PostGracefulTakeoverProcesses": [
    "echo 'Planned takeover complete' >> /usr/local/orchestrator/log/recovery.log"
  ],
  "CoMasterRecoveryMustPromoteOtherCoMaster": true,
  "DetachLostSlavesAfterMasterFailover": true,
  "ApplyMySQLPromotionAfterMasterFailover": true,
  "PreventCrossDataCenterMasterFailover": false,
  "PreventCrossRegionMasterFailover": false,
  "FailMasterPromotionIfSQLThreadNotUpToDate": false,
  "DelayMasterPromotionIfSQLThreadNotUpToDate": true,
  "DetachLostReplicasAfterMasterFailover": true,
  "MasterFailoverDetachReplicaMasterHost": false,
  "MasterFailoverLostInstancesDowntimeMinutes": 0,
  "PostponeReplicaRecoveryOnLagMinutes": 0,
  "OSCIgnoreHostnameFilters": [],
  "GraphiteAddr": "",
  "GraphitePath": "",
  "GraphiteConvertHostnameDotsToUnderscores": true,
  "ConsulAddress": "",
  "ConsulAclToken": "",
  "ConsulKVStoreProvider": "consul",
  "RaftEnabled": true,
  "BackendDB": "mysql",
  "RaftDataDir": "/usr/local/orchestrator",
  "RaftBind": "10.0.0.51",
  "DefaultRaftPort": 10008,
  "RaftNodes": [
    "10.0.0.51",
    "10.0.0.52",
    "10.0.0.53"
  ]
}
EOF
```

第五步：编辑ORCH切换VIP脚本--注意！有坑！每个机器配置都不一样！

```
#须修改配置:

#local_ip="10.0.0.51" #当前主机IP

#mysql_vip="10.0.0.100" #mysql集群VIP

#eth_dev="eth0" #当前主机网卡名
```

写入配置文件：

```
#1.创建脚本
cat > /usr/local/orchestrator/orch_hook.sh << 'EOFF'
#!/bin/bash

isitdead=$1
cluster=$2
oldmaster=$3
newmaster=$4
mysqluser="orchestrator"
export MYSQL_PWD="orchestrator"
sshoptions="-p 22 -o StrictHostKeyChecking=no"
logfile="/usr/local/orchestrator/log/orch_hook.log"
local_ip="10.0.0.51"
mysql_vip="10.0.0.100"
eth_dev="eth0"

if [[ $isitdead == "DeadMaster" ]]; then
    array=( ${eth_dev} "${mysql_vip}" root "${local_ip}")
    interface=${array[0]}
    IP=${array[1]}
    user=${array[2]}
    echo "array: $array"
    echo "interface: $interface"
    echo "IP: $IP"
    echo "user: $user"
    if [ ! -z ${IP} ] ; then
        echo $(date)
        echo "Recovering from: $isitdead"
        echo "New master is: $newmaster"
        echo "/usr/local/orchestrator/orch_vip.sh -d 1 -n $newmaster -s ${sshoptions} -i ${interface} -I ${IP} -u ${user} -o $oldmaster" | tee $logfile
        /usr/local/orchestrator/orch_vip.sh -d 1 -n $newmaster -s "${sshoptions}" -i ${interface} -I ${IP} -u ${user} -o $oldmaster
    else
        echo "Cluster does not exist!" | tee $logfile
    fi
elif [[ $isitdead == "DeadIntermediateMasterWithSingleSlaveFailingToConnect" ]]; then
    array=( ${eth_dev} "${mysql_vip}" root "${local_ip}")
    interface=${array[0]}
    IP=${array[3]}
    user=${array[2]}
    slavehost=`echo $5 | cut -d":" -f1`
    echo $(date)
    echo "Recovering from: $isitdead"
    echo "New intermediate master is: $slavehost"
    echo "/usr/local/orchestrator/orch_vip.sh -d 1 -n $slavehost -s ${sshoptions} -i ${interface} -I ${IP} -u ${user} -o $oldmaster" | tee $logfile
    /usr/local/orchestrator/orch_vip.sh -d 1 -n $slavehost -s "${sshoptions}" -i ${interface} -I ${IP} -u ${user} -o $oldmaster
elif [[ $isitdead == "DeadIntermediateMaster" ]]; then
    array=( ${eth_dev} "${mysql_vip}" root "${local_ip}")
    interface=${array[0]}
    IP=${array[3]}
    user=${array[2]}
    slavehost=`echo $5 | sed -E "s/:[0-9]+//g" | sed -E "s/,/ /g"`
    showslave=`mysql -h$newmaster -u$mysqluser -sN -e "SHOW SLAVE HOSTS;" | awk '{print $2}'`
    newintermediatemaster=`echo $slavehost $showslave | tr ' ' '\n' | sort | uniq -d`
    echo $(date)
    echo "Recovering from: $isitdead"
    echo "New intermediate master is: $newintermediatemaster"
    echo "/usr/local/orchestrator/orch_vip.sh -d 1 -n $newintermediatemaster -s ${sshoptions} -i ${interface} -I ${IP} -u ${user} -o $oldmaster" | tee $logfile
    /usr/local/orchestrator/orch_vip.sh -d 1 -n $newintermediatemaster -s "${sshoptions}" -i ${interface} -I ${IP} -u ${user} -o $oldmaster
fi
EOFF

#2.添加可执行权限
chmod +x /usr/local/orchestrator/orch_hook.sh

#3.更改所属用户
chown -R orchestrator:orchestrator /usr/local/orchestrator/
```

第六步：编辑ORCH切换VIP脚本--注意！所有ORCH机器都操作！

注意：orch_hook.sh 会调用 orch_vip.sh

```
#1.创建脚本
cat > /usr/local/orchestrator/orch_vip.sh << 'EOHFF'
#!/bin/bash

function usage {
    cat << EOF
    usage: $0 [-h] [-d master is dead] [-o old master] [-s ssh options] [-n new master] [-i interface] [-I] [-u SSH user]
    OPTIONS:
    -h Show this message
    -o string Old master hostname or IP address
    -d int If master is dead should be 1 otherwise it is 0
    -s string SSH options
    -n string New master hostname or IP address
    -i string Interface example eth0:1
    -I string Virtual IP
    -u string SSH user
EOF
}

while getopts ho:d:s:n:i:I:u: flag; do
    case $flag in
        o)
            orig_master="$OPTARG"
            ;;
        d)
            isitdead="$OPTARG"
            ;;
        s)
            ssh_options="$OPTARG"
            ;;
        n)
            new_master="$OPTARG"
            ;;
        i)
            interface="$OPTARG"
            ;;
        I)
            vip="$OPTARG"
            ;;
        u)
            ssh_user="$OPTARG"
            ;;
        h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

echo "orig_master: $orig_master"
echo "isitdead: $isitdead"
echo "ssh_options: $ssh_options"
echo "new_master: $new_master"
echo "interface: $interface"
echo "vip: $vip"

if [ $OPTIND -eq 1 ]; then
    echo "No options were passed"
    usage
fi

shift $((OPTIND - 1))

# Discover commands from our path
ssh=$(which ssh)
arping=$(which arping)
ip2util=$(which ip)

# Command for adding our VIP
cmd_vip_add="sudo -n $ip2util address add ${vip} dev ${interface}"

# Command for deleting our VIP
cmd_vip_del="sudo -n $ip2util address del ${vip}/32 dev ${interface}"

# Command for discovering if our VIP is enabled
cmd_vip_chk="sudo -n $ip2util address show dev ${interface} to ${vip%/*}/32"

# Command for sending gratuitous ARP to announce IP move
cmd_arp_fix="sudo -n $arping -c 1 -I ${interface} ${vip%/*}"

# Command for sending gratuitous ARP to announce IP move on current server
cmd_local_arp_fix="sudo -n $arping -c 1 -I ${interface} ${vip%/*}"

function vip_stop() {
    rc=0
    # Ensure the VIP is removed
    $ssh ${ssh_options} -tt ${ssh_user}@${orig_master} \
    "[ -n \"\$(${cmd_vip_chk})\" ] && ${cmd_vip_del} && sudo ${ip2util} route flush cache || [ -z \"\$(${cmd_vip_chk})\" ]"
    rc=$?
    return $rc
}

function vip_start() {
    rc=0
    # Ensure the VIP is added
    $ssh ${ssh_options} -tt ${ssh_user}@${new_master} \
    "[ -z \"\$(${cmd_vip_chk})\" ] && ${cmd_vip_add} && ${cmd_arp_fix} || [ -n \"\$(${cmd_vip_chk})\" ]"
    rc=$?
    $cmd_local_arp_fix
    return $rc
}

function vip_status() {
    $arping -c 1 -I ${interface} ${vip%/*}
    if ping -c 1 -W 1 "$vip"; then
        return 0
    else
        return 1
    fi
}

if [[ $isitdead == 0 ]]; then
    echo "Online failover"
    if vip_stop; then
        if vip_start; then
            echo "$vip is moved to $new_master."
        else
            echo "Can't add $vip on $new_master!"
            exit 1
        fi
    else
        echo "Can't remove the $vip from orig_master!"
        exit 1
    fi
elif [[ $isitdead == 1 ]]; then
    echo "Master is dead, failover"
    if vip_status; then
        if vip_stop; then
            echo "$vip is removed from orig_master."
        else
            echo "Couldn't remove $vip from orig_master."
            exit 1
        fi
    fi
    if vip_start; then
        echo "$vip is moved to $new_master."
    else
        echo "Can't add $vip on $new_master!"
        exit 1
    fi
else
    echo "Wrong argument, the master is dead or live?"
fi
EOHFF

#2.添加可执行权限
chmod +x /usr/local/orchestrator/orch_vip.sh

#3.更改所属用户
chown -R orchestrator:orchestrator /usr/local/orchestrator/
```

第七步：systemd配置Orchestrator启动文件--注意！所有ORCH机器都操作！

```
cat > /etc/systemd/system/orchestrator.service << 'EOFF'
[Unit]
Description=orchestrator: MySQL replication management and visualization
Documentation=https://github.com/openark/orchestrator
After=syslog.target network.target mysqld.service mysql.service

[Service]
Type=simple
WorkingDirectory=/usr/local/orchestrator
ExecStart=/usr/local/orchestrator/orchestrator http
EnvironmentFile=-/etc/sysconfig/orchestrator
ExecReload=/bin/kill -HUP $MAINPID
LimitNOFILE=16384

[Install]
WantedBy=multi-user.target
EOFF
```

第八步：启动orchestrator--注意！所有ORCH机器都操作！

```
systemctl daemon-reload
systemctl start orchestrator
systemctl enable orchestrator
netstat -lntup|grep 3000
```
