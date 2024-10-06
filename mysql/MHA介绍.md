

## 1.MHA介绍

```
MHA(Master High Availability)目前在MySQL高可用方面是一个相对成熟的解决方案。
它由日本DeNA公司youshimaton(现就职于Facebook公司)开发，是一套优秀的作为 MySQL高可用性环境下故障切换和主从提升的高可用软件。

在MySQL故障切换过程中，MHA能做到在0~30秒之内自动完成数据库的故障切换操作，并且在进行故障切换的过程中，MHA能在最大程度上保证数据的一致性，以达到真正意义上的高可用。

MHA还提供在线主库切换的功能，能够安全地切换当前运行的主库到一个新的主库中 (通过将从库提升为主库),大概0.5-2秒内即可完成。
```

## 2.MHA的优势

```
1.自动故障转移快
2.主库崩溃不存在数据一致性问题
3.配置不需要对当前mysql环境做重大修改
4.不需要添加额外的服务器(仅一台manager就可管理上百个replication)
5.性能优秀，可工作在半同步复制和异步复制，当监控mysql状态时，仅需要每隔N秒 向master发送ping包(默认3秒)，所以对性能无影响。你可以理解为MHA的性能和简 单的主从复制框架性能一样。
6.只要replication支持的存储引擎，MHA都支持，不会局限于innodb
```

## 3.MHA功能

```
1.监控
2.选主
3.应用透明(vip)
4.故障提醒
5.额外数据补偿
6.剔除故障节点
7.manager 程序"自杀"
```

## 4.MHA组件功能说明

```
manager 组件
masterha_manger             启动MHA 
masterha_check_ssh          检查MHA的SSH配置状况 
masterha_check_repl         检查MySQL复制状况，配置信息
masterha_master_monitor     检测master是否宕机 
masterha_check_status       检测当前MHA运行状态 
masterha_master_switch    	控制故障转移（自动或者手动）
masterha_conf_host         	添加或删除配置的server信息

node 组件
save_binary_logs            保存和复制master的二进制日志 
apply_diff_relay_logs       识别差异的中继日志事件并将其差异的事件应用于其他的
purge_relay_logs            清除中继日志（不会阻塞SQL线程）
```

