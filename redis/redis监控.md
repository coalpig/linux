## 1.参考地址

 http://www.redis.cn/commands/info.html

## 2.内容详解

server相关

```plain
redis_version: Redis 服务器版本
redis_git_sha1: Git SHA1
redis_git_dirty: Git dirty flag
redis_build_id: 构建ID
redis_mode: 服务器模式（standalone，sentinel或者cluster）
os: Redis 服务器的宿主操作系统
arch_bits: 架构（32 或 64 位）
multiplexing_api: Redis 所使用的事件处理机制
atomicvar_api: Redis使用的Atomicvar API
gcc_version: 编译 Redis 时所使用的 GCC 版本
process_id: 服务器进程的 PID
run_id: Redis 服务器的随机标识符（用于 Sentinel 和集群）
tcp_port: TCP/IP 监听端口
uptime_in_seconds: 自 Redis 服务器启动以来，经过的秒数
uptime_in_days: 自 Redis 服务器启动以来，经过的天数
hz: 服务器的频率设置
lru_clock: 以分钟为单位进行自增的时钟，用于 LRU 管理
executable: 服务器的可执行文件路径
config_file: 配置文件路径
```

client相关

```plain
connected_clients: 已连接客户端的数量（不包括通过从属服务器连接的客户端）
client_longest_output_list: 当前连接的客户端当中，最长的输出列表
client_biggest_input_buf: 当前连接的客户端当中，最大输入缓存
blocked_clients: 正在等待阻塞命令（BLPOP、BRPOP、BRPOPLPUSH）的客户端的数量
```

memory相关

```plain
used_memory: 由 Redis 分配器分配的内存总量，以字节（byte）为单位
used_memory_human: 以人类可读的格式返回 Redis 分配的内存总量
used_memory_rss: 从操作系统的角度，返回 Redis 已分配的内存总量（俗称常驻集大小）。这个值和 top 、 ps 等命令的输出一致。
used_memory_peak: Redis 的内存消耗峰值（以字节为单位）
used_memory_peak_human: 以人类可读的格式返回 Redis 的内存消耗峰值
used_memory_peak_perc: 使用内存占峰值内存的百分比
used_memory_overhead: 服务器为管理其内部数据结构而分配的所有开销的总和（以字节为单位）
used_memory_startup: Redis在启动时消耗的初始内存大小（以字节为单位）
used_memory_dataset: 以字节为单位的数据集大小（used_memory减去used_memory_overhead）
used_memory_dataset_perc: used_memory_dataset占净内存使用量的百分比（used_memory减去used_memory_startup）
total_system_memory: Redis主机具有的内存总量
total_system_memory_human: 以人类可读的格式返回 Redis主机具有的内存总量
used_memory_lua: Lua 引擎所使用的内存大小（以字节为单位）
used_memory_lua_human: 以人类可读的格式返回 Lua 引擎所使用的内存大小
maxmemory: maxmemory配置指令的值
maxmemory_human: 以人类可读的格式返回 maxmemory配置指令的值
maxmemory_policy: maxmemory-policy配置指令的值
mem_fragmentation_ratio: used_memory_rss 和 used_memory 之间的比率
mem_allocator: 在编译时指定的， Redis 所使用的内存分配器。可以是 libc 、 jemalloc 或者 tcmalloc 。
active_defrag_running: 指示活动碎片整理是否处于活动状态的标志
lazyfree_pending_objects: 等待释放的对象数（由于使用ASYNC选项调用UNLINK或FLUSHDB和FLUSHALL）
在理想情况下， used_memory_rss 的值应该只比 used_memory 稍微高一点儿。
当 rss > used ，且两者的值相差较大时，表示存在（内部或外部的）内存碎片。
内存碎片的比率可以通过 mem_fragmentation_ratio 的值看出。
当 used > rss 时，表示 Redis 的部分内存被操作系统换出到交换空间了，在这种情况下，操作可能会产生明显的延迟。
由于Redis无法控制其分配的内存如何映射到内存页，因此常住内存（used_memory_rss）很高通常是内存使用量激增的结果。
当 Redis 释放内存时，内存将返回给分配器，分配器可能会，也可能不会，将内存返还给操作系统。
如果 Redis 释放了内存，却没有将内存返还给操作系统，那么 used_memory 的值可能和操作系统显示的 Redis 内存占用并不一致。
查看 used_memory_peak 的值可以验证这种情况是否发生。
```

