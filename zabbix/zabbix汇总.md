# 第1章 监控知识基本概述

## 1.为什么要使用监控

1.对系统不间断实时监控
2.实时反馈系统当前状态
3.保证服务可靠性安全性
4.保证业务持续稳定运行

## 2.流行的监控工具

1.Zabbix（物理服务器）
2.Prometheus（普罗米修斯， Docker、 K8s）

## 3.如果去到一家新公司，如何入手监控

1.硬件监控 路由器、交换机、防火墙
2.系统监控 CPU、内存、磁盘、网络、进程、 TCP
3.服务监控 nginx、 php、 tomcat、 redis、 memcache、 mysql
4.WEB 监控 请求时间、响应时间、加载时间、
5.日志监控 ELk（收集、存储、分析、展示） 日志易
6.安全监控 Firewalld、 WAF(Nginx+lua)、安全宝、牛盾云、安全狗
7.网络监控 smokeping 多机房
8.业务监控 活动引入多少流量、产生多少注册量、带来多大价值

# 第2章 单机时代如何监控

CPU 监控命令: w、 top、 htop、 glances

内存监控命令: free

磁盘监控命令: df、 iotop

网络监控命令: ifconfig、 route、 glances、 iftop、 nethogs、 netstat

# 第3章 zabbix 监控快速安装

## 1.官方网站

 https://www.zabbix.com/cn/

## 2.配置zabbix仓库

```bash
[root@m-61 ~]# rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
[root@m-61 ~]# sed -i 's#repo.zabbix.com#mirrors.tuna.tsinghua.edu.cn/zabbix#g' /etc/yum.repos.d/zabbix.repo
```

## 3.安装 Zabbix 程序包，以及 MySQL、 Zabbix-agent

```bash
[root@m-61 ~]# yum install -y zabbix-server-mysql zabbix-web-mysql zabbix-agent mariadb-server
[root@m-61 ~]# systemctl start mariadb.service && systemctl enable mariadb.service
```

## 4.创建 Zabbix 数据库以及用户

```bash
[root@m-61 ~]# mysqladmin password 123456
[root@m-61 ~]# mysql -uroot -p123456
MariaDB [(none)]> create database zabbix character set utf8 collate utf8_bin;
MariaDB [(none)]> grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';
MariaDB [(none)]> flush privileges;
```

## 5.导入 Zabbix 数据至数据库中

```bash
 [root@m-61 ~]# zcat /usr/share/doc/zabbix-server-mysql-4.0.11/create.sql.gz | mysql -uzabbix -pzabbix zabbix
```

## 6.编辑/etc/zabbix/zabbix_server.conf 文件，修改数据库配置

```bash
[root@m-61 ~]# grep "^[a-Z]" /etc/zabbix/zabbix_server.conf 
 ...............
 DBHost=localhost
 DBName=zabbix
 DBUser=zabbix
 DBPassword=zabbix
 ...............
```

## 7.启动 Zabbix 服务进程，并加入开机自启

```bash
[root@m-61 ~]# systemctl start zabbix-server.service 
[root@m-61 ~]# systemctl enable zabbix-server.service
```

## 8.修改时区

配置 Apache 的配置文件/etc/httpd/conf.d/zabbix.conf 

```bash
[root@m-61 ~]# grep "Shanghai" /etc/httpd/conf.d/zabbix.conf 
         php_value date.timezone Asia/Shanghai
```

## 9.重启 Apache Web 服务器

```bash
 [root@m-61 ~]# systemctl start httpd
```

# 第4章 WEB安装步骤

## 1.浏览器打开地址：http://10.0.1.61/zabbix/setup.php

![img](./attachments/1716349336869-1140b53b-95b9-498d-b8b3-da304a220649.webp)

## 2.检查依赖项是否存在异常

![img](./attachments/1716349336959-915ba380-8cb1-493b-9b5e-1836d6563e94.webp)

## 3.配置zabbix连接数据库

![img](./attachments/1716349336939-29b50a1b-74e0-40ff-b345-290ce973f3c5.webp)

## 4.配置 ZabbixServer 服务器的信息

![img](./attachments/1716349336871-c361ed2e-47c4-4185-aa26-0fe064f56c11.webp)

## 5.最终确认检查

![img](./attachments/1716349336848-ade3502c-cd48-46a8-944c-b10d503a492f.webp)

## 6.安装成功

提示已成功地安装了 Zabbix 前端。配置文件/etc/zabbix/web/zabbix.conf.php 被创建。![img](./attachments/1716349337208-a56db92c-0095-4d0d-95d2-997cddc0b897.webp)

## 7.登陆zabbix

默认登陆 ZabbixWeb 的用户名 Admin，密码 zabbix![img](./attachments/1716349337208-a1343b03-3d49-4af4-afad-9d49b23cef38.webp)

## 8.调整字符集为中文

![img](./attachments/1716349337205-266e88f0-329a-4515-b813-e9ebaa77eb55.webp)![img](./attachments/1716349337290-880d9d5c-7658-4cb8-b417-7248ec3cfeec.webp)

## 9.修复中文乱码

打开图形之后会发现语言为乱码，原因是缺少字体![img](./attachments/1716349337341-51ed2ec3-92f5-4281-b60f-8448e26151a6.webp)解决方法:安装字体并替换现有字体

```bash
[root@m-61 ~]# yum install wqy-microhei-fonts -y
[root@m-61 ~]# cp /usr/share/fonts/wqy-microhei/wqy-microhei.ttc /usr/share/zabbix/assets/fonts/graphfont.ttf
```

再次刷新发现已经变成中文了![img](./attachments/1716349337537-c0703eca-c6c5-414c-8a2f-f00dc97ebf2a.webp)

# 第5章 Zabbix 监控基础架构

zabbix-agent(数据采集)—>zabbix-server(数据分析|报警)—> 数据库(数据存储)<—zabbix web(数据展示)![img](./attachments/1716349337521-2bb53738-eb04-40ef-9609-bbfc12847a58.png)

# 第6章 zabbix 快速监控主机

## 1.安装zabbix-agent

```bash
[root@web-7 ~]# rpm -ivh https://mirror.tuna.tsinghua.edu.cn/zabbix/zabbix/4.0/rhel/7/x86_64/zabbix-agent-4.0.11-1.el7.x86_64.rpm
```

## 2.配置zabbix-agent

官网配置文件解释:

https://www.zabbix.com/documentation/4.0/zh/manual/appendix/config/zabbix_agentd

配置命令:

```bash
[root@web-7 ~]# grep "^[a-Z]" /etc/zabbix/zabbix_agentd.conf    
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=10.0.0.61
Include=/etc/zabbix/zabbix_agentd.d/*.conf
```

## 3.启动zabbix-agent并检查

```bash
[root@web-7 ~]# systemctl start zabbix-agent.service 
[root@web-7 ~]# systemctl enable zabbix-agent.service
[root@web-7 ~]# netstat -lntup|grep 10050
tcp        0      0 0.0.0.0:10050           0.0.0.0:*               LISTEN      10351/zabbix_agentd 
tcp6       0      0 :::10050                :::*                    LISTEN      10351/zabbix_agentd
```

## 4.zabbix-web界面，添加主机

![img](./attachments/1716349337636-46e6caf4-c4ad-40ab-b91e-1a9780827b5e.webp)![img](./attachments/1716349337675-14ee0797-d79f-4d3f-9f13-4cf870aa1d6a.webp)![img](./attachments/1716349337815-be50e80b-24c5-490f-923c-fc7a7b57f0b3.webp)

