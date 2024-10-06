
## 1.部署gitlab

```
version: '3'
services:
  gitlab:
    image: 'gitlab/gitlab-ce:latest'
    restart: always
    container_name: gitlab-ce
    privileged: true
    environment:
      - GITLAB_OMNIBUS_CONFIG=external_url 'http://10.0.0.11'
      - TZ=Asia/Shanghai
    ports:
      - '8080:80'
      - '2222:22'
    volumes:
      - '/data/gitlab/config:/etc/gitlab'
      - '/data/gitlab/logs:/var/log/gitlab'
      - '/data/gitlab/data:/var/opt/gitlab'
```

## 2.重置账号密码

```
docker exec -it gitlab-ce /bin/bash
gitlab-rails console
user = User.where(username: 'root').first
user.password = 'admin-123'
user.save!
exit
```

## 3.优化配置

默认启动的服务

```
root@gitlab:/# gitlab-ctl status
run: alertmanager: (pid 346) 456s; run: log: (pid 345) 456s
run: gitaly: (pid 287) 462s; run: log: (pid 286) 462s
run: gitlab-exporter: (pid 350) 456s; run: log: (pid 349) 456s
run: gitlab-workhorse: (pid 285) 462s; run: log: (pid 284) 462s
run: grafana: (pid 597) 342s; run: log: (pid 594) 342s
run: logrotate: (pid 289) 462s; run: log: (pid 288) 462s
run: nginx: (pid 356) 456s; run: log: (pid 355) 456s
run: postgres-exporter: (pid 348) 456s; run: log: (pid 347) 456s
run: postgresql: (pid 277) 462s; run: log: (pid 276) 462s
run: prometheus: (pid 354) 456s; run: log: (pid 353) 456s
run: puma: (pid 279) 462s; run: log: (pid 278) 462s
run: redis: (pid 281) 462s; run: log: (pid 280) 462s
run: redis-exporter: (pid 352) 456s; run: log: (pid 351) 456s
run: sidekiq: (pid 283) 462s; run: log: (pid 282) 462s
run: sshd: (pid 31) 473s; run: log: (pid 30) 473s
```

优化配置:

```
#进入容器内
docker exec -it gitlab /bin/bash

#修改配置
root@0f5d9714bddb:/# cd /etc/gitlab
root@0f5d9714bddb:/etc/gitlab# vi gitlab.rb
gitlab_rails['gitlab_shell_ssh_port'] = 2222
alertmanager['enable'] = false
grafana['enable'] = false
prometheus['enable'] = false
node_exporter['enable'] = false
redis_exporter['enable'] = false
postgres_exporter['enable'] = false
pgbouncer_exporter['enable'] = false
gitlab_exporter['enable'] = false

#修改后重新载入
root@0f5d9714bddb:/etc/gitlab# gitlab-ctl reconfigure

#再次查看
root@0f5d9714bddb:/etc/gitlab# gitlab-ctl status
run: gitaly: (pid 1247) 627s; run: log: (pid 612) 780s
run: gitlab-workhorse: (pid 1228) 628s; run: log: (pid 879) 726s
run: logrotate: (pid 475) 796s; run: log: (pid 489) 793s
run: nginx: (pid 2163) 405s; run: log: (pid 899) 721s
run: postgresql: (pid 639) 777s; run: log: (pid 669) 774s
run: puma: (pid 3076) 311s; run: log: (pid 831) 739s
run: redis: (pid 492) 790s; run: log: (pid 510) 787s
run: sidekiq: (pid 3058) 318s; run: log: (pid 851) 733s
run: sshd: (pid 35) 807s; run: log: (pid 34) 807s
```

## 4.遇到的坑

```
我们容器里的gitlab是22端口，映射出来是2222端口，但是gitlab配置文件里的配置还是22端口，这就导致从容器外面克隆代码的时候会出现需要密码的情况。
这种情况需要我们去修改gitlab的配置文件，让其ssh使用2222端口。
修改后的配置如下：
gitlab_rails['gitlab_shell_ssh_port'] = 2222

修改后再重新加载配置：
gitlab-ctl reconfigure
```
