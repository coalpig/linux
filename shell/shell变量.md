---
tags:
  - Shell
---

> [!info]- 什么是变量
> 
> 
> 变量是Shell传递数据的一种方式。
> 以一个固定的字符串去表示一个不固定的值，便于后续的复用和维护。

> [!info]- 变量的分类
> 
> 
> 环境变量（全局变量）  对整个系统生效
> 普通变量（局部变量）  只对当前的脚本生效
> 
> 变量的生存周期
> 永久的 需要修改环境变量配置文件 变量永久生效 /etc/profile
> 临时的 直接使用export声明变量即可，关闭shell则变量失效
> 
> 临时变量的export区别
> 不加export 则只对当前的shell生效
> 加export   则对当前打开窗口所有的shell生效

> [!info]- shell变量的命名规范
> 
> 
> 1.以大小写字母 下划线 数字 拼接成变量名，最好以字母开头，最好名字有含义，不然写着写着很容易忘记这个变量干嘛用的
> 2.变量名=变量值 等号表示给变量赋值，注意等号两边不要有空格
> 3.系统的环境变量都是大写的，注意不要用系统保留的变量名称，比如PATH
> 4.变量命名最好不要与系统命令冲突，比如 date=20200731
> 
> 变量命名参考：
> 
> ```shell
> path_data   	#全小写
> Path_Date   	#驼峰写法，首字母大写
> PATH_DATA 	#全大写
> 
> ```


- ~ 变量定义的几种方式

> [!info]- 字符串定义变量
> 
> 
> 定义一个变量：
> 
> ```plain
> [root@m-61 ~]# name="man"
> ```
> 
> 查看变量：
> 
> ```plain
> [root@m-61 ~]# echo "$name"
> man
> [root@m-61 ~]# echo "${name}"
> man
> ```
> 

> [!info]- 命令定义变量
>  
> 
> 使用命令定义变量：
> 
> ```plain
> [root@m-61 ~]# time=`date`
> [root@m-61 ~]# echo ${time}
> 2020年 07月 31日 星期五 19:11:17 CST
> [root@m-61 ~]# time=$(date +%F)
> [root@m-61 ~]# echo ${time}    
> 2020-07-31
> ```
> 
> 命令定义变量两种方式区别：
> 
> 1）反引号 `命令` 和 $(命令) 都可以表示将命令赋值给变量
> 2）建议使用$()，因为如果脚本语句里包含单引号和双引号，很容易和反引号搞混，另外也不方便阅读。
> 

> [!info]- 引用变量
> 
> 
> 引用变量$和 ${}的区别：
> 
> ```plain
> [root@m-61 ~]# echo "$name_host"
> 
> [root@m-61 ~]# echo "${name}_host"
> man_host
> ```
> 
> 结论：
> 
> 如果不加${}，可能会造成歧义，使用${}更保险
> 
> 单引号和双引号区别:
> 
> ```plain
> [root@m-61 ~]# echo "name is ${name}" 
> name is man
> [root@m-61 ~]# echo 'name is ${name}'
> name is ${name}
> ```
> 
> 结论：
> 
> 1.单引号不会解析变量，给什么，吐什么
> 2.双引号可以正确解析变量
> 
> 什么情况下使用单引号和双引号:
> 
> 1.如果需要解析变量，就用双引号
> 2.如果输出的结果要求是普通的字符串，或者需要正确显示特殊字符，则可以用单引号或者撬棍\。
> 

- ~ 变量的传递

> [!info]- 位置参数传递
> 
> 
> 执行脚本的时候我们可以通过传递参数来实现变量的赋值，接受参数的变量名是shell固定的，我们不能自定义.
> 
> 脚本如下：
> 
> ```
> cat > vars.sh <<'EOF'
> #!/bin/bash
> echo "#当前shell脚本的文件名： $0"
> echo "#第1个shell脚本位置参数：$1"
> echo "#第2个shell脚本位置参数：$2"
> echo "#第3个shell脚本位置参数：$3"
> echo "#所有传递的位置参数是: $*"
> echo "#所有传递的位置参数是: $@"
> echo "#总共传递的参数个数是: $#"
> echo "#当前程序运行的 PID 是: `$$`"
> echo "上一个命令执行的返回结果: $?"
> EOF
> ```
> 
> 执行效果：
> 
> ```
> bash vars.sh 11 22 33 44            
> #当前shell脚本的文件名： vars.sh
> #第1个shell脚本位置参数：11
> #第2个shell脚本位置参数：22
> #第3个shell脚本位置参数：33
> #所有传递的位置参数是: 11 22 33 44
> #所有传递的位置参数是: 11 22 33 44
> #总共传递的参数个数是: 4
> #当前程序运行的 PID 是: 11943
> #上一个命令执行的返回结果: 0
> ```
> 
> 练习题：
> 
> 1.编写脚本，通过变量传参的形式免交互创建Linux系统用户及密码
> 2.编写一个通过传参自动修改主机名的脚本
> 


