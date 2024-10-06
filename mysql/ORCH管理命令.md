

## 1.管理mysql实例

使用orchertrator-client命令行请先安装jq

```
[root@db-51 ~]# yum install jq -y
[root@db-51 ~]# orchestrator-client -c discover -i 10.0.0.51:3306
10.0.0.51:3306
```

## 2.打印指定集群的拓扑

```
#orchestrator-client -c topology -i 10.0.0.51:3306
[root@db-51 ~]# orchestrator-client -c topology -i 10.0.0.51:3306
10.0.0.51:3306   [0s,ok,5.7.28-log,rw,ROW,>>,GTID]
+ 10.0.0.52:3306 [0s,ok,5.7.28-log,ro,ROW,>>,GTID]
+ 10.0.0.53:3306 [0s,ok,5.7.28-log,ro,ROW,>>,GTID]


#orchestrator-client -c topology-tabulated -i 10.0.0.51:3306
[root@db-51 ~]# orchestrator-client -c topology-tabulated -i 10.0.0.51:3306
10.0.0.51:3306  |0s|ok|5.7.28-log|rw|ROW|>>,GTID
+ 10.0.0.52:3306|0s|ok|5.7.28-log|ro|ROW|>>,GTID
+ 10.0.0.53:3306|0s|ok|5.7.28-log|ro|ROW|>>,GTID
```

## 3.主库设置VIP

第一次运行的时候VIP需要手动创建

```
ip address add 10.0.0.100 dev eth0
```

删除VIP命令

```
ip address del 10.0.0.100 dev eth0
```

将错误的GTID事务当做空事务应用副本的主上：gtid-errant-inject-empty

```
orchestrator-client -c gtid-errant-inject-empty  -i 10.0.0.52:3306
orchestrator-client -c gtid-errant-inject-empty  -i 10.0.0.53:3306
```

## 4.强制切换

```
orchestrator-client -c graceful-master-takeover -a 10.0.0.52:3306 -d 10.0.0.51:3306
orchestrator-client -c start-replica -i 10.0.0.52:3306
```

报错信息：

```
[root@db-51 ~]# orchestrator-client -c discover -i 10.0.0.51:3306
MySQLHostnameResolveMethod configured to use @@report_host but 10.0.0.51:3306 has NULL/empty @@report_host
```

解决方案:

在每个业务数据库的配置文件里添加以下参数，每台机器都不一样

```
report_host = 10.0.0.51
report_port = 3306
```

## 5.拓展--选举算法--raft

Raft 是一种用于管理和实现分布式系统中的一致性的算法。它是为了容易理解和实现而设计的，同时提供与 Paxos 等其他一致性算法相同的功能和保证。Raft 通过一系列的子协议来处理领导选举、日志复制、安全性和变更集群成员。

### 核心概念

Raft 将系统中的所有服务器划分为以下三种角色：

1. **Leader**：负责接收客户端请求，将请求作为日志条目添加到本地日志，然后复制到其他服务器。当日志条目被安全复制后，leader 会将操作应用到其状态机并返回结果给客户端。
2. **Follower**：被动地响应来自 leader 或候选者的请求。它们自身不发起任何请求。
3. **Candidate**：用于领导选举的临时角色。

### Raft 算法的关键步骤

#### 1. 领导选举

- 当服务器启动时，它们首先是 follower 状态。如果一个 follower 在一段时间内没有收到 leader 的消息，它会认为系统当前没有有效的 leader。
- 这时，follower 转变为 candidate 并开始一次领导选举：增加当前的任期号（term），对自己投票，并向其他服务器发送请求投票的消息。
- 收到大多数服务器的投票后，候选者变成 leader。
- 如果候选者在选举过程中从当前 leader 接收到有效的日志条目，则重新变回 follower。

#### 2. 日志复制

- Leader 接收到客户端的请求后，会将该请求作为一个新的日志条目存储在本地日志中，然后尝试通过发送 AppendEntries 消息将这个日志条目复制到集群中的所有 follower。
- 一旦日志条目被安全地复制（即被大多数服务器存储），leader 会将该条目应用到自己的状态机，并向客户端返回操作成功的响应。
- 如果 follower 没有及时复制日志，leader 会不断重试，直到所有的 follower 都成功存储所有的日志条目。

#### 3. 安全性

- Raft 通过 “领导者完整性原则” 保证安全性，即领导者必须拥有所有已提交的日志条目。
- 在选举过程中，candidate 必须向其他服务器展示其拥有的最新日志信息。如果其他服务器发现自己的日志比 candidate 的更新，它们将拒绝投票。

