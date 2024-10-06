没有高可用的mysql
- mysql的升级要考虑到集群，首先需要先将主库的数据使用xbk导出
- 然后新机器安装好mysql需要升级的版本
- 新机器使用xbk导入数据,手动补全binlog

如果使用ORCH会自动补偿binlog