# 第7章 自定义监控主机小试身手

## 1.监控需求

监控TCP11种状态集

## 2.命令行实现

```bash
[root@web-7 ~]# netstat -ant|grep -c TIME_WAIT
55
[root@web-7 ~]# netstat -ant|grep -c LISTEN
12
```

## 3.编写zabbix监控文件(传参形式)

```bash
[root@web-7 ~]# cat /etc/zabbix/zabbix_agentd.d/tcp_status.conf 
UserParameter=tcp_state[*],netstat -ant|grep -c $1
root@web-7 ~]# systemctl restart zabbix-agent.service
```

## 4.server端进行测试

```bash
[root@m-61 ~]# rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
[root@m-61 ~]# yum install zabbix-get.x86_64 -y 
[root@m-61 ~]# zabbix_get -s 10.0.1.7 -k tcp_state[TIME_WAIT]
51
[root@m-61 ~]# zabbix_get -s 10.0.1.7 -k tcp_state[LISTEN]   
12
```

## 5.web端添加

![img](./attachments/1716349337923-c45f444c-63d1-4779-b730-70f8abe0b47f.webp)![img](./attachments/1716349337961-e393ad4c-142b-4119-b4c8-ee3e2d51c170.webp)

## 6.克隆监控项

由于TCP有多种状态，需要添加多个监控项，我们可以使用克隆快速达到创建的效果![img](./attachments/1716349338143-8a80ff0b-b755-4a2d-a773-5c88ef605c6b.webp)![img](./attachments/1716349337996-82c4cba2-f0cc-4037-b311-0a6b85a88001.webp)![img](./attachments/1716349338130-409055a9-fbcd-40a0-b3b3-4098af2b7ad4.webp)其他的状态依次添加即可

## 7.创建图形

![img](./attachments/1716349338244-5d10894b-fa37-4fa9-90f4-f03bb7c51844.webp)

## 8.查看图形

![img](./attachments/1716349338366-743e755f-9960-4714-8db1-87b794095b4a.webp)

## 9.设置触发器

![img](./attachments/1716349338384-882b3e0c-163f-4486-9829-7bfd710bc112.webp)![img](./attachments/1716349338508-16272196-af62-4361-9b6c-312dd3c60f2d.webp)![img](./attachments/1716349338593-ac62560f-3196-413d-82bb-caec1e6521a4.webp)![img](./attachments/1716349338650-62b3c055-53fa-47b9-9805-cab76662ee02.webp)

# 第8章 邮件报警

## 0.帮助说明

https://service.mail.qq.com/cgi-bin/help?subtype=1&&id=28&&no=369

## 1.定义发件人

![img](./attachments/1716349338719-17333eab-887c-4b4c-a7bc-aba895bae65e.webp)![img](./attachments/1716349338767-06b3e583-061b-4f61-882f-2e3fb9574466.webp)

## 2.定义收件人

![img](./attachments/1716349338871-a4164ae4-6cca-4c66-a448-7708a9cfafd1.webp)![img](./attachments/1716349339170-14be492c-c0a2-4993-acff-4fed8395f20e.webp)![img](./attachments/1716349339217-1f569fdf-4318-4b6b-9dcc-55be2cab4bdf.webp)

## 3.自定义报警内容

定制报警内容：https://www.zabbix.com/documentation/4.0/zh/manual/appendix/macros/supported_by_location参考博客

https://www.cnblogs.com/bixiaoyu/p/7302541.html

报警邮件标题可以使用默认信息，亦可使用如下中文报警内容

```bash
默认标题：
故障{TRIGGER.STATUS},服务器:{HOSTNAME1}发生: {TRIGGER.NAME}故障!

告警主机:{HOSTNAME1}
告警时间:{EVENT.DATE} {EVENT.TIME}
告警等级:{TRIGGER.SEVERITY}
告警信息: {TRIGGER.NAME}
告警项目:{TRIGGER.KEY1}
问题详情:{ITEM.NAME}:{ITEM.VALUE}
当前状态:{TRIGGER.STATUS}:{ITEM.VALUE1}
事件ID:{EVENT.ID}
```

恢复警告

```bash
恢复标题：
恢复{TRIGGER.STATUS}, 服务器:{HOSTNAME1}: {TRIGGER.NAME}已恢复!

恢复信息：
告警主机:{HOSTNAME1}
告警时间:{EVENT.DATE} {EVENT.TIME}
告警等级:{TRIGGER.SEVERITY}
告警信息: {TRIGGER.NAME}
告警项目:{TRIGGER.KEY1}
问题详情:{ITEM.NAME}:{ITEM.VALUE}
当前状态:{TRIGGER.STATUS}:{ITEM.VALUE1}
事件ID:{EVENT.ID}
```

# 第9章 微信报警

## 0.参考地址


![](attachments/weixin.sh)


```bash
https://open.work.weixin.qq.com/wwopen/devtool/interface?doc_id=15645
https://work.weixin.qq.com/api/doc/90001/90143/91201
https://work.weixin.qq.com/api/doc/90001/90143/90372
```

## 1.查看配置文件里的脚本目录路径

```bash
[root@m-61 ~]# grep "^AlertScriptsPath" /etc/zabbix/zabbix_server.conf
AlertScriptsPath=/usr/lib/zabbix/alertscripts
```

## 2.将weixin.py放在zabbix特定目录

```bash
[root@m-61 /usr/lib/zabbix/alertscripts]# ll
总用量 4
-rwxr-xr-x 1 root root 1344 8月   7 21:58 weixin.py
```

## 3.配置发信人

![img](./attachments/1716349339338-cdcce8e9-dd67-4e08-a0c1-563f2f5d4e2a.webp)![img](./attachments/1716349339241-230ed7fa-dd96-47f5-855c-d72935d9836e.webp)

## 4.配置收信人

![img](./attachments/1716349339332-2fcb93da-1b86-433c-8db9-22788e5eb37a.webp)

## 5.登陆企业微信公众号添加账户

https://work.weixin.qq.com/wework_admin/loginpage_wx1.登陆后在企业号上新建应用 ![img](./attachments/1716349339574-a3af9aef-093b-41f2-a3ef-cfce9923220f.webp)2.上传logo，填写应用名称 ，应用介绍等![img](./attachments/1716349339743-ae1c2c10-14f8-4f22-b0eb-b7f13a53b0b5.webp)3.查看启动应用同时会生成应用的AgentId以及Secret，这个在后面步骤会有用![img](./attachments/1716349339772-d3fe70e2-18ee-4b57-821b-65a0ed6eb39c.webp)4.接口调用测试

https://developer.work.weixin.qq.com/devtool/interface/alone?id=10167

![img](./attachments/1716349339735-f6a4243b-9aac-4c44-8183-33f4d9b2a010.webp)这里的corpid为公司ID![img](./attachments/1716349339739-5c2dc9df-c880-468c-b309-c027beabc01f.webp)Corpsecret就是刚才创建应用生成的Secrt，确认没问题填写进去然后下一步如果没问题会显示200状态码![img](./attachments/1716349339938-bf2e2420-6477-4dfb-b4d2-059b55b1741f.webp)

## 6.添加成员

![img](./attachments/1716349340191-f61718d7-9d44-45b0-8661-7804804a5460.webp)

## 7.关注公众号

![img](./attachments/1716349340048-bd28e05a-1971-4ee6-9a4c-d7e2d029fd5b.webp)

