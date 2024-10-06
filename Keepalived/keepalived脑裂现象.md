---
tags:
  - Keepalived
---

> [!info]- 什么是脑裂现象
> 
> 
> split-brain
> 简单来说，就是主服务器还正常工作的情况下，备服务器收不到了主服务器发送的心跳请求包，就会以为主节点挂掉了，然后抢占VIP。
> 这个时候就会出现两台keepalived服务器都拥有了VIP，这时候路由器上的路由表就会混乱，导致出现莫名其妙的网络问题。
> 
> 通过抓包查看脑裂现象
> 
> lb-5安装抓包工具
> 
> ```plain
> yum install tcpdump -y
> ```
> 
> lb-5执行抓包命令
> 
> ```plain
> tcpdump -nn -i any host 224.0.0.18
> ```
> 
> lb-6新开一个终端，然后开启防火墙
> 
> ```plain
> systemctl start firewalld.service
> ```
> 
> 观察是否两边都有VIP
> 
> ```plain
> ip a
> ```

> [!info]- 出现裂脑后的排查
> 
> 
> 出现上述两台服务器争抢同一IP资源问题,一般要先考虑排查两个地方:
> 
> 1.主备两台服务器之间是否通讯正常,如果不正常是否有iptables防火墙阻挡?
> 
> 2.主备两台服务器对应的keepalived.conf配置文件是否有错误?
> 
> 例如是否同一实例的virtual_router_id配置不一样.
> 

- ~ 如何解决脑裂现象

> [!info]- 火墙添加放行规则
> 第一种解决方法：防火墙添加放行规则
> 
> firewall规则：
> 
> ```plain
> firewall-cmd --direct --permanent --add-rule ipv4 filter INPUT 0 --in-interface eth0 --destination 224.0.0.18 --protocol vrrp -j ACCEPT
> firewall-cmd --direct --permanent --add-rule ipv4 filter INPUT 0 --in-interface eth1 --destination 224.0.0.18 --protocol vrrp -j ACCEPT
> systemctl reload firewalld
> ```
> 
> iptables规则：
> 
> ```plain
> iptables -I INPUT -i eth0 -d 224.0.0.0/8 -p vrrp -j ACCEPT
> iptables -I OUTPUT -o eth0 -d 224.0.0.0/8 -p vrrp -j ACCEPT
> ```
> 

> [!info]- 使用单播地址而不是组播地址
> 第二种解决方法：使用单播地址而不是组播地址
> 
> 主服务器配置：
> 
> ```plain
> global_defs {
>     router_id lb-5
> }
> 
> vrrp_instance VI_1 {
>     state MASTER
>         interface eth0
>         virtual_router_id 50
>         priority 150
>         advert_int 1
>         authentication {
>             auth_type PASS
>             auth_pass 1111
>         }
>         unicast_src_ip 10.0.0.5
>         unicast_peer {
>             10.0.0.6
>         }
>         virtual_ipaddress {
>             10.0.0.3
>         }
> }
> ```
> 
> 备服务器配置：
> 
> ```plain
> global_defs {
>     router_id lb-6
> }
> 
> vrrp_instance VI_1 {
>     state BACKUP 
>         interface eth0
>         virtual_router_id 50
>         priority 100
>         advert_int 1
>         authentication {
>             auth_type PASS
>             auth_pass 1111
>         }
>         unicast_src_ip 10.0.0.6
>         unicast_peer {
>             10.0.0.5
>         }        
>         virtual_ipaddress {
>             10.0.0.3
>         }
> }
> ```
> 
> 以上两种方法都只是预防，仍然不能保证一定不会出现脑裂现象，我们还可以自己编写放脑裂脚本，然后在keepalived启动的时候调用这个脚本，而脚本的内容就是备服务器定时监测主服务器和VIP的情况，当发生脑裂式，keealived备服务器自己杀死自己的进程。
> 