> [!info]- 交互式参数传递
> 
> 
> 语法解释：
> 
> read -p "提示符: " 变量名称
> 
> 脚本如下：
> 
> ```plain
> [root@m-61 ~]# cat read.sh 
> #!/bin/bash
> 
> #-s 不回显，就是不显示输入的内容
> #-n 指定字符个数
> #-t 超时时间
> 
> read -p "Login: " user
> read -s -t20 -p "Passwd: " passwd
> echo -e "\n===================="
> echo -e "\nlogin: ${user} \npasswd: ${passwd}"
> ```
> 
> 执行效果：
> 
> ```plain
> [root@m-61 ~]# bash read.sh 
> Login: root
> Passwd: 
> ====================
> 
> login: root 
> passwd: 123456
> ```
> 
> 小小练习题: 接收用户输入的各种信息创建用户和密码
> 
> ```plain
> 需求: 
> 接收用户输入的各种信息创建用户
> 1.交互式传递3个变量
> username
> uid
> passwd
> 
> 2.把账号密码文件保存到/tmp/user.log
> username:passwd
> 
> 执行效果:
> bash useradd.sh
> please input user name : 
> please input uid :
> please input passwd :  
> 
> 大家遇到的问题:
> 1.基础命令忘了
> 2.笔记不知道在哪了
> 3.没有掌握写脚本正确的步骤
> 
> 推荐的步骤:
> 第一步: 理清需求
> 创建一个用户并创建密码
> 
> 第二步: 直接使用shell命令如何创建用户
> useradd -u 2000 www
> echo "123456"|passwd --stdin www
> 
> 第三步: 编写脚本
> #!/bin/bash 
> 
> #1.交互式接受用户输入的信息
> read -p "please input user name:" username
> read -p "please input uid:" uid
> read -p "please input passwd:" passwd
> 
> #2.创建用户
> useradd -u $uid $username 
> 
> #3.创建密码
> echo "$passwd"|passwd --stdin $username
> 
> #4.将用户名密码写入日志里
> echo ${username}:${passwd} >> /tmp/user.log
> ```
> 
> 小小练习题: 交互式接受用户传递的两个参数,分别为要修改的主机名和IP地址
> 
> ```plain
> 第一步: 理解需求
> 需求:
> 交互式接受用户传递的两个参数,分别为要修改的主机名和IP地址
> 
> 第二步: 在shell命令实现
> 1.修改主机名
> echo "haitao" > /etc/hostname
> 
> 2.修改IP地址
> sed -i "/IPADDR/c IPADDR=10.0.0.200" /etc/sysconfig/network-scripts/ifcfg-eth0
> 
> 第三步: 写进脚本里
> #!/bin/bash 
> 
> #1.定义变量
> read -p "please input hostname:" hostname
> read -p "please input ip:" ip
> 
> #2.执行替换命令
> echo "$hostname" > /etc/hostname
> sed -i "/IPADDR/c IPADDR=$ip" /etc/sysconfig/network-scripts/ifcfg-eth0
> ```
> 
> 小小练习题: 编写一个交互式的创建定时任务的脚本，提示用户输入分 时 日 月 周和任务
> 
> ```plain
> 需求: 使用交互式传递进脚本
> */5 * * * * /sbin/ntpdate time1.aliyun.com > /dev/null 2>&1 
> 
> 效果:
> please input cron_time: */5 * * * *
> please input cron_job: /sbin/ntpdate time1.aliyun.com > /dev/null 2>&1 
> 
> 第一步: 先在shell实现
> echo '*/5 * * * * /sbin/ntpdate time1.aliyun.com > /dev/null 2>&1' >> /var/spool/cron/root
> 
> 
> 第二步: 写进脚本里
> #!/bin/bash 
> 
> #定义变量
> read -p "please input cron_time:" cron_time
> read -p "please input cron_job:" cron_job
> 
> #执行创建命令
> echo "#cron by zhangya at $(date +%F)" >> /var/spool/cron/root
> echo "$cron_time $cron_job" >> /var/spool/cron/root
> 
> #检查是否写入成功
> crontab -l
> ```
> 
> 练习题：
> 
> ```plain
> 1.将前面练习的免交互创建用户名密码改写为交互式脚本
> 2.编写一个探测主机存活的脚本，交互式的用户输入需要测试的IP地址，然后探测IP地址是否存活
> 3.编写一个交互式修改主机名和IP地址的脚本
> 4.编写一个交互式的创建定时任务的脚本，提示用户输入分 时 日 月 周和任务，例如：
> */5 * * * * /sbin/ntpdate time1.aliyun.com > /dev/null 2>&1
> ```
> 

- ~ 变量的运算

什么是变量运算

顾名思义，变量运算就是对变量的值进行运算，也就是 加 减 乘 除 取余

