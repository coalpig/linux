# MySQL监控命令

## mysqladmin status

  

## mysqladmin extended-status

`mysqladmin extended-status`命令提供了MySQL服务器的扩展状态信息，包括各种性能指标和运行时统计数据。以下是一些关键指标的详细解读：

1. **Aborted_clients** 和 **Aborted_connects**：

- `Aborted_clients`：客户端连接被中止的数量。这通常是由于客户端发送了非法请求或连接超时。
- `Aborted_connects`：尝试连接到MySQL服务器但失败（例如，由于认证错误、网络问题或达到最大连接数）的次数。

1. **Bytes_received** 和 **Bytes_sent**：

- `Bytes_received`：服务器从客户端接收到的总字节数。
- `Bytes_sent`：服务器发送给客户端的总字节数。

1. **Com_xxx** 系列指标：

- 这些指标记录了各种SQL命令的执行次数。例如，`Com_select`表示SELECT语句的执行次数，`Com_insert`表示INSERT语句的执行次数等。大多数SQL命令的执行次数为0，表明这些操作没有被执行。

1. **Connection_errors_xxx** 系列指标：

- 这些指标记录了连接错误的不同类型，例如`Connection_errors_accept`表示接受连接时发生的错误，`Connection_errors_internal`表示内部连接错误等。

1. **Connections**：

- 服务器当前打开的客户端连接总数。

1. **Created_tmp_disk_tables**、**Created_tmp_files** 和 **Created_tmp_tables**：

- 这些指标记录了服务器在运行过程中创建的临时磁盘表、临时文件和临时表的数量。

1. **Handler_xxx** 系列指标：

- 这些指标记录了各种存储引擎操作的数量，例如`Handler_read_first`表示读取表的第一行的次数，`Handler_read_key`表示按索引读取行的次数等。

1. **Innodb_buffer_pool_xxx** 系列指标：

- 这些指标记录了InnoDB存储引擎缓冲池的状态和活动，例如`Innodb_buffer_pool_pages_data`表示缓冲池中包含数据的页数，`Innodb_buffer_pool_pages_dirty`表示缓冲池中脏页的数量等。

1. **Innodb_data_xxx** 和 **Innodb_os_log_xxx** 系列指标：

- 这些指标记录了InnoDB存储引擎的数据文件日志文件的操作情况，例如`Innodb_data_fsyncs`表示数据文件的同步次数，`Innodb_os_log_fsyncs`表示日志文件的同步次数等。

1. **Key_blocks_xxx** 系列指标：

- 这些指标记录了MyISAM存储引擎的索引块使用情况，例如`Key_blocks_not_flushed`表示未刷新的索引块数量，`Key_blocks_used`表示当前使用的索引块数量等。

1. **Max_used_connections** 和 **Max_used_connections_time**：

- `Max_used_connections`：服务器达到的最大并发连接数。
- `Max_used_connections_time`：达到最大并发连接数的时间。

1. **Not_flushed_delayed_rows**：

- 延迟插入队列中尚未刷新的行数。

1. **Open_files** 和 **Open_streams**：

- `Open_files`：当前打开的文件数量。
- `Open_streams`：当前打开的流数量。

1. **Open_table_definitions** 和 **Open_tables**：

- `Open_table_definitions`：当前打开的表定义数量。
- `Open_tables`：当前打开的表数量。

1. **Performance_schema_xxx** 系列指标：

- 这些指标记录了性能模式下的各种统计信息，例如`Performance_schema_accounts_lost`表示丢失的账户数量等。

1. **Qcache_xxx** 系列指标：

- 这些指标记录了查询缓存的统计信息，例如`Qcache_hits`表示查询缓存的命中次数，`Qcache_not_cached`表示未缓存的查询数量等。

1. **Queries** 和 **Questions**：

- `Queries`：服务器执行的查询总数。
- `Questions`：服务器接收的查询请求总数。

1. **Rsa_public_key**：

- 服务器的RSA公钥。

1. **Select_xxx** 系列指标：

- 这些指标记录了SELECT查询的不同类型，例如`Select_full_join`表示全表连接的SELECT查询次数，`Select_scan`表示全表扫描的SELECT查询次数等。

