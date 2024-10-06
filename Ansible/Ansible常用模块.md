---
tags:
  - ansible/基础
  - ansible模块
---

> [!info]- file模块
> 
> 
> 官网地址：
> 
> https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html#ansible-collections-ansible-builtin-file-module
> 
> 创建空文件
> 
> ansible web -m file -a "path=/opt/file1.txt state=touch"
> 
> ansible web -m file -a "path=/opt/file2.txt state=touch mode=0600 owner=games group=games"
> 
> 更改文件用户和权限
> 
> ansible web -m file -a "path=/opt/file1.txt state=file mode=0600 owner=games group=games"
> 
> 创建目录
> 
> ansible web -m file -a "path=/opt/dir state=directory mode=0700 owner=games group=games"
> 
> 递归更改目录下文件用户属性
> 
> ansible web -m file -a "path=/opt/dir state=directory owner=games group=games recurse=true"
> 
> 删除文件或目录
> 
> ansible web -m file -a "path=/opt/file1.txt state=absent"
> 
> ansible web -m file -a "path=/opt/dir state=absent"

> [!info]- group模块
> 
> 
> 官网地址
> 
> https://docs.ansible.com/ansible/latest/collections/ansible/builtin/group_module.html#ansible-collections-ansible-builtin-group-module
> 
> 创建用户组并指定gid
> 
> ansible web -m group -a "name=www state=present gid=1000"
> 
> 删除用户组
> 
> ansible web -m group -a "name=www state=absent"

> [!info]- 模块
> 
> 
> 官网地址
> 
> https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html#ansible-collections-ansible-builtin-user-module
> 
> 创建用户
> 
> ansible web -m user -a "name=www uid=1000 group=www create_home=false shell=/sbin/nologin state=present"
> 
> 删除用户
> 
> ansible web -m user -a "name=www state=absent"

> [!info]- yum模块
> 
> 
> 官方地址
> 
> https://docs.ansible.com/ansible/latest/collections/ansible/builtin/yum_module.html#ansible-collections-ansible-builtin-yum-module
> 
> 安装软件
> 
> ansible web -m yum -a "name=nfs-utils state=present"
> 
> 卸载软件
> 
> ansible web -m yum -a "name=nfs-utils state=absent"

> [!info]- copy模块
> 
> 
> 官方地址
> 
> https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html#ansible-collections-ansible-builtin-copy-module
> 
> ansible本机的文件复制到目标服务器
> 
> ansible web -m copy -a "src=/opt/file1.txt dest=/mnt/file1.txt"
> 
> 远程主机本机的文件复制到本机
> 
> ansible web -m copy -a "src=/opt/file1.txt dest=/mnt/file1.txt remote_src=true"
> 
> 传输同时更改权限或用户组
> 
> ansible web -m copy -a "src=rsync.pass dest=/etc/ mode=0600"

> [!info]- systemd模块
> 
> 官方地址
> 
> https://docs.ansible.com/ansible/latest/collections/ansible/builtin/systemd_service_module.html#ansible-collections-ansible-builtin-systemd-service-module
> 
> 启动服务并设置开机自启动
> 
> ansible nfs_server -m systemd -a "name=nfs state=started enabled=true"
> 
> 关闭服务并取消开机自启动
> 
> ansible nfs_server -m systemd -a "name=nfs state=stopped enabled=false"

> [!info]- shell模块--不推荐使用
> 
> 官方地址
> 
> https://docs.ansible.com/ansible/latest/collections/ansible/builtin/shell_module.html#ansible-collections-ansible-builtin-shell-module
> 
> ansible nfs_server -m shell -a "showmount -e 172.16.1.31"

> [!info]- mount模块
> 
> 
> 官方地址
> 
> https://docs.ansible.com/ansible/latest/collections/ansible/posix/mount_module.html#mount-module
> 
> state状态解读
> 
> ```shell
> mounted			#挂载并且写入fstab
> 
> absent 			#即删除fstab条目也取消挂载
> 
> ```
> 
> 
> ```shell
> unmounted		#只取消挂载，但是不删除fstab条目
> 
> present 		       #只写入fstab条目，但是不执行挂载动作
> ```
> 
> 挂载并写入fstab
> 
> ansible web -m mount -a "src=172.16.1.31:/data path=/data state=mounted fstype=nfs"
> 
> 只取消挂载，但是不删除fstab条目
> 
> ansible web -m mount -a "path=/data state=unmounted"
> 
> 即删除fstab条目也取消挂载
> 
> ansible web -m mount -a "path=/data state=absent"
> 
> 只写入fstab条目，但是不执行挂载动作
> 
> ansible web -m mount -a "src=172.16.1.31:/data path=/data state=present fstype=nfs"

> [!info]- unarchive模块
> 
> 
> 官方地址
> 
> https://docs.ansible.com/ansible/latest/collections/ansible/builtin/unarchive_module.html#ansible-collections-ansible-builtin-unarchive-module
> 
> 远程解压
> 
> ansible web -m unarchive -a "src=conf.tar.gz dest=/opt/"
> 
> 目标主机本地解压
> 
> ansible web -m unarchive -a "src=/opt/conf.tar.gz dest=/mnt/ remote_src=true"

> [!info]- cron模块
> 
> 官方地址
> 
> https://docs.ansible.com/ansible/latest/collections/ansible/builtin/cron_module.html#ansible-collections-ansible-builtin-cron-module
> 
> 传统写法
> 
> */5 * * * * /usr/sbin/ntpdate time1.aliyun.com > /dev/null 2>&1
> 
> 创建定时任务并指定任务名称
> 
> ansible web -m cron -a "name='ntpdate time' minute='*/5' job='/usr/sbin/ntpdate time1.aliyun.com > /dev/null 2>&1'"
> 
> 注释一条定时任务
> 
> ansible web -m cron -a "name='ntpdate time' minute='*/5' job='/usr/sbin/ntpdate time1.aliyun.com > /dev/null 2>&1' disabled=true"
> 
> 删除定时任务
> 
> ansible web -m cron -a "name='ntpdate time' state=absent"
