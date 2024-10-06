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