1. **Slave_open_temp_tables**：

- 从服务器打开的临时表数量。

1. **Slow_launch_threads** 和 **Slow_queries**：

- `Slow_launch_threads`：创建线程花费的时间超过指定阈值的次数。
- `Slow_queries`：执行时间超过指定阈值的查询次数。

1. **Sort_xxx** 系列指标：

- 这些指标记录了排序操作的数量，例如`Sort_merge_passes`表示排序合并的次数，`Sort_rows`表示排序的行数等。

1. **Ssl_xxx** 系列指标：

- 这些指标记录了SSL连接的相关统计信息，例如`Ssl_accepts`表示接受的SSL连接数，`Ssl_finished_accepts`表示完成的SSL连接数等。

1. **Table_locks_immediate** 和 **Table_locks_waited**：

- `Table_locks_immediate`：立即获得表锁的次数。
- `Table_locks_waited`：等待表锁的次数。

1. **Table_open_cache_hits** 和 **Table_open_cache_misses**：

- `Table_open_cache_hits`：从表打开缓存中成功获取表的次数。
- `Table_open_cache_misses`：未能从表打开缓存中获取表的次数。

1. **Threads_xxx** 系列指标：

- 这些指标记录了线程的状态和活动，例如`Threads_cached`表示缓存中的线程数量，`Threads_connected`表示当前连接的线程数量等。

1. **Uptime** 和 **Uptime_since_flush_status**：

- `Uptime`：服务器启动后的总运行时间。
- `Uptime_since_flush_status`：自上次刷新状态以来的运行时间。

通过这些指标，可以全面了解MySQL服务器的运行状况和性能表现，帮助进行故障排查和性能优化。

# 关键监控指标

## MySQL CPU/内存 利用率

|   |   |   |
|---|---|---|
|指标|单位|含义|
|mysql.mem_usage|%|MySQL实例内存使用率(占操作系统总数)。|
|mysql.cpu_usage|%|MySQL服务进程CPU使用率|

## MySQL存储空间使用量(MB)

|   |   |   |
|---|---|---|
|指标|单位|含义|
|relaylog_size|MByte|relay log使用量|
|redolog_size|MByte|redo log使用量|
|sys_data_size|MByte|系统数据库数据量|
|ins_size|MByte|MySQL 实例总空间使用量|
|temp_file_size|MByte|临时文件数据量|
|undolog_size|MByte|undo log使用量|
|general_log_size|MByte|常规日志使用量，包括了实例的错误日志、performance agent 日志、recover 日志|
|binlog_size|MByte|binlog使用量|
|slowlog_size|MByte|slow log使用量|
|user_data_size|MByte|用户数据库数据量|

## 磁盘使用率(%)

|   |   |   |
|---|---|---|
|指标|单位|含义|
|mysql.disk_usage|%|磁盘使用率|

## IOPS使用率

|   |   |   |
|---|---|---|
|指标|单位|含义|
|mysql.iops_usage|%|iops利用率|

## MySQL IOPS

|   |   |   |
|---|---|---|
|指标|单位|含义|
|mysql.iops|Count|MySQL读写次数|

## MySQL每秒读写吞吐量(B)

|   |   |   |
|---|---|---|
|指标|单位|含义|
|mysql.data_io_bytes_ps|Per Second|MySQL每秒读写吞吐量|

## 流量吞吐(KB)

|   |   |   |
|---|---|---|
|指标|单位|含义|
|mysql.bytes_received|KByte|平均每秒从所有客户端接收到的字节数|
|mysql.bytes_sent|KByte|平均每秒发送给所有客户端的字节数|

## TPS/QPS

|   |   |   |
|---|---|---|
|指标|单位|含义|
|qps|Per Second|计算公式：Queries / Uptime|
|tps|Per Second|计算公式：(Com_insert + Com_insert_select + Com_update + Com_update_multi + Com_delete_multi + Com_delete + Com_replace + Com_replace_select) / Uptime|
|DDL_ps|Per Second|每秒DDL次数|

## 会话连接

|   |   |   |
|---|---|---|
|指标|单位|含义|
|mysql.total_session|Count|当前全部会话|
|mysql.active_session|Count|当前活跃会话|

