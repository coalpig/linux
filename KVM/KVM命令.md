> [!run]- 安装虚拟机
> 
> ```
> virt-install --virt-type kvm --os-type=linux --os-variant rhel7 --name centos7 --memory 1024 --vcpus 1 --disk /opt/centos7.raw,format=raw,size=10 --cdrom /opt/CentOS-7-x86_64-DVD-2009.iso --network network=default --graphics vnc,listen=0.0.0.0 --noautoconsole
> ```

> [!run]- 列出正在运行的虚拟机
> 
> 
> ```
> virsh list
> ```

> [!run]-  列出所有虚拟机，包括没有运行的
> 
> ```
> virsh list --all
> ```

> [!run]- 开启虚拟机
> 
> 
> ```
> virsh start centos7
> ```

> [!run]- 重启虚拟机
> 
> 
> ```
> virsh reboot centos7
> ```
> 

> [!run]- 关闭虚拟机
> 
> 
> ```
> 正常关闭虚拟机
> virsh shutdown centos7
> 
> #destroy是毁灭虚拟机
> virsh destroy centos7
> ```
> 

> [!run]- 查看配置文件
> 
> 
> ```
> virsh dumpxml centos7
> ```
> 

> [!run]- 导出配置文件
> 
> 
> 只要有磁盘文件和配置文件就可以迁移到其他机器
> 
> ```
> virsh dumpxml centos7 > centos7.xml
> ```
> 

> [!run]- 查看配置文件中的磁盘路径
> 
> ```
> virsh dumpxml centos7 | grep -n raw
> ```
> 

> [!run]- 删除虚拟机配置文件
> 
> 
> ```
> 先断电
> virsh destroy centos7 #相当于直接断电
> 
> virsh undefine centos7 #只删除配置文件的
> ```
> 

> [!run]- 导入虚拟机配置文件
> 
> 
> 需要把导出的配置文件和磁盘文件一起放在相同目录下
> 如果修改了虚拟机的磁盘位置，需要把磁盘文件移动到修改的路径
> ```
>   2   <name>centos7haha</name>
> ```
> 
> 
> ```
>  44       <source file='/data/centos7.raw'/>
> 
> ```
> >
> 
> ```
> virsh define centos7.xml
> ```
> 
> 并且会在/var/lib目录下生成配置文件
> 
> ```
> ls /etc/libvirt/qemu
> 
> centos7.xml networks
> ```
> 

> [!run]- 主机挂起
> 
> 
> ```
> virsh suspend web-blog
> ```

> [!run]- 主机恢复
> 
> 
> ```
>virsh resume web-blog
> ```

> [!run]- 主机重命名
> 
> 
> 关机状态下重命名
> 
> ```
>virsh domrename centos7 web-blog
> ```
> 

> [!test]- 修改虚拟机配置文件
> 
> 
> ```
> 项目背景：
> 
> 磁盘空间不足，需要迁移磁盘文件，但是配置文件里的路径需要修改
> 
> 建议使用edit命令编辑，可以检查语法
> 
> virsh edit centos7
> ```
> 
> 操作步骤
> 
> >首先要关闭虚拟机
> ```
> 虚拟机关闭状态下编辑
> 
>  virsh list --all
> 
> ```
> 编辑配置文件
> ```
> virsh edit centos7
> ```
> 移动磁盘文件到/data目录
> ```
> mkdir /data
> 
> mv /opt/centos7.raw /data/
> ```
> >
> ```
> 启动虚拟机
> virsh start centos7
> ```

> [!run]- kvm虚拟机开机启动
> 
> 
> ```
> [root@kvm ~]# virsh autostart web-blog
> 
> 域 web-blog标记为自动开始
> 
> 测试能否开机自启
> 
> [root@kvm ~]# virsh list --all
> 
> Id 名称 状态
> 
> ----------------------------------------------------
> 
> 1 web-blog running
> 
> 2 web-www running
> 
> [root@kvm ~]# virsh shutdown web-blog
> 
> 域 web-blog 被关闭
> 
> [root@kvm ~]# virsh shutdown web-www
> 
> 域 web-www 被关闭
> 
> [root@kvm ~]# virsh list --all
> 
> Id 名称 状态
> 
> ----------------------------------------------------
> 
> - web-blog 关闭
> 
> - web-www 关闭
> 
> 重启libvirtd服务
> 
> [root@kvm ~]# systemctl restart libvirtd.service
> 
> 再次查看虚拟机
> 
> [root@kvm ~]# virsh list --all
> 
> Id 名称 状态
> 
> ----------------------------------------------------
> 
> 1 web-blog running
> 
> - web-www 关闭
> 
> ```
> 

> [!run]- 查看哪些虚拟机是开机自启动
> 
> 
> 本质是软链接，只要存在这个软链接，就会开机自启动
> ```
> ll /etc/libvirt/qemu/autostart/
> virsh autostart
> ```