## 8.查看自己的账号

![img](./attachments/1716349340118-577454ac-ae3f-40f2-85ed-76bc21c188f4.webp)

## 9.修改脚本里的信息

```bash
[root@m-61 /usr/lib/zabbix/alertscripts]# cat weixin.py 
..............
corpid='微信企业号corpid'
appsecret='应用的Secret'
agentid=应用的id
..............
```

## 10.发信测试

```bash
[root@m-61 /usr/lib/zabbix/alertscripts]# python  weixin.py  你的账号  '发信测试'  ‘微信测试消息’
```

## 11.微信号上查看

![img](./attachments/1716349340132-2e0b426a-6bfb-4510-90c5-2976b59ba79c.webp)

## 12.发送到整个微信组

虽然我们实现了发送到单个用户的功能，但是如果我们的用户比较多，这样还是麻烦的，不过我们可以发送到整个组，其实脚本里已经预留好了配置，只不过默认注释了。将脚本修改为以下内容，注释掉用户，打开组设置

```bash
#!/usr/bin/env python

import requests
import sys
import os
import json
import logging

logging.basicConfig(level = logging.DEBUG, format = '%(asctime)s, %(filename)s, %(levelname)s, %(message)s',
                datefmt = '%a, %d %b %Y %H:%M:%S',
                filename = os.path.join('/tmp','weixin.log'),
                filemode = 'a')
corpid='wwd26fdfb9940e7efa'
appsecret='Btg89FnZfMu0k7l6b4iagmAR5Z9TCgKknYbx-SMQvmg'
agentid=1000005

token_url='https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=' + corpid + '&corpsecret=' + appsecret
req=requests.get(token_url)
accesstoken=req.json()['access_token']

msgsend_url='https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=' + accesstoken

#touser=sys.argv[1]
toparty=sys.argv[1]
subject=sys.argv[2]
message=sys.argv[2] + "\n\n" +sys.argv[3]

params={
        #"touser": touser,
        "toparty": toparty,
        "msgtype": "text",
        "agentid": agentid,
        "text": {
                "content": message
        },
        "safe":0
}

req=requests.post(msgsend_url, data=json.dumps(params))

logging.info('sendto:' + toparty + ';;subject:' + subject + ';;message:' + message)
```

## 12.随机发送到指定用户玩笑脚本

```bash
#!/bin/bash 
num=$(echo $(($RANDOM%28+1)))
name=$(sed -n "${num}p" name.txt)
ok_boy=$(grep -v "${name}" name.txt)

for ok in ${ok_boy}
do
  python  weixin.py ${ok}  "$1"  "$2"
done
```

## 13.bash脚本发送微信

```bash
cat > weixin.sh << 'EOF'
#!/bin/bash

#需要将下列信息修改为自己注册的企业微信信息
#应用ID
agentid='xxxxxx'
#secretID
corpsecret='xxxxxxx'
#企业ID
corpid='xxxxxxxx'

#接受者的账户，由zabbix传入
#user=$1
group=$1
#报警邮件标题，由zabbix传入
title=$2
#报警邮件内容，由zabbix传入
message=$3

#获取token信息，需要在链接里带入ID
token=$(curl -s -X GET "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=${corpid}&corpsecret=${corpsecret}"|awk -F \" '{print $10}')

#构造语句执行发送动作
curl -s -H "Content-Type: application/json" -X POST "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=${token}" -d'
{
   "toparty" : "'"${group}"'",
   "msgtype" : "text",
   "agentid" : '"${agentid}"',
   "text" : {
       "content" : "'"${title}\n\n${message}"'"
   },
   "safe":0
}' >> /tmp/weixin.log

#将报警信息写入日志文件
echo -e "\n报警时间:$(date +%F-%H:%M)\n报警标题:${title}\n报警内容:${message}" >> /tmp/weixin.log
EOF
```

# 第10章 钉钉报警

## 1.创建钉钉机器人

https://open.dingtalk.com/document/orgapp/custom-robots-send-group-messages

第一步：创建自定义机器人

![img](./attachments/1716349340367-68f4445e-ca93-4941-944d-40f52fa6b77b.png)

第二步：配置关键词

![img](./attachments/1716349340634-1a31fb49-d4e7-4329-ab29-f4a3a50a6d35.png)

第三步：记录webhook值

![img](./attachments/1716349340704-05ac9ee0-8fa5-4b4e-8fbc-af174a620d77.png)

## 2.编写报警脚本



![](attachments/dingding.sh)


```bash
cat > dingding.py << 'EOF'
#!/usr/bin/python2.7
#coding:utf-8
#zabbix钉钉报警
import requests,json,sys,os,datetime
webhook="https://oapi.dingtalk.com/robot/send?access_token=xxxxxxxxxxxxxxxxxxxx" 
user=sys.argv[1]
text=sys.argv[2] + "\n\n" + sys.argv[3]
data={
    "msgtype": "text",
    "text": {
        "content": text
    },
    "at": {
        "atMobiles": [
            user
        ],
        "isAtAll": False
    }
}
headers = {'Content-Type': 'application/json'}
x=requests.post(url=webhook,data=json.dumps(data),headers=headers)
if os.path.exists("/tmp/dingding.log"):
    f=open("/tmp/dingding.log","a+")
else:
    f=open("/tmp/dingding.log","w+")
f.write("\n"+"--"*30)
if x.json()["errcode"] == 0:
    f.write("\n"+str(datetime.datetime.now())+"    "+str(user)+"    "+"发送成功"+"\n"+str(text))
    f.close()
else:
    f.write("\n"+str(datetime.datetime.now()) + "    " + str(user) + "    " + "发送失败" + "\n" + str(text))
    f.close()
EOF
```

shell脚本：

```bash
#!/bin/bash
#webhook地址
webhook='570140d862cb97f2d8d782cc37cfeeeddff4ed88c244b528d30db16769702a6d'

#接受者的手机号，由zabbix传入
user=$1
#报警邮件标题，由zabbix传入
title=$2
#报警邮件内容，由zabbix传入
message=$3

#构造语句执行发送动作
curl -s -H "Content-Type: application/json" -X POST "https://oapi.dingtalk.com/robot/send?access_token=${webhook}" \
-d'{
    "msgtype": "text", 
    "text": {
        "content": "'"${title}\n\n${message}\n\nkeywords:zabbix"'"
    }, 
    "at": {
        "atMobiles": [
            "'"${user}"'"
        ], 
    }
}' >> /tmp/dingding.log 2>&1

#将报警信息写入日志文件
echo -e "\n报警时间:$(date +%F-%H:%M)\n报警标题:${title}\n报警内容:${message}" >> /tmp/dingding.log
```

## 3.测试发送

./dingding.py 15321312624 这是标题 zabbix故障

![img](./attachments/1716349340648-6d39b7bc-d102-47f8-b315-c9a84f9cc45f.png)

## 4.web页面配置

和微信脚本配置步骤一样，这里不再叙述

# 第11章 自定义模版

## 1.监控TCP11种状态

编写zabbix配置文件