## 执行次数

|   |   |   |
|---|---|---|
|指标|单位|含义|
|mysql.insert_select|Per Second|平均每秒Insert_Select语句执行次数|
|mysql.insert_ps|Per Second|平均每秒insert语句执行次数|
|mysql.select_ps|Per Second|平均每秒select语句执行次数|
|mysql.replace_select|Per Second|平均每秒Replace_Select语句执行次数|
|mysql.update_ps|Per Second|平均每秒update语句执行次数|
|mysql.delete_ps|Per Second|平均每秒delete语句执行次数|
|mysql.replace_ps|Per Second|平均每秒replace语句执行次数|

## 临时表

|   |   |   |
|---|---|---|
|指标|单位|含义|
|Innodb_num_open_files|Count|Innodb打开文件数|
|Open_tables|Count|打开表数|
|Open_files|Count|打开的文件数|
|Created_tmp_disk_tables|Count|MySQL执行语句时在硬盘上自动创建的临时表的数量|
|Created_tmp_disk_tables_ps|Per Second|每秒创建的临时表数量|

## 线程

|   |   |   |
|---|---|---|
|指标|单位|含义|
|mysql.threads_connected|Count|当前全部线程数|
|mysql.threads_running|Count|当前活跃线程数|

```
mysql> SHOW STATUS LIKE 'Threads_connected';
+-------------------+-------+
| Variable_name     | Value |
+-------------------+-------+
| Threads_connected | 6     |
+-------------------+-------+
1 row in set (0.00 sec)

mysql> SHOW STATUS LIKE 'Threads_running';
+-----------------+-------+
| Variable_name   | Value |
+-----------------+-------+
| Threads_running | 1     |
+-----------------+-------+
1 row in set (0.00 sec)
```

## 连接数利用率(%/count)

|   |   |   |
|---|---|---|
|指标|单位|含义|
|mdl_lock_session|Count|mdl锁阻塞的连接数|
|conn_usage|%|连接数利用率|

## 全表扫描

|   |   |   |
|---|---|---|
|指标|单位|含义|
|mysql.select_scan|Per Second|执行全表搜索查询的数量|

```
mysql> SELECT SUM(SUM_NO_INDEX_USED) AS Total_Full_Table_Scans FROM performance_schema.events_statements_summary_by_digest WHERE SUM_NO_INDEX_USED > 0 AND DIGEST_TEXT NOT LIKE '%performance_schema%';
+------------------------+
| Total_Full_Table_Scans |
+------------------------+
|                      5 |
+------------------------+
1 row in set (0.00 sec)
```

## 刷盘次数

|   |   |   |
|---|---|---|
|指标|单位|含义|
|mysql.innodb_data_fsyncs|Count|InnoDB 平均每秒fsync操作次数|

## InnoDB Data 读写吞吐量(KB)

|   |   |   |
|---|---|---|
|指标|单位|含义|
|mysql.innodb_data_written|KByte|InnoDB 平均每秒写字节数|
|mysql.innodb_data_read|KByte|InnoDB 平均每秒读字节数|

## InnoDB Buffer Pool 请求次数

|   |   |   |
|---|---|---|
|指标|单位|含义|
|mysql.innodb_buffer_pool_reads_requests|Count|InnoDB 平均每秒从Buffer Pool读取页的次数（逻辑读）|
|mysql.innodb_buffer_pool_write_requests|Count|InnoDB 平均每秒往Buffer Pool写入页的次数|

## 行锁

|   |   |   |
|---|---|---|
|指标|单位|含义|
|innodb_row_lock_waits|Count|InnoDB 表总等待row locks次数|
|Innodb_row_lock_current_waits|Count|InnoDB 表当前等待row locks次数|
|Innodb_row_lock_time|毫秒|从系统启动到现在锁定的总时间|
|Innodb_row_lock_time_ps|毫秒|InnoDB 表每秒等待row locks时间|
|Innodb_row_lock_waits_ps|Count|InnoDB 表每秒等待row locks次数|
|innodb_row_lock_time_avg|毫秒|InnoDB 表平均等待row locks时间|

  