> [!run]- 查看VNC端口号
> 
> ```
> 查看当前运行的主机：
> 
> [root@kvm ~]# virsh list --all
> 
> Id 名称 状态
> 
> ----------------------------------------------------
> 
> 1 web-blog running
> 
> 2 web-www running
> 
> [root@kvm ~]# virsh vncdisplay web01
> 
> :0
> 
> [root@kvm ~]# virsh vncdisplay web-www
> 
> :1
> ```

> [!run]- 创建磁盘
> 
> 
> ```
> qemu-img create -f qcow2 /data/centos7.qcow2 1G
> ```
> 

> [!run]- 调整磁盘容量: 只能加不能减
> 
> 
> ```
> qemu-img resize /data/kvm.qcow2 1T
> ```
> 
> ```
> qemu-img info man.qcow2
> ```

> [!run]- 磁盘格式转换
> 
> 
> 操作步骤：
> 
> 1.将虚拟机关机
> 
> ```
> virsh shutdown web-blog
> ```
> 
> 2.转换磁盘格式
> 
> ```
> qemu-img convert -f raw -O qcow2 centos7.raw centos7.qcow2
> ```
> 
> 3.编辑配置文件修改为qcow2格式
> 
> ```
> virsh dumpxml web-blog > web.xml
> vim web.xml
> ```
> 
> 4.删除虚拟机配置文件
> 
> ```
> virsh undefine centos7
> ```
> 
> 5.定义新虚拟机配置
> 
> ```
> virsh define centos7.xml
> ```

> [!run]- KVM快照管理
> 
> 
> 创建快照
> ```
> virsh snapshot-create-as --name init     centos7
>                                快照名称  虚拟机名
> ```
> 
> 查看快照
> 
> ```
> virsh snapshot-list web-blog
> ```
> 
> 还原快照
> 
> ```
> virsh snapshot-revert centos7 --snapshotname init
> ```
> 
> 删除快照
> 
> ```
> virsh snapshot-delete centos7 --snapshotname init
> ```

> [!run]- 完整克隆
> 需要先关闭机器
> ```
> virsh shutdown centos7
> ```
> ```
> virt-clone --auto-clone -o centos7 -n centos7-clone
> ```
> 
> 
> 
> 查看快照发现并没有把原来机器的快照一起复制过来
> 
> ```
> virsh snapshot-list web-blog-backup
> ```

> [!run]- 链接克隆
> 
> 
> ```
> qemu-img create -f qcow2 -b centos7.qcow2 centos7-link.qcow2
> ```
> 
> 到处配置文件
> ```
>  virsh dumpxml centos7 > centos7-link.xml
> ```
> 
> 修改centos7-link.xml
> 
> ```
> vim centos7-link.xml
> ```
> 
> 定义配置文件
> 
> ```
> virsh define centos7-link.xml
> ```


> [!run]- 创建桥接网络
> 
> 
> 创建桥接网卡并且链接宿主机网卡
> ```
> virsh iface-bridge ens33 br0
> ```
> 
> 克隆一台新磁盘
> ```
> qemu-img create -f qcow2 -b centos7.qcow2 centos7-bridge.qcow2
> ```
> 
> 
> 如果磁盘已经存在，指挥创建配置文件
> ```
> virt-install --virt-type kvm --os-type=linux --os-variant rhel7 --name centos7-bridge --memory 1024 --vcpus 1 --disk /opt/centos7-bridge.qcow2 --boot hd --network bridge=br0 --graphics vnc,listen=0.0.0.0 --noautoconsole
> ```
> 

移除桥接网络


> [!run]- 热添加磁盘
> 
> 1.创建新磁盘  
> ```
> qemu-img create -f qcow2 centos7-disk-10G.qcow2 10G  
> ```
>   
> 2.临时添加新磁盘到虚拟机  
> ```
> virsh attach-disk centos7 /data/centos7-disk-10G.qcow2 vdb --subdriver qcow2  
> ```
>   
> 3.永久添加  
> ```
> virsh attach-disk centos7 /data/centos7-disk-10G.qcow2 vdb --subdriver qcow2 --config
> ```

> [!run]- 热迁移
> 
> 
> 需要三台服务器：
> 
> nfs,kvm-100,kvm-200
> 
> NFS服务端安装配置
> 
> 注意！要做host解析
> 
> ```
> virsh migrate --live --verbose web01 qemu+ssh://10.0.0.12/system --unsafe
> ```

> [!run]- KVM虚拟机迁移ESXi
> 
> 
> 1.安装ESXi虚拟机
> 
> 2.KVM主机执行转换磁盘格式
> 
> ```
> [root@kvm-100 /data]# qemu-img convert -f qcow2 -O vmdk web01.qcow2 web01.vmdk
> ```
> 
> 3.ESXi主机执行转换命令
> 
> ```
> mkfstools -i web01.vmdk -d thin web01-exsi.vmdk
> ```