```bash
[root@web-7 /etc/zabbix/zabbix_agentd.d]# cat zbx_tcp.conf 
UserParameter=ESTABLISHED,netstat -ant|grep  -c 'ESTABLISHED'
UserParameter=SYN_SENT,netstat -ant|grep  -c 'SYN_SENT'
UserParameter=SYN_RECV,netstat -ant|grep  -c 'SYN_RECV'
UserParameter=FIN_WAIT1,netstat -ant|grep  -c 'FIN_WAIT1'
UserParameter=FIN_WAIT2,netstat -ant|grep  -c 'FIN_WAIT2'
UserParameter=TIME_WAIT,netstat -ant|grep  -c 'TIME_WAIT'
UserParameter=CLOSE,netstat -ant|grep  -c 'CLOSE'
UserParameter=CLOSE_WAIT,netstat -ant|grep  -c 'CLOSE_WAIT'
UserParameter=LAST_ACK,netstat -ant|grep  -c 'LAST_ACK'
UserParameter=LISTEN,netstat -ant|grep  -c 'LISTEN'
UserParameter=CLOSING,netstat -ant|grep  -c 'CLOSING'
```

## 2.重启zabbix-agent

[root@web-7 ~]# systemctl restart zabbix-agent.service 

## 3.测试监控项

使用zabbix-get命令测试

```bash
[root@m-61 ~]# yum install zabbix-get.x86_64 -y
[root@m-61 ~]# zabbix_get -s 10.0.1.7 -k ESTABLISHED
2
[root@m-61 ~]# zabbix_get -s 10.0.1.7 -k LISTEN
12
```

## 3.导入模版文件

![img](./attachments/1716349340715-9a756dfa-1922-4835-8c21-15de690af0f3.webp)![img](./attachments/1716349340808-d4a65696-cced-4bc0-9991-892675fecc4e.webp)![img](./attachments/1716349341145-64c483bc-7254-43d0-a939-7688486f27bc.webp)

## 4.主机关联模版文件

![img](./attachments/1716349341118-bc6c64a4-59df-4f6a-a65a-924b5d44b394.webp)![img](./attachments/1716349341152-06d738fd-ecc0-466c-9033-59c8e84912ea.webp)

## 5.查看最新数据

![img](./attachments/1716349341196-1712cade-8dbf-47a3-b641-3342ca8c24d5.webp)

## 6.查看图形

![img](./attachments/1716349341536-a0498e42-8517-4ff5-bd96-121c9a413ed6.webp)

# 第12章 自定义模版监控nginx状态

## 1.开启监控页面并访问测试

```bash
[root@web-7 ~]# cat /etc/nginx/conf.d/status.conf 
server {
   listen 80;
   server_name localhost;
   location /nginx_status {
       stub_status on;
       access_log off;
   }
}

[root@web-7 ~]# curl 127.0.0.1/nginx_status/
Active connections: 1 
server accepts handled requests
 6 6 6 
Reading: 0 Writing: 1 Waiting: 0
```

## 2.准备nginx监控状态脚本

```bash
[root@web-7 /etc/zabbix/zabbix_agentd.d]# cat nginx_monitor.sh 
#!/bin/bash
NGINX_COMMAND=$1
CACHEFILE="/tmp/nginx_status.txt"
CMD="/usr/bin/curl http://127.0.0.1/nginx_status/"
if [ ! -f $CACHEFILE  ];then
   $CMD >$CACHEFILE 2>/dev/null
fi
# Check and run the script
TIMEFLM=`stat -c %Y $CACHEFILE`
TIMENOW=`date +%s`

if [ `expr $TIMENOW - $TIMEFLM` -gt 60 ]; then
    rm -f $CACHEFILE
fi
if [ ! -f $CACHEFILE  ];then
   $CMD >$CACHEFILE 2>/dev/null
fi

nginx_active(){
         grep 'Active' $CACHEFILE| awk '{print $NF}'
         exit 0;
}
nginx_reading(){
         grep 'Reading' $CACHEFILE| awk '{print $2}'
         exit 0;
}
nginx_writing(){
         grep 'Writing' $CACHEFILE | awk '{print $4}'
         exit 0;
}
nginx_waiting(){
         grep 'Waiting' $CACHEFILE| awk '{print $6}'
         exit 0;
}
nginx_accepts(){
         awk NR==3 $CACHEFILE| awk '{print $1}' 
         exit 0;
}
nginx_handled(){
         awk NR==3 $CACHEFILE| awk '{print $2}' 
         exit 0;
}
nginx_requests(){
         awk NR==3 $CACHEFILE| awk '{print $3}'
         exit 0;
}

case $NGINX_COMMAND in
    active)
        nginx_active;
        ;;
    reading)
        nginx_reading;
        ;;
    writing)
        nginx_writing;
        ;;
    waiting)
        nginx_waiting;
        ;;
    accepts)
        nginx_accepts;
        ;;
    handled)
        nginx_handled;
        ;;
    requests)
        nginx_requests;
        ;;
    *)
echo 'Invalid credentials';
exit 2;
esac
```

## 3.编写zabbix监控配置文件

```bash
[root@web-7 ~]# cat /etc/zabbix/zabbix_agentd.d/nginx_status.conf
UserParameter=nginx_status[*],/bin/bash /etc/zabbix/zabbix_agentd.d/nginx_monitor.sh $1

[root@web-7 ~]# systemctl restart zabbix-agent.service
```

## 4.使用zabbix_get取值

```bash
[root@m-61 ~]# zabbix_get -s 10.0.1.7 -k nginx_status[accepts]
7
```

## 5.导入模版

![img](./attachments/1716349341568-8b6bb2f8-4f93-400b-a78a-ec2040eade3d.webp)

## 6.链接模版

![img](./attachments/1716349341563-c0f772a4-60bf-4a4b-a409-f024ee843bfe.webp)

## 7.查看数据

![img](./attachments/1716349341626-baa06488-af12-4dca-a2e2-1c48393eef35.webp)

# 第13章 自定义模版监控php状态

## 1.开启监控页面

```bash
[root@web-7 ~]# tail -1 /etc/php-fpm.d/www.conf    
pm.status_path = /php_status

[root@web-7 ~]# cat /etc/nginx/conf.d/status.conf    
server {
   listen 80;
   server_name localhost;
   location /nginx_status {
       stub_status on;
       access_log off;
   }

   location /php_status {
       fastcgi_pass 127.0.0.1:9000;
       fastcgi_index index.php;
       fastcgi_param SCRIPT_FILENAME html$fastcgi_script_name;
       include fastcgi_params;
   }
}

[root@web-7 ~]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@web-7 ~]# systemctl restart nginx.service php-fpm.service
```

## 2.访问测试

```bash
[root@web-7 ~]# curl 127.0.0.1/php_status
pool:                 www
process manager:      dynamic
start time:           08/Aug/2019:22:31:27 +0800
start since:          37
accepted conn:        1
listen queue:         0
max listen queue:     0
listen queue len:     128
idle processes:       4
active processes:     1
total processes:      5
max active processes: 1
max children reached: 0
slow requests:        0
```

## 3.准备访问脚本

