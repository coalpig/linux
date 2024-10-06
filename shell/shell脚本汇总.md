---
tags:
  - Shell
---
# shell脚本汇总

## 脚本目录

1. 系统初始化脚本
2. SSH密钥免交互分发脚本
3. 数据库分库分表备份脚本
4. 参数化代码上线脚本
5. zabbix自定义监控项脚本
6. 定时任务备份脚本
7. 安全基线检查脚本
8. 日志分析脚本
9. openvpn自动管理脚本
10. 跳板机脚本
11. 防火墙自动封IP脚本
12. 服务启动脚本
13. IP存活批量检测脚本
14. 端口存活批量检测脚本
15. KVM自动化管理脚本
16. 日志自动切割脚本
17. 网站关键接口存活性巡检脚本
18. 软件自动安装脚本
19. 检查https证书是否过期脚本
20. 报警邮件发送微信、钉钉、飞书脚本
21. Java繁忙进程dump导出脚本
22. 文件实时备份脚本
23. Docker自动导出镜像脚本
24. iptables维护脚本
25. 系统性能压测脚本，磁盘，网络

## 脚本参考

#### 1. 系统初始化脚本



#### 2. 系统环境巡检脚本






> [!info]- SSH密钥免交互分发脚本，没有使用函数的版本
> >a. 
> 
> ```bash
> #!/bin/bash
> echo "1.创建密钥对
> 2.分发密钥
> 3.检查主机
> 4.远程登陆主机
> 5.退出"
> 
> read -p "请选择要执行的操作: " choice
> 
> case $choice in
>   1)
>     #检查密钥对
>     if [ -f ~/.ssh/id_rsa ];then
>       echo "密钥对已经存在"
>       exit
>     fi
> 
>     #创建密钥对
>     ssh-keygen -f ~/.ssh/id_rsa -N '' > /dev/null 2>&1
>     if [ $? -eq 0 ];then
>       echo "密钥对创建成功"
>     else
>       echo "密钥对创建失败"
>     fi
>     ;;
>   2)
>     #检查密钥对
>     if [ ! -f ~/.ssh/id_rsa ];then
>       echo "密钥对不存在"
>       exit
>     fi
> 
>     #循环主机列表
>     for i in $(cat ip_list.txt)
>     do
>         #主机存活检查
>         ping -c 1 -w 1 $i > /dev/null
>         if [ $? -ne 0 ];then
>           echo "$i 网络不通!"
>           continue
>         fi
> 
>         #如果存活则分发密钥
>         sshpass -p '123' ssh-copy-id $i -o StrictHostKeyChecking=no > /dev/null 2>&1
>         if [ $? -eq 0 ];then
>           echo "$i 分发成功!"
>         else
>           echo "$i 分发失败!"
>         fi
>     done
>     ;;
>   3)
>     #循环主机列表
>     for i in $(cat ip_list.txt)
>     do
>         #主机存活检查,如果网络不通，则结束本次循环，进入下次循环
>         ping -c 1 -w 1 $i > /dev/null
>         if [ $? -ne 0 ];then
>           echo "$i 网络不通!"
>           continue
>         fi
> 
>         #如果存活则检查是否已经分发公钥
>         m_key=$(cat ~/.ssh/id_rsa.pub|awk '{print $2}')
>         sshpass -p 123 ssh $i "grep $m_key ~/.ssh/authorized_keys" > /dev/null 2>&1
>         if [ $? -eq 0 ];then
>           echo "$i 可以公钥连接!"
>         else
>           echo "$i 没有分发公钥!"
>         fi
>     done
>     ;;
>   4)
>     #打印主机菜单
>     if [ -f ip_list.txt ];then
>       awk '{print NR")"$0}' ip_list.txt
>     fi
> 
>     #接收用户输入
>     read -p "请选择要执行的操作: " choice
> 
>     #判断用户输入是否为数字
>     if ! [[ $choice =~ ^[1-9]+$ ]]; then
>       echo "输入不合法"
>       exit
>     fi
> 
>     #判断用户输入的数字是否超过范围
>     choice_max=$(cat ip_list.txt|wc -l)
>     if [ $choice -gt $choice_max ];then
>       echo "输入的数字超过可选范围"
>       exit
>     fi
> 
>     ##判断参数是否为空
>     #if [ -z $choice ];then
>     #  echo "输入不能为空"
>     #  exit
>     #fi
>     #
>     ##判断参数是否为纯数字
>     #choice_check=$(echo "$choice"|sed "s#[0-9]##g")
>     #echo $choice_check
>     #if [ -n $choice_check ];then
>     #  echo "必须输入整数"
>     #  exit
>     #fi
>     #
>     ##判断输入的数字是否合法
>     #choice_check=$(sed -n "${choice}"p ip_list.txt)
>     #if [ -z $choice ];then
>     #  echo "输入的数字超过范围"
>     #  exit
>     #fi
> 
>     #主机存活检查
>     ip_host=$(sed -n "${choice}"p ip_list.txt)
>     ping -c 1 -w 1 $ip_host > /dev/null
>     if [ $? -ne 0 ];then
>       echo "$ip_host 网络不通!"
>       exit
>     fi
> 
>     #主机是否可以公钥连接检查
>     m_key=$(cat ~/.ssh/id_rsa.pub|awk '{print $2}')
>     sshpass -p 123 ssh $ip_host "grep $m_key ~/.ssh/authorized_keys" > /dev/null 2>&1
>     if [ $? -ne 0 ];then
>       echo "$ip_host 连接失败,没有分发公钥!"
>       exit
>     fi
> 
>     #检查通过在登陆前记录日志
>     echo "登录时间: $(date +%F-%H:%M)" >> /tmp/ssh.log
>     echo "登陆主机: $ip_host 登录成功" >> /tmp/ssh.log
>     ssh $ip_host
>     ;;
>   5)
>     echo "退出成功"
>     exit
>     ;;
>   *)
>     echo "成功成功"
>     ;;
> esac
> ```