持久化相关

```plain
loading: 指示转储文件（dump）的加载是否正在进行的标志
rdb_changes_since_last_save: 自上次转储以来的更改次数
rdb_bgsave_in_progress: 指示RDB文件是否正在保存的标志
rdb_last_save_time: 上次成功保存RDB的基于纪年的时间戳
rdb_last_bgsave_status: 上次RDB保存操作的状态
rdb_last_bgsave_time_sec: 上次RDB保存操作的持续时间（以秒为单位）
rdb_current_bgsave_time_sec: 正在进行的RDB保存操作的持续时间（如果有）
rdb_last_cow_size: 上次RDB保存操作期间copy-on-write分配的字节大小
aof_enabled: 表示AOF记录已激活的标志
aof_rewrite_in_progress: 表示AOF重写操作正在进行的标志
aof_rewrite_scheduled: 表示一旦进行中的RDB保存操作完成，就会安排进行AOF重写操作的标志
aof_last_rewrite_time_sec: 上次AOF重写操作的持续时间，以秒为单位
aof_current_rewrite_time_sec: 正在进行的AOF重写操作的持续时间（如果有）
aof_last_bgrewrite_status: 上次AOF重写操作的状态
aof_last_write_status: 上一次AOF写入操作的状态
aof_last_cow_size: 上次AOF重写操作期间copy-on-write分配的字节大
aof_current_size: 当前的AOF文件大小
aof_base_size: 上次启动或重写时的AOF文件大小
aof_pending_rewrite: 指示AOF重写操作是否会在当前RDB保存操作完成后立即执行的标志。
aof_buffer_length: AOF缓冲区大小
aof_rewrite_buffer_length: AOF重写缓冲区大小
aof_pending_bio_fsync: 在后台IO队列中等待fsync处理的任务数
aof_delayed_fsync: 延迟fsync计数器
```

正在加载的操作

```plain
loading_start_time: 加载操作的开始时间（基于纪元的时间戳）
loading_total_bytes: 文件总大小
loading_loaded_bytes: 已经加载的字节数
loading_loaded_perc: 已经加载的百分比
loading_eta_seconds: 预计加载完成所需的剩余秒数
```

stats相关

```plain
total_connections_received: 服务器接受的连接总数
total_commands_processed: 服务器处理的命令总数
instantaneous_ops_per_sec: 每秒处理的命令数
rejected_connections: 由于maxclients限制而拒绝的连接数
expired_keys: key到期事件的总数
evicted_keys: 由于maxmemory限制而导致被驱逐的key的数量
keyspace_hits: 在主字典中成功查找到key的次数
keyspace_misses: 在主字典中查找key失败的次数
pubsub_channels: 拥有客户端订阅的全局pub/sub通道数
pubsub_patterns: 拥有客户端订阅的全局pub/sub模式数
latest_fork_usec: 最新fork操作的持续时间，以微秒为单位
```

replication相关

```plain
role: 如果实例不是任何节点的从节点，则值是”master”，如果实例从某个节点同步数据，则是”slave”。 请注意，一个从节点可以是另一个从节点的主节点（菊花链）。
如果实例是从节点，则会提供以下这些额外字段：

master_host: 主节点的Host名称或IP地址
master_port: 主节点监听的TCP端口
master_link_status: 连接状态（up或者down）
master_last_io_seconds_ago: 自上次与主节点交互以来，经过的秒数
master_sync_in_progress: 指示主节点正在与从节点同步
如果SYNC操作正在进行，则会提供以下这些字段：

master_sync_left_bytes: 同步完成前剩余的字节数
master_sync_last_io_seconds_ago: 在SYNC操作期间自上次传输IO以来的秒数
如果主从节点之间的连接断开了，则会提供一个额外的字段：

master_link_down_since_seconds: 自连接断开以来，经过的秒数
以下字段将始终提供：

connected_slaves: 已连接的从节点数
对每个从节点，将会添加以下行：

slaveXXX: id，地址，端口号，状态
```

CPU相关

```plain
used_cpu_sys: 由Redis服务器消耗的系统CPU
used_cpu_user: 由Redis服务器消耗的用户CPU
used_cpu_sys_children: 由后台进程消耗的系统CPU
used_cpu_user_children: 由后台进程消耗的用户CPU
```


 