```bash
[root@web-7 ~]# cat /etc/zabbix/zabbix_agentd.d/fpm.sh 
#!/bin/bash
##################################
# Zabbix monitoring script
#
# php-fpm:
#  - anything available via FPM status page
#
##################################
# Contact:
#  vincent.viallet@gmail.com
##################################
# ChangeLog:
#  20100922     VV      initial creation
##################################

# Zabbix requested parameter
ZBX_REQ_DATA="$1"
ZBX_REQ_DATA_URL="$2"

# Nginx defaults
NGINX_STATUS_DEFAULT_URL="http://localhost/fpm/status"
WGET_BIN="/usr/bin/wget"

#
# Error handling:
#  - need to be displayable in Zabbix (avoid NOT_SUPPORTED)
#  - items need to be of type "float" (allow negative + float)
#
ERROR_NO_ACCESS_FILE="-0.91"
ERROR_NO_ACCESS="-0.92"
ERROR_WRONG_PARAM="-0.93"
ERROR_DATA="-0.94" # either can not connect /   bad host / bad port

# Handle host and port if non-default
if [ ! -z "$ZBX_REQ_DATA_URL" ]; then
  URL="$ZBX_REQ_DATA_URL"
else
  URL="$NGINX_STATUS_DEFAULT_URL"
fi

# save the nginx stats in a variable for future parsing
NGINX_STATS=$($WGET_BIN -q $URL -O - 2>/dev/null)

# error during retrieve
if [ $? -ne 0 -o -z "$NGINX_STATS" ]; then
  echo $ERROR_DATA
  exit 1
fi

# 
# Extract data from nginx stats
#
#RESULT=$(echo "$NGINX_STATS" | awk 'print $0;match($0, "^'"$ZBX_REQ_DATA"':[[:space:]]+(.*)", a) { print a[1] }')
#RESULT=$(echo "$NGINX_STATS" | grep "$ZBX_REQ_DATA" | awk -F : '{print $2}')
RESULT=$(echo "$NGINX_STATS" | awk -F : "{if(\$1==\"$ZBX_REQ_DATA\") print \$2}")
if [ $? -ne 0 -o -z "$RESULT" ]; then
    echo $ERROR_WRONG_PARAM
    exit 1
fi

echo $RESULT

exit 0

[root@web-7 ~]# bash /etc/zabbix/zabbix_agentd.d/fpm.sh "total processes" http://127.0.0.1/php_status
5
```

## 4.准备zabbix配置文件

```bash
[root@web-7 ~]# cat /etc/zabbix/zabbix_agentd.d/fpm.conf    
UserParameter=php-fpm[*],/etc/zabbix/zabbix_agentd.d/fpm.sh "$1" "$2"
[root@web-7 ~]# systemctl restart zabbix-agent.service
```

## 4.使用zabbix_get取值

```bash
[root@m-61 ~]# zabbix_get -s 10.0.1.7 -k php-fpm["total processes",http://127.0.0.1/php_status]
5
```

## 5.导入模版

导入之后需要修改一下模版里的宏配置![img](./attachments/1716349341664-734f1719-574d-4792-9901-30c8e31ba105.webp)

# 第14章 WEB监控

需求，监控页面状态码![img](./attachments/1716349342024-7b83a2e0-deda-408b-8a4f-474f3130422d.webp)![img](./attachments/1716349342024-c525be45-9302-4963-adc6-f715c9e7389e.webp)![img](./attachments/1716349342054-4141e0b2-879f-4810-9940-e15682783d82.webp)

# 

## 

# 第16章 percona模版监控mysql

## 1.安装php环境

percona需要php环境

```bash
[root@m-61 /data/soft]# yum install php php-mysql -y
```

## 2.下载软件