## 节点复制线程状态`mysqladmin extended-status`命令提供了MySQL服务器的扩展状态信息，包括各种性能指标和运行时统计数据。以下是一些关键指标的详细解读：

1. **Aborted_clients** 和 **Aborted_connects**：

- `Aborted_clients`：客户端连接被中止的数量。这通常是由于客户端发送了非法请求或连接超时。
- `Aborted_connects`：尝试连接到MySQL服务器但失败（例如，由于认证错误、网络问题或达到最大连接数）的次数。

1. **Bytes_received** 和 **Bytes_sent**：

- `Bytes_received`：服务器从客户端接收到的总字节数。
- `Bytes_sent`：服务器发送给客户端的总字节数。

1. **Com_xxx** 系列指标：

- 这些指标记录了各种SQL命令的执行次数。例如，`Com_select`表示SELECT语句的执行次数，`Com_insert`表示INSERT语句的执行次数等。大多数SQL命令的执行次数为0，表明这些操作没有被执行。

1. **Connection_errors_xxx** 系列指标：

- 这些指标记录了连接错误的不同类型，例如`Connection_errors_accept`表示接受连接时发生的错误，`Connection_errors_internal`表示内部连接错误等。

1. **Connections**：

- 服务器当前打开的客户端连接总数。

1. **Created_tmp_disk_tables**、**Created_tmp_files** 和 **Created_tmp_tables**：

- 这些指标记录了服务器在运行过程中创建的临时磁盘表、临时文件和临时表的数量。

1. **Handler_xxx** 系列指标：

- 这些指标记录了各种存储引擎操作的数量，例如`Handler_read_first`表示读取表的第一行的次数，`Handler_read_key`表示按索引读取行的次数等。

1. **Innodb_buffer_pool_xxx** 系列指标：

- 这些指标记录了InnoDB存储引擎缓冲池的状态和活动，例如`Innodb_buffer_pool_pages_data`表示缓冲池中包含数据的页数，`Innodb_buffer_pool_pages_dirty`表示缓冲池中脏页的数量等。

1. **Innodb_data_xxx** 和 **Innodb_os_log_xxx** 系列指标：

- 这些指标记录了InnoDB存储引擎的数据文件日志文件的操作情况，例如`Innodb_data_fsyncs`表示数据文件的同步次数，`Innodb_os_log_fsyncs`表示日志文件的同步次数等。

1. **Key_blocks_xxx** 系列指标：

- 这些指标记录了MyISAM存储引擎的索引块使用情况，例如`Key_blocks_not_flushed`表示未刷新的索引块数量，`Key_blocks_used`表示当前使用的索引块数量等。

1. **Max_used_connections** 和 **Max_used_connections_time**：

- `Max_used_connections`：服务器达到的最大并发连接数。
- `Max_used_connections_time`：达到最大并发连接数的时间。

1. **Not_flushed_delayed_rows**：

- 延迟插入队列中尚未刷新的行数。

1. **Open_files** 和 **Open_streams**：

- `Open_files`：当前打开的文件数量。
- `Open_streams`：当前打开的流数量。

1. **Open_table_definitions** 和 **Open_tables**：

- `Open_table_definitions`：当前打开的表定义数量。
- `Open_tables`：当前打开的表数量。

1. **Performance_schema_xxx** 系列指标：

- 这些指标记录了性能模式下的各种统计信息，例如`Performance_schema_accounts_lost`表示丢失的账户数量等。

1. **Qcache_xxx** 系列指标：

- 这些指标记录了查询缓存的统计信息，例如`Qcache_hits`表示查询缓存的命中次数，`Qcache_not_cached`表示未缓存的查询数量等。

1. **Queries** 和 **Questions**：

- `Queries`：服务器执行的查询总数。
- `Questions`：服务器接收的查询请求总数。

1. **Rsa_public_key**：

- 服务器的RSA公钥。

1. **Select_xxx** 系列指标：

- 这些指标记录了SELECT查询的不同类型，例如`Select_full_join`表示全表连接的SELECT查询次数，`Select_scan`表示全表扫描的SELECT查询次数等。

1. **Slave_open_temp_tables**：

- 从服务器打开的临时表数量。

