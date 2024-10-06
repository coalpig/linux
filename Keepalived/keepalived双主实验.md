---
tags:
  - Keepalived
---

> [!config]- lb-5配置文件
> 
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
>         auth_type PASS
>         auth_pass 1111
>     }
>     virtual_ipaddress {
>         10.0.0.3/24 dev eth0 label eth0:1
>     }
> }
> 
> vrrp_instance VI_2 {
>     state BACKUP
>         interface eth0
>         virtual_router_id 100
>         priority 100
>         advert_int 1
>         authentication {
>             auth_type PASS
>             auth_pass 1111
>         }
>     virtual_ipaddress {
>         10.0.0.4/24 dev eth0 label eth0:2
>     }
> }
> ```

> [!config]- 配置文件
> 
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
>     virtual_ipaddress {
>         10.0.0.3/24 dev eth0 label eth0:1
>     }
> }
> 
> vrrp_instance VI_2 {
>     state MASTER
>         interface eth0
>         virtual_router_id 100
>         priority 150 
>         advert_int 1
>         authentication {
>             auth_type PASS
>             auth_pass 1111
>         }   
>     virtual_ipaddress {
>         10.0.0.4/24 dev eth0 label eth0:2
>     }   
> }
> ```
> 

> [!systemd]
> 重启keepalived并观察现象
> 
> ```plain
> systemctl restart keepalived
> ```