#### 4. 成员变更

- Raft 处理成员变更（即添加或删除服务器）的过程中，使用了一种被称为 “joint consensus”（联合一致性）的方法。在这种机制下，系统可以在变更过程中继续运行，同时保持一致性和可用性。

### 实现和应用

Raft 因其算法的清晰性和易于理解的特性而广泛应用于各种分布式系统中，如 etcd、Consul 和 Apache Ratis 等。这些系统利用 Raft 来管理配置信息、提供服务发现的一致性保证或作为分布式存储系统的一致性层。

## 6.ORCH配置解释

```
cat > /usr/local/orchestrator/orchestrator.conf.json << 'EOF'
{
  "Debug": true, // 开启调试模式
  "EnableSyslog": false, // 禁用Syslog记录
  "ListenAddress": ":3000", // 监听地址和端口
  "MySQLTopologyUser": "orchestrator", // MySQL拓扑用户
  "MySQLTopologyPassword": "orchestrator", // MySQL拓扑密码
  "MySQLTopologyCredentialsConfigFile": "", // MySQL拓扑凭证文件路径
  "MySQLTopologySSLPrivateKeyFile": "", // MySQL拓扑SSL私钥文件
  "MySQLTopologySSLCertFile": "", // MySQL拓扑SSL证书文件
  "MySQLTopologySSLCAFile": "", // MySQL拓扑SSL CA证书文件
  "MySQLTopologySSLSkipVerify": true, // 跳过MySQL拓扑SSL验证
  "MySQLTopologyUseMutualTLS": false, // MySQL拓扑不使用双向TLS
  "MySQLOrchestratorHost": "127.0.0.1", // Orchestator MySQL服务地址
  "MySQLOrchestratorPort": 3307, // Orchestator MySQL服务端口
  "MySQLOrchestratorDatabase": "orchestrator", // Orchestator数据库名称
  "MySQLOrchestratorUser": "orchestrator", // Orchestator数据库用户
  "MySQLOrchestratorPassword": "orchestrator", // Orchestator数据库密码
  "MySQLOrchestratorCredentialsConfigFile": "", // Orchestator数据库凭证文件路径
  "MySQLOrchestratorSSLPrivateKeyFile": "", // Orchestator SSL私钥文件
  "MySQLOrchestratorSSLCertFile": "", // Orchestator SSL证书文件
  "MySQLOrchestratorSSLCAFile": "", // Orchestator SSL CA证书文件
  "MySQLOrchestratorSSLSkipVerify": true, // 跳过Orchestator SSL验证
  "MySQLOrchestratorUseMutualTLS": false, // Orchestator不使用双向TLS
  "MySQLConnectTimeoutSeconds": 1, // MySQL连接超时时间（秒）
  "DefaultInstancePort": 3307, // 默认实例端口
  "DiscoverByShowSlaveHosts": true, // 通过SHOW SLAVE HOSTS发现从服务器
  "InstancePollSeconds": 5, // 实例轮询时间（秒）
  "DiscoveryIgnoreReplicaHostnameFilters": [ // 忽略的复制主机名过滤器
    "a_host_i_want_to_ignore[.]example[.]com",
    ".*[.]ignore_all_hosts_from_this_domain[.]example[.]com",
    "a_host_with_extra_port_i_want_to_ignore[.]example[.]com:3307"
  ],
  "UnseenInstanceForgetHours": 240, // 长时间未见实例的遗忘时间（小时）
  "SnapshotTopologiesIntervalHours": 0, // 拓扑快照间隔时间（小时）
  "InstanceBulkOperationsWaitTimeoutSeconds": 10, // 实例批量操作等待超时时间（秒）
  "HostnameResolveMethod": "none", // 主机名解析方法
  "MySQLHostnameResolveMethod": "@@report_host", // MySQL主机名解析方法
  "SkipBinlogServerUnresolveCheck": true, // 跳过Binlog服务器解析检查
  "ExpiryHostnameResolvesMinutes": 60, // 主机名解析过期时间（分钟）
  "RejectHostnameResolvePattern": "", // 拒绝的主机名解析模式
  "ReasonableReplicationLagSeconds": 10, // 合理的复制延迟时间（秒）
  "ProblemIgnoreHostnameFilters": [], // 忽略的问题主机名过滤器
  "VerifyReplicationFilters": false, // 验证复制过滤器
  "ReasonableMaintenanceReplicationLagSeconds": 20, // 维护期间合理的复制延迟时间（秒）
  "CandidateInstanceExpireMinutes": 60, // 候选实例过期时间（分钟）
  "AuditLogFile": "", // 审计日志文件路径
  "AuditToSyslog": false, // 审计记录到Syslog
  "RemoveTextFromHostnameDisplay": ".mydomain.com:3307", // 从主机名显示中移除的文本
  "ReadOnly": false, // 只读模式
  "AuthenticationMethod": "", // 认证方法
  "HTTPAuthUser": "admin", // HTTP认证用户
  "HTTPAuthPassword": "Admin#123456", // HTTP认证密码
  "AuthUserHeader": "", // 认证用户头
  "PowerAuthUsers": [ // 权限认证用户
    "*"
  ],
  "ClusterNameToAlias": { // 集群名称到别名的映射
    "127.0.0.1": "test suite"
  },
  "ReplicationLagQuery": "", // 复制延迟查询
  "DetectClusterAliasQuery": "select replace(substr(@@hostname, 1, instr(@@hostname, 'mysql')-2), '-', '_')", // 检测集群别名查询
  "DetectClusterDomainQuery": "", // 检测集群域名查询
  "DetectInstanceAliasQuery": "", // 检测实例别名查询
  "DetectPromotionRuleQuery": "", // 检测提升规则查询
  "DataCenterPattern": "[.]([^.]+)[.][^.]+[.]mydomain[.]com", // 数据中心模式
  "PhysicalEnvironmentPattern": "[.]([^.]+[.][^.]+)[.]mydomain[.]com", // 物理环境模式
  "PromotionIgnoreHostnameFilters": [], // 提升忽略主机名过滤器
  "DetectSemiSyncEnforcedQuery": "", // 检测半同步强制查询
  "ServeAgentsHttp": false, // 服务代理HTTP
  "AgentsServerPort": ":3001", // 代理服务器端口
  "AgentsUseSSL": false, // 代理使用SSL
  "AgentsUseMutualTLS": false, // 代理使用双向TLS
  "AgentSSLSkipVerify": false, // 代理跳过SSL验证
  "AgentSSLPrivateKeyFile": "", // 代理SSL私钥文件
  "AgentSSLCertFile": "", // 代理SSL证书文件
  "AgentSSLCAFile": "", // 代理SSL CA证书文件
  "AgentSSLValidOUs": [], // 代理SSL有效的组织单位
  "UseSSL": false, // 使用SSL
  "UseMutualTLS": false, // 使用双向TLS
  "SSLSkipVerify": false, // 跳过SSL验证
  "SSLPrivateKeyFile": "", // SSL私钥文件
  "SSLCertFile": "", // SSL证书文件
  "SSLCAFile": "", // SSL CA证书文件
  "SSLValidOUs": [], // SSL有效的组织单位
  "URLPrefix": "", // URL前缀
  "StatusEndpoint": "/api/status", // 状态端点
  "StatusSimpleHealth": true, // 简单健康状态
  "StatusOUVerify": false, // 状态OU验证
  "AgentPollMinutes": 60, // 代理轮询时间（分钟）
  "UnseenAgentForgetHours": 6, // 长时间未见代理的遗忘时间（小时）
  "StaleSeedFailMinutes": 60, // 陈旧种子失败时间（分钟）
  "SeedAcceptableBytesDiff": 8192, // 种子可接受的字节差异
  "PseudoGTIDPattern": "", // 伪GTID模式
  "PseudoGTIDPatternIsFixedSubstring": false, // 伪GTID模式是固定子字符串
  "PseudoGTIDMonotonicHint": "asc:", // 伪GTID单调提示
  "DetectPseudoGTIDQuery": "", // 检测伪GTID查询
  "BinlogEventsChunkSize": 10000, // Binlog事件块大小
  "SkipBinlogEventsContaining": [], // 跳过包含的Binlog事件
  "ReduceReplicationAnalysisCount": true, // 减少复制分析次数
  "FailureDetectionPeriodBlockMinutes": 1, // 失败检测阻塞时间（分钟）
  "FailMasterPromotionOnLagMinutes": 0, // 延迟分钟数导致主升级失败
  "RecoveryPeriodBlockSeconds": 60, // 恢复期阻塞时间（秒）
  "RecoveryIgnoreHostnameFilters": [], // 恢复忽略主机名过滤器
  "RecoverMasterClusterFilters": [ // 恢复主集群过滤器
    "*"
  ],
  "RecoverIntermediateMasterClusterFilters": [ // 恢复中间主集群过滤器
    "*"
  ],
  "OnFailureDetectionProcesses": [ // 失败检测过程
    "echo 'Detected {failureType} on {failureCluster}. Affected replicas:{countSlaves}' >> /usr/local/orchestrator/log/recovery.log"
  ],
  "PreGracefulTakeoverProcesses": [ // 优雅接管前过程
    "echo 'Planned takeover about to take place on {failureCluster}. Master will switch to read_only' >> /usr/local/orchestrator/log/recovery.log"
  ],
  "PreFailoverProcesses": [ // 故障转移前过程
    "echo 'Will recover from {failureType} on {failureCluster}' >> /usr/local/orchestrator/log/recovery.log"
  ],
  "PostFailoverProcesses": [ // 故障转移后过程
    "echo 'Recovered from {failureType} on {failureCluster}. Failed: {failedHost}:{failedPort}; Successor: {successorHost}: {successorPort}; failureClusterAlias:{failureClusterAlias}' >> /usr/local/orchestrator/log/recovery.log",
    "/usr/local/orchestrator/orch_hook.sh {failureType} {failureClusterAlias} {failedHost} {successorHost} >> /usr/local/orchestrator/log/recovery_orch_hook.log"
  ],
  "PostUnsuccessfulFailoverProcesses": [], // 故障转移不成功后过程
  "PostMasterFailoverProcesses": [ // 主故障转移后过程
    "echo 'Recovered from {failureType} on {failureCluster}. Failed: {failedHost}:{failedPort}; Promoted: {successorHost}:{successorPort}' >> /usr/local/orchestrator/log/recovery.log"
  ],
  "PostIntermediateMasterFailoverProcesses": [ // 中间主故障转移后过程
    "echo 'Recovered from {failureType} on {failureCluster}. Failed: {failedHost}:{failedPort}; Successor: {successorHost}:{successorPort}' >> /usr/local/orchestrator/log/recovery.log"
  ],
  "PostGracefulTakeoverProcesses": [ // 优雅接管后过程
    "echo 'Planned takeover complete' >> /usr/local/orchestrator/log/recovery.log"
  ],
  "CoMasterRecoveryMustPromoteOtherCoMaster": true, // 协同主恢复必须提升另一个协同主
  "DetachLostSlavesAfterMasterFailover": true, // 主故障转移后分离丢失的从属
  "ApplyMySQLPromotionAfterMasterFailover": true, // 主故障转移后应用MySQL提升
  "PreventCrossDataCenterMasterFailover": false, // 防止跨数据中心主故障转移
  "PreventCrossRegionMasterFailover": false, // 防止跨区域主故障转移
  "FailMasterPromotionIfSQLThreadNotUpToDate": false, // 如果SQL线程不是最新的，则主提升失败
  "DelayMasterPromotionIfSQLThreadNotUpToDate": true, // 如果SQL线程不是最新的，延迟主提升
  "DetachLostReplicasAfterMasterFailover": true, // 主故障转移后分离丢失的复制品
  "MasterFailoverDetachReplicaMasterHost": false, // 主故障转移分离复制主机
  "MasterFailoverLostInstancesDowntimeMinutes": 0, // 主故障转移丢失实例的停机时间（分钟）
  "PostponeReplicaRecoveryOnLagMinutes": 0, // 延迟复制恢复的分钟数
  "OSCIgnoreHostnameFilters": [], // 忽略主机名过滤器的在线模式切换
  "GraphiteAddr": "", // Graphite地址
  "GraphitePath": "", // Graphite路径
  "GraphiteConvertHostnameDotsToUnderscores": true, // Graphite将主机名中的点转换为下划线
  "ConsulAddress": "", // Consul地址
  "ConsulAclToken": "", // Consul访问控制列表令牌
  "ConsulKVStoreProvider": "consul", // Consul键值存储提供者
  "RaftEnabled": true, // 启用Raft协议
  "BackendDB": "mysql", // 后端数据库
  "RaftDataDir":"/usr/local/orchestrator", // Raft数据目录
  "RaftBind":"10.0.0.51", // Raft绑定地址
  "DefaultRaftPort":10008, // 默认Raft端口
  "RaftNodes":[ // Raft节点
    "10.0.0.51",
    "10.0.0.52",
    "10.0.0.53"
  ]
}
EOF
```
