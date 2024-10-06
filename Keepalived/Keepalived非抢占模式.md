---
tags:
  - Keepalived
---


> [!info]- 抢占模式需要什么条件
> 
> 
> 两边都是BACKUP
> 
> 在主这边添加nopreempt

> [!info]- 主的配置
> 
> 
> ```shell
> global_defs {
>     router_id lb-5
> }
> 
> vrrp_script check_brain {
>     script "/etc/keepalived/check_vip.sh"
>     interval 5
> }
> 
> vrrp_instance VI_1 {
>     state BACKUP
>     interface eth0
>     virtual_router_id 50
>     priority 150
>     nopreempt
>     advert_int 1
>     authentication {
>         auth_type PASS
>         auth_pass 1111
>     }
>     virtual_ipaddress {
>         10.0.0.3
>     }
> 
>     #track_script {
>     #    check_brain
>     #}
> }
> ```
> 

> [!info]- 备的配置
> 
> 
> ```plain
> global_defs {
>     router_id lb-6
> }
> 
> vrrp_script check_brain {
>     script "/etc/keepalived/check_master.sh"
>     interval 5
> }
> 
> vrrp_instance VI_1 {
>     state BACKUP 
>     interface eth0
>     virtual_router_id 50
>     priority 100
>     advert_int 1
>     authentication {
>         auth_type PASS
>         auth_pass 1111
>     }
> 
>     #track_script {
>     #    check_brain
>     #}
> 
>     virtual_ipaddress {
>         10.0.0.3
>     }
> }
> ```
> 