> [!run]- ESXi转换为KVM
> 
> 
> 1.ESXi导出虚拟机为OVA格式
> 
> ```
> yum install virt-v2v -y
> 
> virt-v2v -i ova centos7.ova -o local -os /data -of qcow2
> 
> ```
> 2.直接拷贝vmdk磁盘文件然后转换
> 
> ```
> qemu-img convert -f vmdk -O qcow2 web01-exsi web01.qcow2
> ```

> [!run]- KVM图形化管理工具
>   
> 
> 13.1 项目地址  
> ```
> https://github.com/retspen/webvirtmgr/wiki/Install-WebVirtMgr  
> ```
> 
> 13.2 安装依赖命令  
> ```
> yum -y install git python-pip libvirt-python libxml2-python python-websockify supervisor gcc python-devel  
> pip install numpy -i  https://pypi.tuna.tsinghua.edu.cn/simple 
> ```
> 
> 13.3 安装python的Django环境  
> ```
> git clone git://github.com/retspen/webvirtmgr.git  
> cd webvirtmgr  
> pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple  
> ./manage.py syncdb  
> ./manage.py collectstatic  
> ```
> 
> 13.4 安装配置Nginx  
> ```
> cat > /etc/yum.repos.d/nginx.repo<< EOF  
> [nginx-stable]  
> name=nginx stable repo  
> baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/  
> gpgcheck=1  
> enabled=1  
> gpgkey=https://nginx.org/keys/nginx_signing.key  
> module_hotfixes=true  
>   
> [nginx-mainline]  
> name=nginx mainline repo  
> baseurl=http://nginx.org/packages/mainline/centos/\$releasever/\$basearch/  
> gpgcheck=1  
> enabled=0  
> gpgkey=https://nginx.org/keys/nginx_signing.key  
> module_hotfixes=true  
> EOF  
> ```
>   
>   
> ```
> yum install nginx -y  
> mkdir /code  
> mv /opt/webvirtmgr /code/  
> chown -R nginx:nginx /code  
> rm -rf /etc/nginx/conf.d/default.conf  
> ```
> 
> 
> ```
> cat >/etc/nginx/conf.d/webvirtmgr.conf<< EOF  
> server {  
> listen 80 default_server;  
>   
> server_name localhost;  
> access_log /var/log/nginx/webvirtmgr_access_log;  
>   
> location /static/ {  
> root /code/webvirtmgr;  
> expires max;  
> }  
> location / {  
> proxy_pass http://127.0.0.1:8000;  
> proxy_set_header X-Real-IP \$remote_addr;  
> proxy_set_header X-Forwarded-for \$proxy_add_x_forwarded_for;  
> proxy_set_header Host \$host:\$server_port;  
> proxy_set_header X-Forwarded-Proto \$scheme;  
> proxy_connect_timeout 600;  
> proxy_read_timeout 600;  
> proxy_send_timeout 600;  
> client_max_body_size 1024M;  
> }  
> }  
> EOF  
> ```
> 
> 
> ```
> nginx -t  
> systemctl start nginx  
> netstat -lntup|grep 80  
> ```
> 
> 13.5 配置Supervisor  
> ```
> cat >/etc/supervisord.d/webvirtmgr.ini<< EOF  
> [program:webvirtmgr]  
> command=/usr/bin/python /code/webvirtmgr/manage.py run_gunicorn -c /code/webvirtmgr/conf/gunicorn.conf.py  
> directory=/code/webvirtmgr  
> autostart=true  
> autorestart=true  
> logfile=/var/log/supervisor/webvirtmgr.log  
> log_stderr=true  
> user=nginx  
> [program:webvirtmgr-console]  
> command=/usr/bin/python /code/webvirtmgr/console/webvirtmgr-console  
> directory=/code/webvirtmgr  
> autostart=true  
> autorestart=true  
> stdout_logfile=/var/log/supervisor/webvirtmgr-console.log  
> redirect_stderr=true  
> user=nginx  
> EOF  
> systemctl start supervisord.service  
> supervisorctl status  
> 
> ```
> 
> 13.6 创建用户  
> ```
> mkdir /var/lib/nginx/.ssh/ -p  
> chown -R nginx:nginx /var/lib/nginx/  
> su - nginx -s /bin/bash  
> ssh-keygen  
> touch ~/.ssh/config && echo -e "StrictHostKeyChecking=no\nUserKnownHostsFile=/dev/null" >> ~/.ssh/config  
> chmod 0600 ~/.ssh/config  
> exit  
> adduser webvirtmgr  
> echo "123456"|passwd --stdin webvirtmgr  
> su - nginx -s /bin/bash  
> ssh-copy-id root@10.0.0.100  
> ```
> 
> 13.7 web页面操作  
> 
> 13.8 报错解决  
> ```
> python -m pip install --upgrade --force pip  
> pip install setuptools==33.1.1 -i https://pypi.tuna.tsinghua.edu.cn/simple  
> ```

