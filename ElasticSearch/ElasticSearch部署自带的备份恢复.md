---
tags:
  - nfs
---
- ! NFS服务端操作

> [!info]- 官方地址说明:
> 
> 
> ```
> https://www.elastic.co/guide/en/elasticsearch/reference/7.9/snapshot-restore.html
> ```
> 

> [!info]- 前提条件
> 
> 
> ```
> 备份目录必须是共项目录，所有节点都能访问
> 所有节点的配置是一样，备份文件的路径
> 基于快照，不可阅读，类似于RDB
> 通过http指令的方式来备份
> 如果是Elasticsearch集群想使用快照功能，则存储快照的目录必须是共享存储，并且所有节点都需要挂载这个目录。
> ```
> 

> [!install]- NFS安装配置
> 
> 
> ```
> #安装了ES的主机作为服务端
> yum install nfs-utils -y
> id elasticsearch #查看uid和gid
> cat > /etc/exports << 'EOF'
> /data/backup 10.0.0.0/24(rw,sync,all_squash,anonuid=995,anongid=991) 
> EOF
> systemctl restart nfs
> showmount -e 10.0.0.51
> mkdir /data/backup -p
> 
> #客户端配置
> yum install nfs-utils -y
> mkdir /data/backup -p
> mount -t nfs 10.0.0.51:/data/backup /data/backup
> df -h
> ```
> > 另外一台主机作为服务端
> > ```
> > groupadd elasticsearch -g 996
> > useradd elasticsearch -u 998 -g 996 -M -s /sbin/nologin
> > mkdir /data/backup -p
> > chown -R elasticsearch:elasticsearch /data/backup
> > yum install nfs-utils -y
> > cat > /etc/exports << 'EOF'
> > /data/backup 10.0.0.0/24(rw,sync,all_squash,anonuid=998,anongid=996)
> > EOF
> > systemctl restart nfs
> > showmount -e 10.0.0.31
> > ```

- ! NFS客户端操作(ES服务端操作)

> [!install]- 所有节点挂载共享目录
> 
> 
> ```
> yum install nfs-utils -y
> mkdir /data/backup -p
> chown -R elasticsearch:elasticsearch /data/backup
> mount -t nfs 10.0.0.31:/data/backup /data/backup
> df -h
> ```

> [!config]- 所有节点修改配置文件添加path.repo
> 
> ```
> path.repo: ["/data/backup"]
> ```

> [!systemd]- 重启所有节点使配置生效
> 
> 
> ```
> systemctl restart elasticsearch
> ```
> 

> [!run]- 使用快照命令注册快照仓库
> 
> 
> ```
> PUT /_snapshot/my_fs_backup
> {
>     "type": "fs",
>     "settings": {
>         "location": "/data/backup/my_fs_backup_location",
>         "compress": true
>     }
> }
> 
> ```

> [!run]- 查看已有的所有快照
> 
> 
> ```
> GET /_snapshot/_all
> ```
> 

> [!run]- 快照所有的索引到快照仓库
> 
> 
> ```
> PUT /_snapshot/my_fs_backup/snapshot_1?wait_for_completion=true
> ```
> 

> [!run]- 快照指定的索引到仓库
> 
> 
> ```
> PUT /_snapshot/my_fs_backup/snapshot_2?wait_for_completion=true
> {
>   "indices": "news,news2",
>   "ignore_unavailable": true,
>   "include_global_state": false
> }
> ```

> [!run]- 查看已有的所有快照
> 
> ```
> GET /_snapshot/my_fs_backup/_all
> ```

> [!run]- 查看已有的单个快照
> 
> 
> ```
> GET /_snapshot/my_fs_backup/snapshot_1
> GET /_snapshot/my_fs_backup/snapshot_2
> ```


> [!delete]- 删除快照
> 
> 
> ```
> DELETE /_snapshot/my_fs_backup/snapshot_2
> ```

> [!delete]- 删除存储库
> 
> 
> ```
> DELETE /_snapshot/my_fs_backup
> ```

> [!run]- 全部还原
> 
> 
> ```
> POST /_snapshot/my_fs_backup/snapshot_1/_restore
> ```
> 

> [!run]- 还原部分
> 
> 
> ```
> POST /_snapshot/my_fs_backup/snapshot_1/_restore
> {
>   "indices": "news,news2",
>   "ignore_unavailable": true,
>   "include_global_state": true
> }
> ```

> [!run]- 还原部分并且重命名
> 
> 
> ```
> POST /_snapshot/my_fs_backup/snapshot_1/_restore
> {
>   "indices": "news,news2",
>   "ignore_unavailable": true,
>   "include_global_state": true,
>   "rename_pattern": "new(.+)",
>   "rename_replacement": "restored_new$1"
> }
> ```

> [!run]- 恢复的同时更改索引配置
> 
> 
> ```
> POST /_snapshot/my_fs_backup/snapshot_1/_restore
> {
>   "indices": "news,news2",
>   "index_settings": {
>     "index.number_of_replicas": 2
>   },
>   "ignore_index_settings": [
>     "index.refresh_interval"
>   ]
> }
> ```

> [!run]- 以日期命名快照
> 
> 
> ```
> PUT /_snapshot/my_fs_backup/%3Csnapshot-%7Bnow%2Fd%7D%3E
> GET /_snapshot/my_fs_backup/_all
> ```

