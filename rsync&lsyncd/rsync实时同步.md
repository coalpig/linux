---
tags:
  - rsync
---
# 实时同步

## 1.实时同步难点

1）什么条件才同步？

2）同步哪些文件？

3）多久同步一次？

4）用什么工具同步？

#### 2.inotify工具--了解即可

通过inotify可以监控文件系统中添加,删除,修改,移动等各种事件

inotify-tools是用来管理inotify功能的工具

#### 3.使用inotify-tools监控文件变化

第一步：安装

```
yum install inotify-tools -y
```

第二步：监控指定目录的变化

```
inotifywait -mrq --timefmt '%d/%m/%y %H:%M' --format '%T %w%f' -e delete,create /backup
```

#### 4.编写脚本--理解即可

```
cat > notifiy.sh << 'EOF' 

\#!/bin/bash

\###免密变量

export RSYNC_PASSWORD=abc



\###第一次先全量同步

rsync -avz --delete /data/ rsync_backup@10.0.0.41::data



\###判断是同步文件还是同步目录

inotifywait -mrq --format '%w%f' -e delete,create,modify /data|while read line

do

​    ls $line && rsync -avz $line rsync_backup@10.0.0.41::data || rsync -avz --delete /data/ rsync_backup@10.0.0.41::data

done

EOF
```
