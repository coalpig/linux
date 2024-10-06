
[📎proxysql-2.3.1-1-centos7.x86_64.rpm](https://www.yuque.com/attachments/yuque/0/2024/rpm/830385/1721791140284-4be9130a-7ec5-4451-a60c-c9c177b46f05.rpm)


## 1.安装ProxySQL--集群模式

```
yum localinstall proxysql-2.3.1-1-centos7.x86_64.rpm -y
```

## 2.修改ProxySQL配置文件支持集群模式

```
cat > /etc/proxysql.cnf << 'EOFF'
datadir="/var/lib/proxysql"
errorlog="/var/lib/proxysql/proxysql.log"

admin_variables=
{
    admin_credentials="admin:admin;cluster_user:cluster_user"
    mysql_ifaces="0.0.0.0:6032"
    cluster_username="cluster_user"
    cluster_password="cluster_user"
    cluster_check_interval_ms=200
    cluster_check_status_frequency=100
    cluster_mysql_query_rules_save_to_disk=true
    cluster_mysql_servers_save_to_disk=true
    cluster_mysql_users_save_to_disk=true
    cluster_proxysql_servers_save_to_disk=true
    cluster_mysql_query_rules_diffs_before_sync=3
    cluster_mysql_servers_diffs_before_sync=3
    cluster_mysql_users_diffs_before_sync=3
    cluster_proxysql_servers_diffs_before_sync=3
}

proxysql_servers=
(
    {
        hostname="10.0.0.51"
        port=6032
        weight=1
        comment="ProxySQL-node1"
    },
    {
        hostname="10.0.0.52"
        port=6032
        weight=1
        comment="ProxySQL-node2"
    },
    {
        hostname="10.0.0.53"
        port=6032
        weight=1
        comment="ProxySQL-node3"
    }
)

mysql_variables=
{
    threads=4
    max_connections=2048
    default_query_delay=0
    default_query_timeout=36000000
    have_compress=true
    poll_timeout=2000
    interfaces="0.0.0.0:6033"
    default_schema="information_schema"
    stacksize=1048576
    server_version="5.5.30"
    connect_timeout_server=3000
    monitor_username="monitor"
    monitor_password="monitor"
    monitor_history=600000
    monitor_connect_interval=60000
    monitor_ping_interval=10000
    monitor_read_only_interval=1500
    monitor_read_only_timeout=500
    ping_interval_server_msec=120000
    ping_timeout_server=500
    commands_stats=true
    sessions_sort=true
    connect_retries_on_failure=10
}

mysql_servers =
(
)

mysql_users:
(
)

mysql_query_rules:
(
)

scheduler=
(
)

mysql_replication_hostgroups=
(
)
EOFF
```

配置解释：

```
# 数据目录路径
datadir="/var/lib/proxysql"
# 错误日志文件路径
errorlog="/var/lib/proxysql/proxysql.log"

# 管理变量配置块
admin_variables=
{
    # 管理员凭证设置
    admin_credentials="admin:admin;cluster_user:cluster_user"
    # MySQL接口和端口
    mysql_ifaces="0.0.0.0:6032"
    # 集群用户名
    cluster_username="cluster_user"
    # 集群密码
    cluster_password="cluster_user"
    # 集群检查间隔（毫秒）
    cluster_check_interval_ms=200
    # 集群状态检查频率
    cluster_check_status_frequency=100
    # 将集群查询规则保存到磁盘
    cluster_mysql_query_rules_save_to_disk=true
    # 将集群MySQL服务器配置保存到磁盘
    cluster_mysql_servers_save_to_disk=true
    # 将集群MySQL用户配置保存到磁盘
    cluster_mysql_users_save_to_disk=true
    # 将集群ProxySQL服务器配置保存到磁盘
    cluster_proxysql_servers_save_to_disk=true
    # 同步前集群查询规则差异的次数
    cluster_mysql_query_rules_diffs_before_sync=3
    # 同步前集群MySQL服务器差异的次数
    cluster_mysql_servers_diffs_before_sync=3
    # 同步前集群MySQL用户差异的次数
    cluster_mysql_users_diffs_before_sync=3
    # 同步前集群ProxySQL服务器差异的次数
    cluster_proxysql_servers_diffs_before_sync=3
    # 开启调试模式
    debug=true
}

# ProxySQL服务器配置
proxysql_servers=
(
    {
        hostname="10.0.0.51"
        port=6032
        weight=1
        comment="ProxySQL-node1"
    },
    {
        hostname="10.0.0.52"
        port=6032
        weight=1
        comment="ProxySQL-node2"
    },
    {
        hostname="10.0.0.53"
        port=6032
        weight=1
        comment="ProxySQL-node3"
    }
)

# MySQL变量配置
mysql_variables=
{
    threads=4 # 线程数
    max_connections=2048 # 最大连接数
    default_query_delay=0 # 默认查询延迟
    default_query_timeout=36000000 # 默认查询超时时间
    have_compress=true # 启用压缩
    poll_timeout=2000 # 轮询超时
    interfaces="0.0.0.0:6033" # 接口配置
    default_schema="information_schema" # 默认数据库模式
    stacksize=1048576 # 栈大小
    server_version="5.5.30" # 服务器版本
    connect_timeout_server=3000 # 服务器连接超时
    monitor_username="monitor" # 监控用户名
    monitor_password="monitor" # 监控密码
    monitor_history=600000 # 监控历史
    monitor_connect_interval=60000 # 监控连接间隔
    monitor_ping_interval=10000 # 监控Ping间隔
    monitor_read_only_interval=1500 # 监控只读间隔
    monitor_read_only_timeout=500 # 监控只读超时
    ping_interval_server_msec=120000 # 服务器Ping间隔（毫秒）
    ping_timeout_server=500 # 服务器Ping超时
    commands_stats=true # 命令统计
    sessions_sort=true # 会话排序
    connect_retries_on_failure=10 # 连接失败重试次数
    eventslog_filename = "/var/lib/proxysql/proxysql_events.log" # 事件日志文件路径
    eventslog_default_log_level = 3 # 事件日志默认级别
}

# MySQL服务器配置（空）
mysql_servers =
(
)

# MySQL用户配置（空）
mysql_users:
(
)

# MySQL查询规则配置（空）
mysql_query_rules:
(
)

# 调度器配置（空）
scheduler=
(
)

# MySQL复制主从组配置（空）
mysql_replication_hostgroups=
(
)
```

## 3.启动服务

```
systemctl restart proxysql
```

## 4.检查节点信息

```
[root@db-51 ~]# mysql -uadmin -padmin -h127.0.0.1 -P6032
mysql> select * from proxysql_servers;
+-----------+------+--------+----------------+
| hostname  | port | weight | comment        |
+-----------+------+--------+----------------+
| 10.0.0.51 | 6032 | 1      | ProxySQL-node1 |
| 10.0.0.52 | 6032 | 1      | ProxySQL-node2 |
| 10.0.0.53 | 6032 | 1      | ProxySQL-node3 |
+-----------+------+--------+----------------+
3 rows in set (0.00 sec)
```