[📎percona-zabbix-templates-1.1.8-1.noarch.rpm](https://www.yuque.com/attachments/yuque/0/2024/rpm/830385/1722763290219-3ecbccb8-2c3d-4156-9d52-eeba9c4d81e2.rpm)

![img](./attachments/1716349344273-f9a36385-ef53-45a2-8bac-2633423a90c7.webp)![img](./attachments/1716349344417-da1ed73b-34fa-42e3-a2cf-295b22273bbd.webp)注意，安装完成后会有提示模版的路径位置

```bash
[root@m-61 ~]# cd /data/soft/
[root@m-61 /data/soft]# wget https://www.percona.com/downloads/percona-monitoring-plugins/percona-monitoring-plugins-1.1.8/binary/redhat/7/x86_64/percona-zabbix-templates-1.1.8-1.noarch.rpm
[root@m-61 /data/soft]# rpm -ivh percona-zabbix-templates-1.1.8-1.noarch.rpm 
警告：percona-zabbix-templates-1.1.8-1.noarch.rpm: 头V4 DSA/SHA1 Signature, 密钥 ID cd2efd2a: NOKEY
准备中...                          ################################# [100%]
正在升级/安装...
   1:percona-zabbix-templates-1.1.8-1 ################################# [100%]

Scripts are installed to /var/lib/zabbix/percona/scripts
Templates are installed to /var/lib/zabbix/percona/templates
```

## 3.查看目录

进入安装目录会发现有2个目录，一个是脚本目录，一个是模版目录

```bash
[root@m-61 ~]# cd /var/lib/zabbix/percona/
[root@m-61 /var/lib/zabbix/percona]# tree
.
├── scripts
│   ├── get_mysql_stats_wrapper.sh
│   └── ss_get_mysql_stats.php
└── templates
    ├── userparameter_percona_mysql.conf
    └── zabbix_agent_template_percona_mysql_server_ht_2.0.9-sver1.1.8.xml
```

其中脚本目录里有2个脚本，用来获取数据库信息

```bash
[root@m-61 /var/lib/zabbix/percona]# cd scripts/
[root@m-61 /var/lib/zabbix/percona/scripts]# ls
get_mysql_stats_wrapper.sh  ss_get_mysql_stats.php
```

## 4.修改get_mysql_stats_wrapper.sh

修改get_mysql_stats_wrapper数据库登陆信息第19行添加mysql账号密码

```bash
[root@m-61 v]# sed -n '19p' get_mysql_stats_wrapper.sh 
    RES=`HOME=~zabbix mysql -uroot -p123456 -e 'SHOW SLAVE STATUS\G' | egrep '(Slave_IO_Running|Slave_SQL_Running):' | awk -F: '{print $2}' | tr '\n'
```

## 5.修改ss_get_mysql_stats.php

```bash
[root@m-61 /var/lib/zabbix/percona/scripts]# sed -n '30,31p' ss_get_mysql_stats.php 
$mysql_user = 'root';
$mysql_pass = '123456';
```

## 6.复制自定义监控项配置文件到zabbix目录

```bash
[root@m-61 ~]# cd /var/lib/zabbix/percona/templates/
[root@m-61 /var/lib/zabbix/percona/templates]# cp userparameter_percona_mysql.conf /etc/zabbix/zabbix_agentd.d/
[root@m-61 /var/lib/zabbix/percona/templates]# cd /etc/zabbix/zabbix_agentd.d/
[root@m-61 /etc/zabbix/zabbix_agentd.d]# ls
userparameter_mysql.conf  userparameter_percona_mysql.conf
```

## 7.重启agent

```bash
[root@m-61 ~]# systemctl restart zabbix-agent 
```

## 8.测试key

```bash
[root@m-61 ~]# zabbix_get -s 10.0.1.61 -k MySQL.Sort-scan
16
```

## 9.导入模版

官方自带的模版有点问题，需要先装在2.x版本然后导出来，这里使用网友已经修改好的模版上传

![](attachments/zbx_percona_mysql_template%201.xml)

![img](./attachments/1716349344518-8c4e010b-7442-40cb-b95d-db8d2540cc4b.webp)

## 10.主机链接模版

![img](./attachments/1716349344454-5c4f8230-9db6-4e55-8318-b7d9f0f7962d.webp)

## xx.报错解决

查看监控发现没有数据显示不支持类型查看zabbix-server发现因为tmp的文件没有权限，因为刚才手动执行了脚本，所以文件属性是root，将文件删除后由zabbix自己创建解决问题报错日志如下：

```bash
2846:20190811:202708.785 item "Zabbix server:MySQL.State-init" became not supported: Value "rm: 无法删除"/tmp/localhost-mysql_cacti_stats.txt": 不允许的操作
0" of type "string" is not suitable for value type "Numeric (float)"
  2843:20190811:202709.787 item "Zabbix server:MySQL.State-locked" became not supported: Value "rm: 无法删除"/tmp/localhost-mysql_cacti_stats.txt": 不允许的操作
0" of type "string" is not suitable for value type "Numeric (float)"
  2844:20190811:202710.788 item "Zabbix server:MySQL.State-login" became not supported: Value "rm: 无法删除"/tmp/localhost-mysql_cacti_stats.txt": 不允许的操作
0" of type "string" is not suitable for value type "Numeric (float)"
```

# 第17章 自动发现和自动注册

## 1.自动发现

web页面操作![img](./attachments/1716349344720-8fd02153-402a-4058-9169-b50b96921326.webp)

![img](./attachments/1716349344872-aabfd54c-10a9-4ca7-bbc1-3f6c11cc64d8.webp)![img](./attachments/1716349344816-a972d898-c177-4cf7-914d-2eca163460d7.webp)![img](./attachments/1716349344982-81d9426e-df7c-443d-a1a2-0eccc462de30.webp)

## 2.自动注册

修改不同主机的zabbix-agent配置文件

```bash
#web-7
cat > /etc/zabbix/zabbix_agentd.conf << EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=10.0.0.61
ServerActive=10.0.0.61
Hostname=web-7
Include=/etc/zabbix/zabbix_agentd.d/*.conf
HostMetadata=web
EOF

#web-8
cat > /etc/zabbix/zabbix_agentd.conf << EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=10.0.0.61
ServerActive=10.0.0.61
Hostname=web-8
Include=/etc/zabbix/zabbix_agentd.d/*.conf
HostMetadata=web
EOF

#db-51
cat > /etc/zabbix/zabbix_agentd.conf << EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=10.0.0.61
ServerActive=10.0.0.61
Hostname=db-51
Include=/etc/zabbix/zabbix_agentd.d/*.conf
HostMetadata=db
EOF
```

web页面操作

![img](./attachments/1722829843814-f819d1c6-8832-4fb0-a5b7-1ed77290f20a.png)

![img](./attachments/1722829851707-46afd65e-6314-47a9-8026-a310cc05e911.png)

![img](./attachments/1722829857194-437b5909-232f-421b-ad5f-2ad5ae20d923.png)

![img](./attachments/1722829904631-ab27e389-c7ca-4746-a1c3-7e52ed0600cf.png)

![img](./attachments/1722829913248-9e6d361a-4388-4ee9-a891-384c9bebbd1b.png)

![img](./attachments/1722829878573-0d266090-774e-4678-85d1-88869768680f.png)

# 第18章 主动模式和被动模式

默认为被动模式：100个监控项要100个来回，要的时候才返回主动模式：100个监控项1个回合，将所需要的100个打包，然后一次发过去，发过去之后，客户端全部执行完再一次返回给服务端。

## 1.克隆模版

完全克隆原来被动模式的模版为主动模式![img](./attachments/1716349345353-4aeaeb97-a07f-4525-aae1-48134c92e76f.webp)![img](./attachments/1716349345609-aa2ab8f1-d647-448d-a3be-87be0867a537.webp)

## 2.修改克隆后的模版为主动模式

![img](./attachments/1716349345917-05acd1ad-c904-400b-b23d-927978a0b800.webp)![img](./attachments/1716349345763-f586dc80-5850-4a0f-9364-80986feed411.webp)![img](./attachments/1716349345697-72022c85-b05e-4850-b433-4b821d3314fb.webp)![img](./attachments/1716349345767-7f23384d-3789-45f8-a3c7-4246213d78b1.webp)

## 3.修改监控主机关联的模版为主动模式

![img](./attachments/1716349345963-c3b69a11-e949-4065-a216-b13413486e1e.webp)

## 4.修改客户端配置文件并重启

```bash
[root@web-7 ~]# cat /etc/zabbix/zabbix_agentd.conf        
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=10.0.1.61
ServerActive=10.0.1.61
Hostname=web-7
Include=/etc/zabbix/zabbix_agentd.d/*.conf
[root@web-7 ~]# systemctl restart zabbix-agent.service
```

## 5.查看最新数据

发现获取数据的时间是一样的![img](./attachments/1716349346162-305954ff-d3df-416f-b249-60f5eced2c52.webp)

# 第19章 低级自动发现

```bash
监控端口自动发现
自动发现监控磁盘分区
自动发现监控网卡
```

## 1.查看系统自带分区自动发现

系统自带的自动发现会显示红字，比如自带的磁盘分区发现规则![img](./attachments/1716349346295-9be62101-3c45-41fc-bc1c-487c0f79449a.webp)![img](./attachments/1716349346275-80816cc0-3fcb-44f6-853c-f8368674a0e1.webp)1.查看zabbbix所有的key过滤后展示![img](./attachments/1716349346327-04da5056-a4af-42bb-9e37-ef9a4df66f15.webp)2.解析成json后的格式![img](./attachments/1716349346315-74ae94e1-b5be-4891-a0cb-c3d42de54da1.webp)3.过滤规则实质上是从mount命令获取的分区名和类型![img](./attachments/1716349346684-7ad878ec-c4d2-486b-af5e-2dab10492878.webp)但是我们zabbix显示的并没有这么多是因为做了正则表达式过滤![img](./attachments/1716349346845-3c6bc268-0ea7-45f5-8cce-21ca48a3ff64.webp)而正则表达式是在管理里面配置的![img](./attachments/1716349346654-e1b0b819-0e8b-4e6e-97e0-90771cd261e2.webp)4.使用zabbix_get获取key因为根据过滤规则，只发现了一个xfs的key，使用zabbix_get可以查看到这个key

```bash
[root@m-61 ~]# zabbix_get -s 10.0.1.61 -k vfs.fs.size[{#FSNAME},free]
ZBX_NOTSUPPORTED: Cannot obtain filesystem information: [2] No such file or directory
[root@m-61 ~]# zabbix_agentd -p|grep vfs.fs.size
vfs.fs.size[/,free]                           [u|15713636352]
[root@m-61 ~]# zabbix_get -s 10.0.1.61 -k vfs.fs.size[/,free]        
15713693696
```

## 2.查看系统自带的网卡自动发现

1.查看网络自动发现规则![img](./attachments/1716349346796-67b76e53-a9b1-47d6-8839-4178740d9499.webp)2.过滤规则![img](./attachments/1716349346894-49e173fd-e14d-4fae-b29e-e4bc02dcf269.webp)![img](./attachments/1716349347294-eda976ad-fd6d-4ef1-be47-af86e1411466.webp)

2.命令行过滤

```bash
[root@m-61 ~]# zabbix_agentd -p|grep net.if.discovery
net.if.discovery                              [s|{"data":[{"{#IFNAME}":"tun0"},{"{#IFNAME}":"eth0"},{"{#IFNAME}":"eth1"},{"{#IFNAME}":"lo"}]}]
```

3.查看自动添加的监控项我们会发现添加了四个监控项2个eth0 2个eth1![img](./attachments/1716349347306-b42241c5-45a9-48ba-abf0-d112b1c234b2.webp)![img](./attachments/1716349347365-4c310734-30ff-4edc-b9b4-ebaab29f0ead.webp)4.查看key的值

```bash
[root@m-61 ~]# zabbix_get -s 10.0.1.61 -k net.if.in[eth0]
2191453
[root@m-61 ~]# zabbix_get -s 10.0.1.61 -k net.if.in[eth1]
7152
```

## 3.监控mysql多实例

1.复制并修改数据库配置文件

```bash
[root@m-61 ~]# cp /etc/my.cnf /etc/my3307.cnf
[root@m-61 ~]# vim /etc/my3307.cnf 
[root@m-61 ~]# cat /etc/my3307.cnf    
[mysqld]
datadir=/data/3307/
socket=/data/3307/mysql.sock
port=3307
user=mysql
symbolic-links=0
[mysqld_safe]
log-error=/data/3307/mysqld.log
pid-file=/data/3307/mysqld.pid
[root@m-61 ~]# cp /etc/my3307.cnf /etc/my3308.cnf
[root@m-61 ~]# sed -i 's#3307#3308#g' /etc/my3308.cnf
```

2.创建数据目录并初始化

```bash
[root@m-61 ~]# mkdir /data/{3307,3308}
[root@m-61 ~]# chown -R mysql:mysql /data/330*
[root@m-61 ~]# mysql_install_db --user=mysql --defaults-file=/etc/my3307.cnf
[root@m-61 ~]# mysql_install_db --user=mysql --defaults-file=/etc/my3308.cnf
```

3.启动多实例

```bash
[root@m-61 ~]# mysqld_safe --defaults-file=/etc/my3307.cnf &
[root@m-61 ~]# mysqld_safe --defaults-file=/etc/my3308.cnf &
```

4.检查端口

```bash
[root@m-61 ~]# netstat -lntup|grep mysql
tcp        0      0 0.0.0.0:3306            0.0.0.0:*               LISTEN      2042/mysqld         
tcp        0      0 0.0.0.0:3307            0.0.0.0:*               LISTEN      84790/mysqld        
tcp        0      0 0.0.0.0:3308            0.0.0.0:*               LISTEN      85439/mysqld
```

5.创建自动发现配置文件

```bash
[root@m-61 ~]# vim /etc/zabbix/zabbix_agentd.d/mysql_discovery.conf
[root@m-61 ~]# cat /etc/zabbix/zabbix_agentd.d/mysql_discovery.conf
UserParameter=mysql.discovery,/bin/bash /server/scripts/mysql_discovery.sh
```

6.创建自动发现多实例脚本

```bash
[root@m-61 ~]# cat /server/scripts/mysql_discovery.sh                                                
#!/bin/bash 
#mysql low-level discovery 
res=$(netstat -lntp|awk -F "[ :\t]+" '/mysqld/{print$5}')
port=($res) 
printf '{' 
printf '"data":[' 
for key in ${!port[@]} 
do 
        if [[ "${#port[@]}" -gt 1 && "${key}" -ne "$((${#port[@]}-1))" ]];then 
                printf '{' 
                printf "\"{#MYSQLPORT}\":\"${port[${key}]}\"}," 
        else [[ "${key}" -eq "((${#port[@]}-1))" ]] 
                printf '{' 
                printf "\"{#MYSQLPORT}\":\"${port[${key}]}\"}" 
        fi 
done 
printf ']' 
printf '}\n'
```

7.测试自动发现脚本

```bash
[root@m-61 ~]# bash /server/scripts/mysql_discovery.sh    
{"data":[{"{#MYSQLPORT}":"3306"},{"{#MYSQLPORT}":"3307"},{"{#MYSQLPORT}":"3308"}]}
```

8.重启zabbix-agent

[root@m-61 ~]# systemctl restart zabbix-agent.service 

9.zabbix_get测试取key

```bash
[root@m-61 ~]# zabbix_get -s 10.0.1.61 -k mysql.discovery
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
{"data":[]}
```

这时我们发现取不出来并提示了个错误原因是zabbix用户不能使用netstat的-p参数解决方法为给netstat命令添加s权限

```bash
[root@m-61 ~]# which netstat 
/usr/bin/netstat
[root@m-61 ~]# chmod u+s /usr/bin/netstat
```

然后再次测试就发现可以取到值了

```bash
[root@m-61 ~]# zabbix_get -s 10.0.1.61 -k mysql.discovery
{"data":[{"{#MYSQLPORT}":"3306"},{"{#MYSQLPORT}":"3307"},{"{#MYSQLPORT}":"3308"}]}
```

10.web页面创建自动发现规则模版![img](./attachments/1716349347228-7f9d88f0-3d94-49f5-b4e4-e37cb70372c5.webp)

![img](./attachments/1716349347360-0b3743b4-c5c6-46cb-bc4c-f5927eaf2baf.webp)![img](./attachments/1716349347840-abd17494-dcc7-429e-9698-7d8e18800c91.webp)![img](./attachments/1716349347679-34d45d5d-994c-4175-b420-211d07be261e.webp)11.模仿zabbix自带的mysql监控配置修改监控项

```bash
[root@m-61 ~]# cat /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf    
UserParameter=mysql.status[*],echo "show global status where Variable_name='$1';" | HOME=/var/lib/zabbix mysql -uroot -p123456 -P $2 -N | awk '{print $$2}'
[root@m-61 ~]# systemctl restart zabbix-agent.service
```

12.测试访问监控项

```bash
[root@m-61 ~]# zabbix_get -s 10.0.1.61 -k mysql.status[Uptime,3307]
23202
[root@m-61 ~]# zabbix_get -s 10.0.1.61 -k mysql.status[Uptime,3308]
23204
```

13.web页面添加监控项原型![img](./attachments/1716349347657-a50bf339-341b-4cdf-9a04-cc587b649cb2.webp)

12.web页面设置主机关联模版![img](./attachments/1716349347842-a3cb435f-17be-4eed-8b4a-1118288de3a8.webp)

13.查看是否已经自动添加成功![img](./attachments/1716349347927-6651e0ef-f197-4244-ad6b-11e6a50363f8.webp)

# 第20章 zabbix-proxy

## 1.安装zabbix-proxy

```bash
rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
sed -i 's#repo.zabbix.com#mirrors.tuna.tsinghua.edu.cn/zabbix#g' /etc/yum.repos.d/zabbix.repo
yum install zabbix-proxy-mysql mariadb-server
```

## 2.创建数据库以及账号

```bash
systemctl start mariadb.service 
mysqladmin password 123456
mysql -uroot -p123456
> create database zabbix_proxy character set utf8 collate utf8_bin;
> grant all privileges on zabbix_proxy.* to zabbix_proxy@localhost identified by 'zabbix_proxy';
> flush privileges;
```

## 3.导入Zabbix_proxy数据至数据库中

```bash
zcat /usr/share/doc/zabbix-proxy-mysql-4.0.21/schema.sql.gz|mysql -uzabbix_proxy -pzabbix_proxy zabbix_proxy
```

## 4.配置zabbix-proxy

```bash
cat >/etc/zabbix/zabbix_proxy.conf<<EOF
ProxyMode=0
Server=10.0.0.61
ServerPort=10051
Hostname=proxy-8
LogFile=/var/log/zabbix/zabbix_proxy.log
LogFileSize=0
PidFile=/var/run/zabbix/zabbix_proxy.pid
SocketDir=/var/run/zabbix
DBHost=localhost
DBName=zabbix_proxy
DBUser=zabbix_proxy
DBPassword=zabbix_proxy
ConfigFrequency=60
DataSenderFrequency=5
EOF
```

配置解释：

```bash
ProxyMode=0						#<==代理模式，0表示主动模式，1表示被动模式
Server=10.0.0.61			#<==zabbix服务端地址
ServerPort=10051			#<==zabbix服务端端口
Hostname=zabbix_proxy	#<==主机名，必须和zabbix-proxy服务器的主机名一致
LogFile=/var/log/zabbix/zabbix_proxy.log。 
LogFileSize=0
PidFile=/var/run/zabbix/zabbix_proxy.pid
SocketDir=/var/run/zabbix
DBHost=localhost          #<==zabbix-proxy数据库地址
DBName=zabbix_proxy	     	#<==zabbix-proxy数据库名称
DBUser=zabbix_proxy				#<==zabbix-proxy数据库用户名
DBPassword=zabbix_proxy		#<==zabbix-proxy数据库用户密码
ConfigFrequency=60				#<==Zabbix Proxy服务器多少秒和Zabbix Server服务器进行同步一次数据
DataSenderFrequency=5  		#<==Zabbix Proxy服务器间隔多少秒将自己的数据发送给Zabbix Server端
```

## 5.启动zabbix-proxy

```bash
systemctl start zabbix 
```

## 6.zabbix客户端修改配置

```bash
cat >/etc/zabbix/zabbix_agentd.conf <<EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=172.16.1.8
ServerActive=172.16.1.8
HostMetadata=Linux
Include=/etc/zabbix/zabbix_agentd.d/*.conf
EOF

systemctl restart zabbix-agent
```

## 7.web页面添加代理服务器

添加代理程序

![img](./attachments/1716349348129-6684e33b-df4b-401e-9f3d-1dcbe620f02a.webp)

添加完代理程序之后，稍等一会主机就会被自动添加上

![img](./attachments/1716349348212-e8b8d542-5f16-4382-ad09-bcdd8eaee5a5.webp)

查看最新数据是否成功收集

![img](./attachments/1716349348363-c2bdcab2-3dfd-433c-a805-37e6d284c576.webp)

# 第21章 web监控

我们可以配置zabbix来监控web页面的一些状态，比如http状态码，响应时间，登陆状态等。下面我们以登陆并监控zabbix首页为例来进行配置。

## 1.查看认证

![img](./attachments/1716349348308-bd48ac98-9cc5-4e0b-908b-bc57984729eb.webp)

## 2.创建web监控场景

我们可以直接创建一个web监控的模版，并配置触发器

![img](./attachments/1716349348575-51b105fb-f5b5-4f55-9ceb-5c0a6e50ea81.webp)

## 3.创建步骤

![img](./attachments/1716349348611-dcdd4994-b555-416e-801d-24931e56b2b2.webp)

![img](./attachments/1716349348562-5ce24597-0393-46b0-8331-8bece83b30fb.webp)

## 4.查看最新数据

![img](./attachments/1716349348738-6f6baada-df40-466c-aabf-a898577b9b56.webp)

## 5.设置触发器

这里我们设置两个触发器

```bash
1.首页不是200就报警
2.检查登陆步骤返回值不为0，则表示登陆失败
```

![img](./attachments/1716349348805-d3d1a18c-466c-498f-b958-6438d0b60519.webp)

## 6.模拟故障

此时如果故意将监控项里用户密码写错，虽然状态码依然为200，但是因为返回的HTML字符串不是我们要求的，所以仍然会触发警告。

将密码修改为错误的：

![img](./attachments/1716349349115-a29c29ca-1e8a-4c74-a0d1-0a98bec0edef.webp)

查看最新数据：

查看警告：

![img](./attachments/1716349349187-c667fd9c-b880-4f1c-9ffb-210ff6ce0501.webp)

# 第22章 性能优化

## 1.监控数据分析

```bash
zabbix监控主机和监控项较少的时候，不需要优化
数据库 200台主机 * 200个监控项 = 40000监控项/30秒 = 1333次写入/每秒
写多 读少
```

## 2.优化思路

```bash
1.mariadb 5.5 innodb 升级到mysql5.7 tokudb
2.去掉无用监控项，增加监控项的取值间隔，减少历史数据的保存周期
3.被动模式改为主动模式
4.针对zabbix-server进程数量调优
5.针对zabbix-server缓存调优，谁的剩余内存少，就加大他的缓存
```

## 3.升级存储引擎

TokuDB性能比InnoDB要好

实施步骤：

```bash
1.找一台机器安装好mysql5.7
2.将mariadb的数据导出，然后替换sql文件里的存储引擎为TokuDB
3.将替换之后的数据导入到mysql5.7
4.停掉mariadb
5.检查测试
```

## 4.优化进程数

![img](./attachments/1716349349161-f6b011b6-644c-4c88-9eca-dfc57f5b293f.webp)

可以人为制造进程繁忙，把自动发现调整IP范围为1-254![img](./attachments/1716349349160-127d6295-0025-463b-b0b3-6e2034ec6030.webp)

这个时候观察会发现自动发现进程变得繁忙了

修改进程数

```bash
[root@zabbix-11 ~]# grep "^StartDiscoverers" /etc/zabbix/zabbix_server.conf 
StartDiscoverers=10
[root@zabbix-11 ~]# systemctl restart zabbix-server.service
```

调整之后发现进程不这么繁忙了![img](./attachments/1716349349294-77be1a3d-7abe-47e7-b886-cb5c4574bcfa.webp)

## 5.缓存调优

![img](./attachments/1716349349574-b6ef5a45-3351-44e8-aec1-7fe5a25905f3.webp)

调整配置文件

```bash
[root@zabbix-11 ~]# grep "^Cache" /etc/zabbix/zabbix_server.conf 
CacheSize=128M
```

# 第x章 故障记录

## 故障1

故障现象：提示zabbix-server is not running ![img](./attachments/1716349342045-7bed3e65-7d49-42af-8337-3c7b7683b174.webp)报错日志：

```bash
34983:20190807:202215.171 database is down: reconnecting in 10 seconds
 34983:20190807:202225.172 [Z3001] connection to database 'zabbix' failed: [1045] Access denied for user 'zabbix'@'localhost' (using password: NO)
```

故障原因：zabbix-server的配置文件里配有配置数据库密码故障解决：添加正确的数据库账号密码信息

```bash
[root@m-61 ~]# grep "^DB" /etc/zabbix/zabbix_server.conf     
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix
```

## 故障2

故障现象：微信报警失败报错日志：

```bash
[root@m-61 ~]# tail -f /var/log/zabbix/zabbix_server.log 
Problem name: TIME_WAIT过多
Host: web-7
Severity: Average

Original problem ID: 51
'": Traceback (most recent call last):
  File "/usr/lib/zabbix/alertscripts/weixin.py", line 7, in <module>
    import requests
ImportError: No module named requests
```

问题原因：缺少模块 requests

问题解决：安装缺失的依赖包

```bash
[root@m-61 ~]# yum install python-pip
[root@m-61 ~]# pip install --upgrade pip
[root@m-61 ~]# pip install requests
```

## 故障3

故障现象：在server端使用zabbix_get命令测试键值命令时提示警告

```bash
[root@m-61 ~]# zabbix_get -s 10.0.1.7 -k ESTABLISHED  
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
2
```

问题原因：zabbix_agent是以普通用户zabbix运行的，而普通用户执行netstat -antp时会有警告，网上查找发现只要不是用p参数就可以以普通用户运行解决方案：监控脚本里的命令修改为netstat -ant

# 