1. **Slow_launch_threads** 和 **Slow_queries**：

- `Slow_launch_threads`：创建线程花费的时间超过指定阈值的次数。
- `Slow_queries`：执行时间超过指定阈值的查询次数。

1. **Sort_xxx** 系列指标：

- 这些指标记录了排序操作的数量，例如`Sort_merge_passes`表示排序合并的次数，`Sort_rows`表示排序的行数等。

1. **Ssl_xxx**`mysqladmin extended-status`命令提供了MySQL服务器的扩展状态信息，包括各种性能指标和运行时统计数据。以下是一些关键指标的详细解读：
2. **Aborted_clients** **和** **Aborted_connects****：**

- `**Aborted_clients**`**：客户端连接被中止的数量。这通常是由于客户端发送了非法请求或连接超时。**
- `**Aborted_connects**`**：尝试连接到MySQL服务器但失败（例如，由于认证错误、网络问题或达到最大连接数）的次数。**

1. **Bytes_received** **和** **Bytes_sent****：**

- `**Bytes_received**`**：服务器从客户端接收到的总字节数。**
- `**Bytes_sent**`**：服务器发送给客户端的总字节数。**

1. **Com_xxx** **系列指标：**

- **这些指标记录了各种SQL命令的执行次数。例如，**`**Com_select**`**表示SELECT语句的执行次数，**`**Com_insert**`**表示INSERT语句的执行次数等。大多数SQL命令的执行次数为0，表明这些操作没有被执行。**

1. **Connection_errors_xxx** **系列指标：**

- **这些指标记录了连接错误的不同类型，例如**`**Connection_errors_accept**`**表示接受连接时发生的错误，**`**Connection_errors_internal**`**表示内部连接错误等。**

1. **Connections****：**

- **服务器当前打开的客户端连接总数。**

1. **Created_tmp_disk_tables****、****Created_tmp_files** **和** **Created_tmp_tables****：**

- **这些指标记录了服务器在运行过程中创建的临时磁盘表、临时文件和临时表的数量。**

1. **Handler_xxx** **系列指标：**

- **这些指标记录了各种存储引擎操作的数量，例如**`**Handler_read_first**`**表示读取表的第一行的次数，**`**Handler_read_key**`**表示按索引读取行的次数等。**

1. **Innodb_buffer_pool_xxx** **系列指标：**

- **这些指标记录了InnoDB存储引擎缓冲池的状态和活动，例如**`**Innodb_buffer_pool_pages_data**`**表示缓冲池中包含数据的页数，**`**Innodb_buffer_pool_pages_dirty**`**表示缓冲池中脏页的数量等。**

1. **Innodb_data_xxx** **和** **Innodb_os_log_xxx** **系列指标：**

- **这些指标记录了InnoDB存储引擎的数据文件日志文件的操作情况，例如**`**Innodb_data_fsyncs**`**表示数据文件的同步次数，**`**Innodb_os_log_fsyncs**`**表示日志文件的同步次数等。**

1. **Key_blocks_xxx** **系列指标：**

- **这些指标记录了MyISAM存储引擎的索引块使用情况，例如**`**Key_blocks_not_flushed**`**表示未刷新的索引块数量，**`**Key_blocks_used**`**表示当前使用的索引块数量等。**

1. **Max_used_connections** **和** **Max_used_connections_time****：**

- `**Max_used_connections**`**：服务器达到的最大并发连接数。**
- `**Max_used_connections_time**`**：达到最大并发连接数的时间。**

1. **Not_flushed_delayed_rows****：**

- **延迟插入队列中尚未刷新的行数。**

1. **Open_files** **和** **Open_streams****：**

- `**Open_files**`**：当前打开的文件数量。**
- `**Open_streams**`**：当前打开的流数量。**

1. **Open_table_definitions** **和** **Open_tables****：**

- `**Open_table_definitions**`**：当前打开的表定义数量。**
- `**Open_tables**`**：当前打开的表数量。**

1. **Performance_schema_xxx** **系列指标：**

- **这些指标记录了性能模式下的各种统计信息，例如**`**Performance_schema_accounts_lost**`**表示丢失的账户数量等。**

1. **Qcache_xxx** **系列指标：**

