---
tags:
  - rsync
---
# rsync客户端部署
注意：

客户端不需要配置文件

客户端不需要启动服务

## 第一步：安装

```shell
yum install rsync -y
```

## 第二步：使用服务模式的账号密码连接

```shell
rsync -avz --delete /data/ rsync_backup@10.0.0.41::data
```

## 第三步：验证是否可以免交互传输

第一种方法：环境变量

```shell
export RSYNC_PASSWORD=abc

rsync -avz --delete /data/ rsync_backup@10.0.0.41::data
```



第二种方法：将密码写入文件，然后命令指定使用密码文件

```shell
echo "abc" >> /etc/rsync_clinet.pass

chmod 600 /etc/rsync_clinet.pass

rsync -avz --delete --password-file=/etc/rsync_clinet.pass /data/ rsync_backup@10.0.0.41::data

```