> [!info]- 数据库分库分表备份脚本
> 
> 
> >a. mysql数据库
> 
> ```shell
> #!/bin/bash
> # 定义循环的数据库名称
> for db_name in zh wordpress
> do
>   #创建数据库的目录
>   mkdir -p /backup/${db_name}
>   #获取数据库下所有的表的列表
>   table_list=$(mysql -uroot -p123 -e "show tables from ${db_name};"|grep -v "Tables_in")
>   #遍历循环每个表
>   for table_name in ${table_list}
>   do
>     #将表保存在库的目录下
>     mysqldump -uroot -p123 ${db_name} ${table_name} >> /backup/${db_name}/${table_name}.sql
>   done
> done
> ```

#### 5. 参数化代码上线脚本



#### 6. zabbix自定义监控项脚本



#### 7. 定时任务备份脚本



> [!info]- 安全基线检查脚本
> 
> 
> >a. SSH检查
> 
> 检查项
> 
> ```bash
> [root@m-61 ~/ssh]# cat ssh_check.txt
> Port 22
> ListenAddress 172.16.1.61
> PermitRootLogin no
> PubkeyAuthentication yes
> PasswordAuthentication no
> PermitEmptyPasswords no
> PermitRootLogin no
> ```
> 
> 检查脚本
> 
> ```bash
> #!/bin/bash
> . /etc/init.d/functions
> 
> exec < ssh_check.txt
> while read line
> do
>   #定义检查项名称
>   ssh_check_name=$(echo $line|awk '{print $1}')
> 
>   #定义检查项的值
>   ssh_check_value=$(echo $line|awk '{print $2}')
> 
>   #检查ssh配置是否打开注释
>   ssh_conf_exis=$(grep "^$ssh_check_name" /etc/ssh/sshd_config)
>   if [ -z "$ssh_conf_exis" ];then
>     action "$ssh_check_name:$ssh_check_value | null" /bin/false
>     continue
>   fi
> 
>   #检查ssh配置是否正确
>   ssh_conf_value=$(grep "^$ssh_check_name" /etc/ssh/sshd_config|awk '{print $2}')
>   if [ "$ssh_conf_value" == "$ssh_check_value" ];then
>     action "$ssh_check_name:$ssh_check_value | $ssh_conf_value" /bin/true
>   else
>     action "$ssh_check_name:$ssh_check_value | $ssh_conf_value" /bin/false
>   fi
> done
> ```
> 
> 执行效果:
> 
> ```shell
> [root@m-61 ~/ssh]# bash ssh_check.sh
> Port:22 | 22                                               [  OK  ]
> ListenAddress:172.16.1.61 | null                           [FAILED]
> PermitRootLogin:no | null                                  [FAILED]
> PubkeyAuthentication:yes | null                            [FAILED]
> PasswordAuthentication:no | yes                            [FAILED]
> PermitEmptyPasswords:no | null                             [FAILED]
> PermitRootLogin:no | null                                  [FAILED]
> ```
> 