> [!info]- 防脑裂脚本
> 
> 
> 监控思路：
> 
> 对于备服务器：
> 1.备份服务器定期检查主服务器上的nginx是否工作正常
> 2.备份服务器定期检查自己身上是否有VIP
> 3.如果同时满足以下条件，自己却还有VIP则认为脑裂了
>   \- 主服务器的NGINX工作正常
>   \- 主服务器有VIP
>   \- 备份服务器有VIP
> 4.如果发生了脑裂，备份服务器自己杀死自己的keepalived
> 5.将结果通知管理员
> 
> 备服务器脚本编写：有问题
> 
> ```plain
> #!/bin/bash 
> backup_status=$(ip a|grep '10.0.0.3'|wc -l)
> #1.如果备服务器有VIP
> if [ $backup_status -eq 1 ];then
>    #2.检查主服务器是否有VIP
>    master_status=$(ssh 10.0.0.5 "ip a|grep '10.0.0.3'"|wc -l)
>    #3.如果主服务器有VIP，发生脑裂了
>    if [ $master_status -eq 1 ];then
>       echo "$(date +%M:%S) ==> ha is bad"  >> /tmp/vip.txt
> 	  #4.手动删除IP
>       sleep 2
> 	  /usr/sbin/ip addr del 10.0.0.3/32 dev eth0 >> /tmp/ttt.txt 2>&1
> 	  #5.继续检测10次
> 	  for i in {1..10}
> 	  do
> 		  #6.继续检查主是否还活着
> 	      master_status=$(ssh 10.0.0.5 "ip a|grep '10.0.0.3'"|wc -l)
> 		  if [ $master_status -eq 1 ];then
> 		     #7.如果主还活着，什么都不做，进行下一次检查
> 		     sleep 5
>              continue
> 		  else
> 		     #8.如果主的死了，我再次把我的keepalived启动
> 		     systemctl restart keepalived
>              exit
> 		  fi
> 	  done
>    fi
> fi
> ```
> 
> 备服务器keepalived调用：
> 
> ```plain
> cat keepalived.conf 
> global_defs {
>     router_id lb-6
> }
> 
> #1.定义脚本
> vrrp_script check_brain {
>     script "/etc/keepalived/check_vip.sh"
>     interval 5
> }
> 
> vrrp_instance VI_1 {
>     state BACKUP 
>     interface eth0
>     virtual_router_id 50
>     priority 100
>     advert_int 1
>     
>     authentication {
>         auth_type PASS
>         auth_pass 1111
>     }
>     virtual_ipaddress {
>         10.0.0.3
>     }
> 	  
> 	#2.启动时调用脚本
>     track_script {
>         check_brain
>     }
> }
> ```
> 

> [!info]- nginx挂了，防止keepalived还提供服务
> 
> 主服务器检查nginx状态
> 
> 问题现象：
> 
> 刚才的脚本解决了备服务器抢占VIP的问题，但是还有一种特殊情况，那就是主服务器自己的nginx已经挂了，但是keepalived还活着，此时虽然VIP存在，但是已经不能正常对外提供服务器，所以主服务器也需要编写脚本来解决这种问题：
> 
> 解决思路：
> 
> 对于主服务器：
> 1.如果自己的nginx已经挂了，但是keepalived还活着，则尝试重启2次nginx
> 2.如果重启2次nginx依然失败，则杀掉自己的keepalived进程，放弃主服务器角色
> 
> 主服务器监控脚本：
> 
> ```plain
> cat > /etc/keepalived/check_web.sh << 'EOF'
> #!/bin/bash
> 
> nginx_status=$(systemctl is-active nginx|grep "active"|wc -l)
> 
> if [ $nginx_status -eq 0 ];then
>    systemctl start nginx
>    if [ $? -ne 0 ];then
>       echo "$(date +%M:%S) ==> ha is bad"  >> /tmp/vip.txt
>       systemctl stop keepalived
>    fi
> fi
> EOF
> ```
> 
> 主服务器的keepalived配置文件：
> 
> ```plain
> cat /etc/keepalived/keepalived.conf 
> global_defs {
>     router_id lb-5
> }
> 
> vrrp_script check_web {
>     script "/etc/keepalived/check_web.sh"
>     interval 5
>     weight 50
> }
> 
> vrrp_instance VI_1 {
>     	state MASTER
>         interface eth0
>         virtual_router_id 50
>         priority 150
>         advert_int 1
>         authentication {
>             auth_type PASS
>             auth_pass 1111
>         }
>         virtual_ipaddress {
>             10.0.0.3
>         }
> 
> 	track_script {
>             check_web
>         }
> }
> ```


