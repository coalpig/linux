
最近公司测试服务器根目录满了，便有同事网上找了教程进行扩容，但是由于找的教程不够严谨 导致扩容失败，还丢失了一部分文件，所以这里详细说明一下方法。

方法流程说明：
1、查看系统存储空间，看一下/home做在卷已用空间大小、找到一个剩余空间较大的卷。因为要把/home文件夹压缩备份到该卷的文件夹下，确保空间足够备份！！！
2、备份/home文件夹 （确保备份成功！！！）
3、删除/home文件系统
4、扩容根目录
5、重新创建/home文件系统
6、恢复备份

一、先查看系统存储空间使用情况
```
df -h
```
1
先看一下/home下可用内存和已用内存
我这边是把/home文件夹备份的根目录的tmp文件夹下，所以我先将根目录里没用的文件清理了一下，确保剩余空间足够备份/home

二、备份home分区文件
务必确保压缩的目标目录空间足够 并压缩成功

```
tar cvf /tmp/home.tar /home
```
三、卸载/home，删除/home所在卷
如果无法卸载，先终止使用/home文件系统的进程

```
#杀死/home下的所有进程
fuser -km /home/
#卸载问价系统
umount /home #如果没有创建用户可以直接卸载
#删除卷
lvremove /dev/mapper/centos-home
```
可以 df 命令 看一下是否成功删除

四、扩展/root所在的卷
我这边加100G内容 可以根据需要自己调整
但是应低于 /home文件夹的可用容量

```
#扩展卷
lvextend -l +100%FREE /dev/mapper/centos-root
#扩展文件系统
xfs_growfs /dev/mapper/centos-root
```

删除fstab中的home挂载

```
vi /etc/fstab
```

五、重新创建home文件夹，并挂载
lvcreate -L后面的容量是/home一开始的可用容量减去刚才分配掉的容量 我这边是1100g

```
#创建卷
lvcreate -L 1100G -n /dev/mapper/centos-home
#创建文件系统
mkfs.xfs /dev/mapper/centos-home
#挂载文件系统
mount /dev/mapper/centos-home
```

六、恢复备份
```
tar xvf /tmp/home.tar -C/
```