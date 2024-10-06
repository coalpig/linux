首先需要搭建mysql自带的主从复制，做好主库和从库的规划

MHA需要识别/usr/bin/mysql和mysqlbinlog，所以需要创建软链接

创建节点互信，分发密钥

所有节点安装MHA

主库创建MHA账号 从库也会复制账号过去

选择一个从库安装manage

manage配置好配置文件