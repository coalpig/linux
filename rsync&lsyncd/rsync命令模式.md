---
tags:
  - rsync
---
# Rsync命令模式

## 1.命令格式

rsync [选项] 源文件 目标IP:目标路径		push 推送

rsync [选项] 目标IP:目标路径 本机路径  	pull 拉取

## 2.重要选项

-a	all 大部分参数都包含了

-v	显示传输详情

-z	zip压缩

--delete  完全同步

## 3.全量传输实验

第一步：在nfs-31上创建/data目录

第二步：在backup-41上创建/data目录

第三步：在nfs-31上创建测试文件

第四步：在nfs-31上使用rsync传送给backup-41

第五步：在backup-41上检查是否传过来了

## 4.增量传输实验

第一步：在nfs-31上创建新文件

第二步：在nfs-31上使用rsync传送给backup-41

第三步：检查是否只传输了新增加的内容

## 5.文件对比传输实验

第一步：修改nfs-31上某个文件

第二步：在nfs-31上使用rsync传送给backup-41

第三步：检查是否只传输了改变内容的文件

## 6.完全同步传输

```shell
rsync -avz --delete /data/ 10.0.0.41:/data/

rsync -avz --delete 10.0.0.41:/data/ /data/
```

小结：

谁在前以谁的目录为主