- **这些指标记录了查询缓存的统计信息，例如**`**Qcache_hits**`**表示查询缓存的命中次数，**`**Qcache_not_cached**`**表示未缓存的查询数量等。**

1. **Queries** **和** **Questions****：**

- `**Queries**`**：服务器执行的查询总数。**
- `**Questions**`**：服务器接收的查询请求总数。**

1. **Rsa_public_key****：**

- **服务器的RSA公钥。**

1. **Select_xxx** **系列指标：**

- **这些指标记录了SELECT查询的不同类型，例如**`**Select_full_join**`**表示全表连接的SELECT查询次数，**`**Select_scan**`**表示全表扫描的SELECT查询次数等。**

1. **Slave_open_temp_tables****：**

- **从服务器打开的临时表数量。**

1. **Slow_launch_threads** **和** **Slow_queries****：**

- `**Slow_launch_threads**`**：创建线程花费的时间超过指定阈值的次数。**
- `**Slow_queries**`**：执行时间超过指定阈值的查询次数。**

1. **Sort_xxx** **系列指标：**

- **这些指标记录了排序操作的数量，例如**`**Sort_merge_passes**`**表示排序合并的次数，**`**Sort_rows**`**表示排序的行数等。**

1. **Ssl_xxx** **系列指标：**

- **这些指标记录了SSL连接的相关统计信息，例如**`**Ssl_accepts**`**表示接受的SSL连接数，**`**Ssl_finished_accepts**`**表示完成的SSL连接数等。**

1. **Table_locks_immediate** **和** **Table_locks_waited****：**

- `**Table_locks_immediate**`**：立即获得表锁的次数。**
- `**Table_locks_waited**`**：等待表锁的次数。**

1. **Table_open_cache_hits** **和** **Table_open_cache_misses****：**

- `**Table_open_cache_hits**`**：从表打开缓存中成功获取表的次数。**
- `**Table_open_cache_misses**`**：未能从表打开缓存中获取表的次数。**

1. **Threads_xxx** **系列指标：**

- **这些指标记录了线程的状态和活动，例如**`**Threads_cached**`**表示缓存中的线程数量，**`**Threads_connected**`**表示当前连接的线程数量等。**

1. **Uptime** **和** **Uptime_since_flush_status****：**

- `**Uptime**`**：服务器启动后的总运行时间。**
- `**Uptime_since_flush_status**`**：自上次刷新状态以来的运行时间。**

**通过这些指标，可以全面了解MySQL服务器的运行状况和性能表现，帮助进行故障排查和性能优化。**

3. 系列指标：

- 这些指标记录了SSL连接的相关统计信息，例如`Ssl_accepts`表示接受的SSL连接数，`Ssl_finished_accepts`表示完成的SSL连接数等。

1. **Table_locks_immediate** 和 **Table_locks_waited**：

- `Table_locks_immediate`：立即获得表锁的次数。
- `Table_locks_waited`：等待表锁的次数。

1. **Table_open_cache_hits** 和 **Table_open_cache_misses**：

- `Table_open_cache_hits`：从表打开缓存中成功获取表的次数。
- `Table_open_cache_misses`：未能从表打开缓存中获取表的次数。

1. **Threads_xxx** 系列指标：

- 这些指标记录了线程的状态和活动，例如`Threads_cached`表示缓存中的线程数量，`Threads_connected`表示当前连接的线程数量等。

1. **Uptime** 和 **Uptime_since_flush_status**：

- `Uptime`：服务器启动后的总运行时间。
- `Uptime_since_flush_status`：自上次刷新状态以来的运行时间。

通过这些指标，可以全面了解MySQL服务器的运行状况和性能表现，帮助进行故障排查和性能优化。

|   |   |   |
|---|---|---|
|指标|单位|含义|
|mysql.slave_io_running|Count|读取源二进制日志的I/O线程是否正在运行|
|mysql.slave_sql_running|Count|执行中继日志中事件的SQL线程是否正在运行|

  

## 节点复制延迟(second)

|                 |       |        |
| --------------- | ----- | ------ |
| 指标              | 单位    | 含义     |
| mysql.slave_lag | Count | 节点复制延迟 |