> [!info]- 日志分析脚本
> 
> 
> ```shell
> #!/bin/bash 
> 
> #1.显示服务信息
> echo "==============================
> 服务器名:$(hostname)
> 服务器IP:$(hostname -I)
> 查询日志为:xxx.com_access.log
> 查询时间为: $(date +%F)
> =============================="
> #2.PV数
> echo "PV数量为: $(wc -l bbs.xxxx.com_access.log|awk '{print $1}')"
> echo "=============================="
> #3.搜索引擎次数
> echo "搜索情况汇总"
> echo "搜索引擎总计访问次数: $(egrep -i 'bot|spider|Spider' bbs.xxxx.com_access.log |wc -l)"
> echo "Baidu访问次数：      $(egrep -i 'Baiduspider' bbs.xxxx.com_access.log |wc -l)"
> echo "bing访问次数：       $(egrep -i 'bingbot' bbs.xxxx.com_access.log |wc -l)"
> echo "Google访问次数：     $(egrep -i 'googlebot' bbs.xxxx.com_access.log |wc -l)"
> echo "sougou访问次数：     $(egrep -i 'Sogou web spider|pic.sogou.com' bbs.xxxx.com_access.log |wc -l)"
> echo "yisou访问次数：      $(egrep -i 'YisouSpider' bbs.xxxx.com_access.log |wc -l)"
> echo "brandwatch访问次数： $(egrep -i 'brandwatch' bbs.xxxx.com_access.log |wc -l)"
> #4.TOP IP
> echo "=============================="
> echo "访问最多IP前10为:"
> num=1
> exec < ip.txt
> while read line 
> do
>    num=`echo ${line}|awk '{print $1}'`
>    ip=`echo ${line}|awk '{print $2}'`
>    host=`curl -s cip.cc/${ip}|awk '/地址/{print $3}'`
>    echo "${num} ${ip} ${host}" 
>    sleep 2
> done
> 
> #5.其他
> echo "=============================="
> echo "监控关键链接为：GET /thread-"
> echo "=============================="
> echo "关键链接PV访问次数: $(grep "GET /thread-" bbs.xxxx.com_access.log|wc -l)"
> echo "=============================="
> echo "关键链接平均响应时间为: $(grep "GET /thread-" bbs.xxxx.com_access.log|awk '{sum+=$NF} END {print  sum/NR}')"
> echo "=============================="
> echo "关键链接访问响应时间排名"
> echo "$(awk '{print $NF}' bbs.xxxx.com_access.log |grep -v "-"|cut -b -3|sort|uniq -c|sort -nr|head -10)"
> ```
> 

#### 10. openvpn自动管理脚本



#### 11. 跳板机脚本



#### 12. 防火墙自动封IP脚本



#### 13. Nginx自动封禁高频IP



> [!info]- Nginx服务启动脚本
> 
> 
> ```bash
> #!/bin/bash
> nginx_pid="/var/run/nginx.pid"
> nginx_bin="/usr/sbin/nginx"
> nginx_conf="/etc/nginx/nginx.conf"
> 
> case $1 in
>   start)
>     if [ -f $nginx_pid ];then
>       echo "Nginx已经启动"
>     else
>       $nginx_bin -c $nginx_conf
>       if [ $? -eq 0 ];then
>         echo "Nginx启动成功"
>       else
>         echo "Nginx启动失败"
>       fi
>     fi
>   ;;
>   stop)
>     if [ -f $nginx_pid ];then
>       $nginx_bin -s stop
>       if [ $? -eq 0 ];then
>         echo "Nginx停止成功"
>       else
>         echo "Nginx停止失败"
>       fi	  
>     else
>       echo "Nginx已经停止"
>     fi
>     ;;
>   restart)
>     #停止服务
>     if [ -f $nginx_pid ];then
>       $nginx_bin -s stop
>       if [ $? -eq 0 ];then
>         echo "Nginx停止成功"
>       else
>         echo "Nginx停止失败"
>       fi	  
>     else
>       echo "Nginx已经停止"
>     fi
> 
>     #启动服务
>     if [ -f $nginx_pid ];then
>       echo "Nginx已经启动"
>     else
>       $nginx_bin -c $nginx_conf
>       if [ $? -eq 0 ];then
>         echo "Nginx启动成功"
>       else
>         echo "Nginx启动失败"
>       fi
>     fi
>     ;;
>   reload)
>     if [ -f $nginx_pid ];then
>       $nginx_bin -s reload
>       if [ $? -eq 0 ];then
>         echo "Nginx重载成功"
>       else
>         echo "Nginx重载失败"
>       fi	  
>     else 
>       echo "Nginx没有运行,reload失败"
>     fi
>     ;;
>   status)
>     if [ -f $nginx_pid ];then
>       echo "Nginx正在运行"	
>     else 
>       echo "Nginx没有运行"
>     fi
>     ;;
>   *)
>     echo "usag: bash $0 {start|stop|restart|reload|status}"
> esac
> ```
> 

> [!info]- IP存活批量检测脚本
>  
> 
> ```bash
> #!/bin/bash
> 
> #清空日志
> > ip_status.log
> 
> #循环IP地址
> for i in {1..255}
> do
>   #将检测命令放入后台执行,并将结果写入日志
>   ping -c 1 -w 1 192.168.2.$i >> ip_status.log 2>&1 &
> done
> 
> #等待2秒
> sleep 2
> 
> #将存活的主机过滤出来
> grep "ttl=" ip_status.log|awk -F"[ :]" '{print $4,"存活"}'|sort -n -t . -k 4
> ```
> 

#### 16. 端口存活批量检测脚本



#### 17. KVM自动化管理脚本



#### 18. 日志自动切割脚本



#### 19. 网站关键接口存活性巡检脚本



#### 20. 软件自动安装脚本



#### 21. 检查https证书是否过期脚本



#### 22. 报警邮件发送微信、钉钉、飞书脚本



#### 23. Java繁忙进程dump导出脚本



#### 24. 文件实时备份脚本



#### 25. Docker自动导出镜像脚本



#### 26. iptables维护脚本



#### 27. 系统性能压测脚本，磁盘，网络