> [!info]- 变量运算语法
> 
> 
> ```plain
> expr       #只能做整数运算
> $(( ))       #双括号运算，只支持整数运算，效率高
> $[]        #整数运算，最简洁
> bc,awk       #支持小数点
> %          #取余
> ```
> 

> [!info]- 运算公式举例
> 
> 
> expr
> 
> ```plain
> expr 10 + 10
> expr 10 - 10
> expr 10 \* 10
> expr 10 / 10 
> 
> num1=10
> num2=20
> expr ${num1} + ${num2}
> ```
> 
> $(( ))
> 
> ```plain
> echo $((10+10))
> echo $((10-10))
> echo $((10*10))
> echo $((10/10))
> echo $((10+10-5))
> echo $((10+10-5*6))
> 
> num1=10
> num2=20
> echo $(($num1*$num2))
> ```
> 
> $[ ]
> 
> ```plain
> echo $[10+10]
> echo $[10+10*20]
> echo $[10+10*20-1000]
> echo $[10+10*20/1000]
> ```
> 
> let
> 
> ```plain
> let a=10+10
> echo $a
> 
> let a=10*10
> echo $a    
> 
> let a=10/10
> echo $a    
> 
> let a=$num1+$num2
> echo $a
> ```
> 
> bc
> 
> ```plain
> echo 10*10|bc
> echo 10*10.5|bc
> echo 10-5.5|bc 
> echo 10/5.5|bc
> ```
> 
> awk运算
> 
> ```plain
> awk 'BEGIN{print 10+10}'
> awk 'BEGIN{print 10-10}'
> awk 'BEGIN{print 10*10}'
> awk 'BEGIN{print 10/10}'
> awk 'BEGIN{print 10^10}'
> awk 'BEGIN{print 10-4.5}'
> awk 'BEGIN{print 10*4.5}'
> awk 'BEGIN{print 10/4.5}'
> ```
> 

> [!info]- 练习题
> 
> 
> 练习题1: 根据系统时间打印出今年和明年时间
> 
> ```plain
> [root@m-61 ~]# echo "this year is $(date +%Y)"
> this year is 2020
> [root@m-61 ~]# echo "this year is $(( $(date +%Y) + 1 ))" 
> this year is 2021
> [root@m-61 ~]# echo $[ `date +%Y` + 1 ]
> 2022
> ```
> 
> 练习题2: 根据系统时间获取今年还剩下多少星期，已经过了多少星期
> 
> ```plain
> [root@m-61 ~]# date +%j
> 214
> [root@m-61 ~]# date +%U
> 30
> [root@m-61 ~]# echo "今年已经过了 $(date +%j) days"
> 今年已经过了 214 days
> [root@m-61 ~]# echo "今年还剩 $[ ( 365 - $(date +%j) ) / 7 ] 周"  
> 今年还剩 21 周
> [root@m-61 ~]# echo "今年还剩 $[ ( (365 / 7) - $(date +%U)) ] 周"
> 今年还剩 22 周
> ```
> 
> 练习题3: 完成简单计算功能，通过read方式传入2个值，进行加减乘除
> 
> ```plain
> [root@m-61 ~]# cat vars-2.sh 
> #!/bin/bash 
> 
> read -p "please input num1:" num1
> read -p "please input num2:" num2
> 
> echo "$num1 + $num2 =" $[ $num1 + $num2 ]
> echo "$num1 - $num2 =" $[ $num1 - $num2 ]
> echo "$num1 * $num2 =" $[ $num1 * $num2 ]
> echo "$num1 / $num2 =" $[ $num1 / $num2 ]
> ```
> 

> [!info]
> 练习
> 
> 概念解释：
> 
> ```plain
> 1.简单介绍shell脚本是什么，使用场景有哪些？
> 2.shell脚本的书写规范是什么？
> 3.shell脚本变量的定义方式有几种？
> 4.shell脚本如何引用变量？
> 5.shell脚本特殊变量的意思是什么？$0 $1 $2 $* $@ $# $$ $?
> 6.变量的运算方式
> ```
> 
> 练习题：
> 
> ```plain
> 0.今天课上的练习题自己全部写一遍
> 1.使用Shell脚本打印，系统版本、内核版本平台、主机名、eth0网卡IP地址、lo网卡IP地址、当前主机的外网IP地址，提醒：curl icanhazip.com
> 2.看谁能用最精简的脚本实现一个计算器
> 3.查看当前内存使用的百分比和系统已使用磁盘的百分比
> ```
> 
> 拓展：
> 
> ```plain
> 1.如何创建shell脚本的时候自动把#!/bin/bash和注释内容加上去
> 2.如何让shell脚本的输出改变颜色 提示：echo命令的参数
> 3.思考今天所写的脚本逻辑判断是否严谨 提示：今天计算器不严谨
> ```
> 
