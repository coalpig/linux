---
tags:
  - rsync
---
## lsyncd软件安装

```
yum install lsyncd -y
```

## 2.修改配置文件

### 只监听一个目录：

```
cat > /etc/lsyncd.conf << 'EOF'

settings {

  logfile = "/var/log/lsyncd/lsyncd.log",

  statusFile = "/var/log/lsyncd/lsyncd.status",

  inotifyMode = "CloseWrite",

  maxProcesses = 8,

}



sync {

  default.rsync,

  source = "/data",

  target = "rsync_backup@172.16.1.41::data",

  delete = true,

  exclude = { ".*" },

  delay = 1,

  rsync = {

​    binary = "/usr/bin/rsync",

​    archive = true,

​    compress = true,

​    verbose = true,

​    password_file = "/etc/rsync.passwd",

​    _extra = {"--bwlimit=200"}

  }

}

EOF
```

### 监听两个目录:

```

[root@nfs ~]# cat /etc/lsyncd.conf

settings {

  logfile = "/var/log/lsyncd/lsyncd.log",

  statusFile = "/var/log/lsyncd/lsyncd.status",

  inotifyMode = "CloseWrite",

  maxProcesses = 8,

}

sync {

  default.rsync,

  source = "/data",

  target = "rsync_backup@172.16.1.41::data",

  delete = true,

  exclude = { ".*" },

  delay = 1,

  rsync = {

​    binary = "/usr/bin/rsync",

​    archive = true,

​    compress = true,

​    verbose = true,

​    password_file = "/etc/rsync.passwd",

​    _extra = {"--bwlimit=200"}

  }

}



sync {

  default.rsync,

  source = "/backup",

  target = "rsync_backup@172.16.1.41::backup",

  delete = true,

  exclude = { ".*" },

  delay = 1,

  rsync = {

​    binary = "/usr/bin/rsync",

​    archive = true,

​    compress = true,

​    verbose = true,

​    password_file = "/etc/rsync.passwd",

​    _extra = {"--bwlimit=200"}

  }

}

```
## 3.启动

```
systemctl start lsyncd
```

## 4.传输测试

lsyncd > sersyncd > 自己写的脚本
