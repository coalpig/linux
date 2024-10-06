#!/bin/bash

#需要将下列信息修改为自己注册的企业微信信息
#应用ID
agentid='1000004'
#secretID
corpsecret='RzrUiDaShCdxVP_69Kjznq6C2-_v4fQCFeQfB1B5QHw'
#企业ID
corpid='ww15122ef105762abd'

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
