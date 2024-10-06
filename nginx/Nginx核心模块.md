---
tags:
  - Nginx/模块
---

- ~ 1.Nginx核心模块介绍

https://nginx.org/en/docs/ngx_core_module.html

- ~ 2.Nginx核心模块关键指令

```shell
Syntax:	user user [group];

Default:	

user nobody nobody;

Context:	main

---------------------------------------------

Syntax:	worker_connections number;

Default:	

worker_connections 512;

Context:	events

---------------------------------------------

Syntax:	pid file;

Default:	

pid logs/nginx.pid;

Context:	main

---------------------------------------------

Syntax:	worker_cpu_affinity cpumask ...;

worker_cpu_affinity auto [cpumask];

Default:	—

Context:	main

---------------------------------------------

Syntax:	events { ... }

Default:	—

Context:	main

---------------------------------------------

Syntax:	include file | mask;

Default:	—

Context:	any
```

- ~ 3.Nginx核心模块默认配置

```shell
user  nginx;

worker_processes  auto;


error_log  /var/log/nginx/error.log notice;

pid        /var/run/nginx.pid;



events {

​    worker_connections  1024;

}
```
