1.官方提供的启动脚本最终会调用mysqld_safe命令脚本，然后mysqld_safe脚本又会调用mysqld主程序启动MySQL服务。
2.最终都是由mysqld启动，mysqld_safe可以看做是mysqld的守护进程。
3.mysqld_safe会启动并监视mysqld，如果mysqld发生意外错误可以重启服务。
4.mysqld_safe启动可以将mysqld的错误消息发送到数据目录中的host_name.err文件
5.可以读取的配置部分mysqld,server,myslqd_safe, 为了兼容mysql_safe也会读取safe_mysqld中的配置
6.调用的mysqld是可以在mysqld_safe中用-mysqld, --mysqld-version指定

mysqld作用:

```
1.mysqld是mysql的核心程序，用于管理mysql的数据库文件以及用户的请求操作。
2.mysqld可以读取配置文件中的[mysqld]的部分
```

启动流程示意图:

![](https://cdn.nlark.com/yuque/0/2024/webp/830385/1717331731295-cd4cf4d8-3c02-4fe2-8317-017a0896681d.webp?x-oss-process=image%2Fwatermark%2Ctype_d3F5LW1pY3JvaGVp%2Csize_43%2Ctext_6Lev6aOe5a2m5Z-O%2Ccolor_FFFFFF%2Cshadow_50%2Ct_80%2Cg_se%2Cx_10%2Cy_10)
