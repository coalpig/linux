

## 1.模拟故障流程

第一步：主库MySQL停掉

```
systemctl stop mysqld
```

第二步：观察ORCH状态和集群状态

```
[root@db-51 ~]# orchestrator-client -c topology -i 10.0.0.53:3306
10.0.0.53:3306   [0s,ok,5.7.28-log,rw,ROW,>>,GTID]
+ 10.0.0.52:3306 [0s,ok,5.7.28-log,ro,ROW,>>,GTID]
```

## 2.故障修复

第一步：查看当前最新的主库信息

```
[root@db-51 ~]# orchestrator-client -c topology -i 10.0.0.53:3306
10.0.0.53:3306   [0s,ok,5.7.28-log,rw,ROW,>>,GTID]
+ 10.0.0.52:3306 [0s,ok,5.7.28-log,ro,ROW,>>,GTID]
```

第二步：重新启动故障MySQL

```
systemctl restart mysqld
```

第三步：手动调整复制关系

```
mysql -uroot -p123
change master to 
master_host='10.0.0.53',
master_user='repl',
master_password='123' ,
MASTER_AUTO_POSITION=1;
start slave;
show slave status\G
set global read_only=1;
set global super_read_only=on;
```

第四步：再次查看ORCH状态

```
[root@db-51 ~]# orchestrator-client -c topology -i 10.0.0.53:3306
10.0.0.53:3306   [0s,ok,5.7.28-log,rw,ROW,>>,GTID]
+ 10.0.0.51:3306 [0s,ok,5.7.28-log,ro,ROW,>>,GTID,downtimed]
+ 10.0.0.52:3306 [0s,ok,5.7.28-log,ro,ROW,>>,GTID]

[root@db-51 ~]# orchestrator-client -c topology -i 10.0.0.53:3306
10.0.0.53:3306   [0s,ok,5.7.28-log,rw,ROW,>>,GTID]
+ 10.0.0.51:3306 [0s,ok,5.7.28-log,ro,ROW,>>,GTID]
+ 10.0.0.52:3306 [0s,ok,5.7.28-log,ro,ROW,>>,GTID]
```

## 3.ORCH选举流程

### 1. 故障检测

Orchestrator 首先需要确定主服务器是否真的已经宕机。这通常是通过连续的健康检查失败来确认的。

### 2. 选举策略

一旦确定主服务器已经宕机，Orchestrator 将根据预先定义的策略和权重系统来选择新的主服务器。选举过程通常遵循以下准则：

- **复制延迟**：倾向选择复制延迟最小的服务器。
- **数据一致性**：选择数据最新、与原主服务器同步最接近的服务器。
- **服务器状态**：健康状态良好，没有硬件或网络问题的服务器更有可能被选为新主。
- **地理位置**：在某些配置中，可能会考虑服务器的地理位置，以优化延迟或符合数据驻留要求。
- **配置和容量**：选择具有足够资源（CPU、内存、存储空间）来处理主服务器负载的服务器。

### 3. 自动故障转移

Orchestrator 将自动执行故障转移操作，这包括：

- **晋升新主服务器**：将选举出的候选服务器晋升为新的主服务器。
- **重新配置复制**：更新其他从服务器的复制设置，使它们开始从新的主服务器复制数据。
- **虚拟IP和路由更改**（如果适用）：自动调整网络设置，确保流量被正确地重定向到新的主服务器。

### 4. 钩子和自定义脚本

在故障转移过程中，Orchestrator 允许执行自定义脚本（如 `orch_hook.sh` 和 `orch_vip.sh`），这些脚本可以处理额外的自定义逻辑，例如通知、日志记录或进一步的网络配置调整。

### 5. 监控和日志

整个故障检测和转移过程都会被详细记录并可通过 Orchestrator 的界面进行监控。这确保了操作的透明性和可追溯性。

通过这些机制，Orchestrator 能够确保 MySQL 集群在面对主服务器故障时能够迅速、有效地恢复，最大程度地减少服务中断时间并保持数据的完整性和一致性。

## 4.ORCH数据存储与raft选举

Orchestrator 使用的 MySQL 数据库配置项如下：

```
json
复制代码
"MySQLOrchestratorHost": "127.0.0.1",
"MySQLOrchestratorPort": 3307,
"MySQLOrchestratorDatabase": "orchestrator",
"MySQLOrchestratorUser": "orchestrator",
"MySQLOrchestratorPassword": "orchestrator",
```

根据这些配置，Orchestrator 会连接到运行在本地（`127.0.0.1`）的 MySQL 实例，该实例监听在端口 `3307` 上，并访问名为 `orchestrator` 的数据库。用户是 `orchestrator`，密码也是 `orchestrator`。

### 数据存储概述

- **单节点配置**：如果 Orchestrator 运行在单个节点上，它会将所有数据（包括集群的拓扑信息、历史记录和其他元数据）存储在指定的这个 MySQL 实例中。
- **多节点配置**：如果你的环境中配置了多个 Orchestrator 节点，例如为了高可用性和故障恢复，每个 Orchestrator 节点通常会配置自己的数据库实例。这是为了保证每个节点都能独立地访问和存储必要的数据，特别是在处理故障转移和数据库拓扑变化时。

### Raft协议

你的配置中还提到了 Raft 协议，这是一种用于实现分布式系统的一致性的协议。在你的配置中，相关的设置如下：

```
json
复制代码
"RaftEnabled": true,
"RaftDataDir": "/usr/local/orchestrator",
"RaftBind": "10.0.0.51",
"DefaultRaftPort": 10008,
"RaftNodes": [
    "10.0.0.51",
    "10.0.0.52",
    "10.0.0.53"
]
```

启用 Raft 后，Orchestrator 的多个节点将通过 Raft 协议协同工作，以确保集群状态的一致性。这意味着，虽然每个节点可能都连接到自己的本地 MySQL 实例，但关键的集群状态和决策（如主服务器的选举和故障转移的记录）将通过所有节点共享的 Raft 协议来同步。

### 结论

是的，每个 Orchestrator 节点都将数据存储在各自配置的 MySQL 实例中，数据库名称为 `orchestrator`，端口为 `3307`。通过 Raft 协议，这些节点可以在保持各自数据库的同时，确保关键操作的一致性和集群状态的同步。这种架构提高了 Orchestrator 集群的鲁棒性和可靠性。

  

## 3.总结ORCH与MHA的对比

相同点：主从关系都需要自己手动修复

不同点：不需要关闭和重置ORCH的状态，修复完主从关系就能继续监控