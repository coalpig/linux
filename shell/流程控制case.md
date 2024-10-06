---
tags:
  - Shell
---
- ~ 介绍

case和if都是用来处理多分支判断的，只不过case更加简洁和规范一些。

> [!info]- case使用场景
> 
> 
> ```plain
> 我们可以根据用户输入的参数来进行匹配，不同的匹配选项执行不同的操作步骤。
> 比如：服务的启动脚本 {start|restart|stop} 等操作
> ```
> 

> [!info]- case基本语法
> 
> 
> ```plain
> case $1 in 
> start)
>   command
>   ;;
> restart)
>   command
>   ;;
> stop)
>   command
>   ;;
> *)
>   command
> esac
> ```
> 

> [!info]- if和case的区别
> 
> 
> 下面我们以一个小例子来说明if和case的区别
> 

- ~ 练习需求

根据用户选择的序号执行相应的操作

> [!info]- if的写法
> 
> 
> ```plain
> #!/bin/bash
> 
> echo -e "================
> 1.取钱
> 2.存钱
> 3.还剩多少
> ================"
> 
> read -p "请输入你要执行的操作: " num
> 
> if [ "${num}" -eq 1 ];then
>     echo "取好了"
> elif [ "${num}" -eq 2 ];then
>     echo "存好了"
> elif [ "${num}" -eq 3 ];then 
>     echo "还剩-100元"
> else
>     echo "输入有误，下次走点心"
> fi
> ```

> [!info]- case的写法
> 
> 
> ```plain
> #!/bin/bash
> 
> echo -e "================
> 1.取钱
> 2.存钱
> 3.还剩多少
> ================"
> 
> read -p "请输入你要执行的操作: " num
> 
> case ${num} in 
>     1)
>         echo "取好了"
>         ;;
>     2)
>         echo "存钱"
>         ;;
>     3)
>         echo "还剩-100元"
>         ;;
>     *)
>         echo "其输入正确的数据"
> esac
> ```

> [!info]- case和if的对比
> 
> 
> ```plain
> if [ 用户点的菜 == 叉烧 ];then
>    上叉烧
> elif [ 用户点的菜 == 烧鹅 ];then
>    上烧鹅
> elif [ 用户点的菜 == 奶茶 ];then
>    上奶茶
> else 
>    你到底想吃啥?
> fi   
>  
> 
> case 用户点的菜 in. 
> 叉烧)
>   command
>   ;;
> 烧鹅)
>   command
>   ;;
> 奶茶)
>   command
>   ;;
> 其他)
>   command
> esac  
> 
> 
> case $1 in 
> start)
>   systemctl start nginx
>   ;;
> restart)
>   systemctl restart nginx
>   ;;
> stop)
>   systemctl stop nginx
>   ;;
> *)
>   echo "USAG: bash $0 {start|restart|stop}"
> esac
> ```

> [!info]- 综合练习
> 
> 
> >5.1 使用case编写友好输出的计算器
> 
> 需求：
> 
> ```plain
> 1.交互式接受用户输入的数字和计算方法
> 3.判断用户输入的参数是否为3个
> 4.判断用户输入的是否为整数数字
> 5.判断用户输入的符号是否为+-*%
> 6.如果用户输入错误则友好提醒正确的使用方法
> ```
> 
> 脚本：
> 
> ```plain
> #!/bin/bash
> 
> read -p "请输入要计算的第一个数字: " num1
> if [ ! -z $(echo ${num1}|sed -r 's#[0-9]+##g') ];then
>   echo "请输入整数"
>   exit
> fi
> 
> read -p "请输入要计算的第二个数字: " num2
> if [ ! -z $(echo ${num2}|sed -r 's#[0-9]+##g') ];then
>   echo "请输入整数"
>   exit
> fi
> 
> echo -e "请选择运算符号：
> 1. + 
> 2. - 
> 3. * 
> 4. /"
> 
> read -p "请输入您的选择: " fuhao
> 
> case ${fuhao} in
>     1)
>         echo "$num1 + $num2 = $(( $num1 + $num2 ))"
>         ;;
>     2)
>         echo "$num1 - $num2 = $(( $num1 - $num2 ))"
>         ;;
>     3)
>         echo "$num1 * $num2 = $(( $num1 * $num2 ))"
>         ;;
>     4)
>         echo "$num1 / $num2 = $(( $num1 / $num2 ))"
>         ;;
>     *)
>         echo "请输入1-4"
> esac
> ```
> 
> >5.2 编写非交互的服务启动脚本
> 
> 需求：
> 
> ```plain
> 1.使用case编写非交互的服务管理脚本
> 2.如果用户输入参数错误，则友好提醒脚本的使用方法
> ```
> 
> 脚本：
> 
> ```plain
> #!/bin/bash
> 
> source /etc/init.d/functions
> 
> SERVICE=$1
> case ${SERVICE} in
>   start)
>       echo "nginx 启动中..."
>       sleep 1
>       nginx
>       if [ $? -eq 0 ];then
>         action "nginx 启动成功" /bin/true
>       else
>         action "nginx 启动失败" /bin/false
>       fi
>       ;;
>   stop)
>       echo "nginx 停止中..."
>       sleep 1
>       nginx -s stop
>       if [ $? -eq 0 ];then
>         action "nginx 已经停止" /bin/true
>       else
>         action "nginx 停止失败" /bin/false
>       fi
>       ;;
>   restart)
>       echo "nginx 重启中..."
>       nginx -s stop
>       sleep 1
>       nginx
>       if [ $? -eq 0 ];then
>         action "nginx 重启成功" /bin/true
>       else
>         action "nginx 重启失败" /bin/false
>       fi
>       ;;
>   reload)
>       nginx -s reload
>       if [ $? -eq 0 ];then
>         action "nginx 正在重新载入" /bin/true
>       else
>         action "nginx 重新载入失败" /bin/false
>       fi
>       ;;
>   check)
>       nginx -t 
>       ;;
>   *) 
>       echo "Usage: {start|stop|restart|reload|check}"
> esac
> ```
> 
> >5.3 模拟用户登陆
> 
> 需求：
> 
> ```plain
> 1.提前创建一个用户记录文件，格式为
> 用户名:密码
> 2.用户执行脚本打印菜单
> - 登陆
> - 注册
> 3.登陆菜单的选项
> - 请输入账号名
> - 请输入密码
> - 如果账号密码正确，则登陆成功
> 4.注册
> - 请输入用户名，然后检查用户名是否已经存在
> - 请输入密码
> - 请再次输入密码
> - 将用户名和密码写入文本里，如果成功则返回注册成功的结果
> - 返回登陆页面
> ```
> 
> 脚本：
> 
> ```plain
> #!/bin/bash
> 
> name_list=bank.txt
> log=log.txt
> time=$(date)
> 
> echo "
> ===========
> 1.登陆
> 2.注册
> ===========
> "
> read -p "请选择需要的操作:" memu 
> 
> case ${memu} in 
>   1)
>       read -p "请输入用户名:" name
>       grep -wo "${name}" ${name_list} >> /dev/null 2>&1
>       if [ $? != 0 ];then
>          echo "用户名不存在，请重新输入"
>          exit
>       fi
> 
>       read -p "请输入密码:" passwd_input
>       passwd_user=$(awk -F":" "/^${name}\:/"'{print $2}' ${name_list})
>       #passwd_user=$(sed -rn "s#${name}:(.*)#\1#g"p bank.txt)
>       if [ ${passwd_input} == ${passwd_user} ];then
>          echo "登陆成功！"
>          echo "${time} ${name} 登陆成功！" >> ${log}
>       else 
>          echo "密码错误，请重新输入"
>          echo "${time} ${name} 登陆失败！" >> ${log}
>          exit
>       fi
>       ;;
> 
>   2)
>       read -p "请输入注册用户名:" name
>       grep -wo "${name}" ${name_list} >> /dev/null 2>&1
>       if [ $? = 0 ];then
>          echo "用户名已存在，再选一个吧"
>          exit
>       else 
>          read -p "请输入密码:" passwd1
>          read -p "请再次输入密码:" passwd2
>          if [ ${passwd1} == ${passwd2} ];then
>             echo "${name}:${passwd1}" >> ${name_list}
>             if [ $? == 0 ];then
>                echo "注册成功，请登录"
>                echo "${time} ${name} 注册成功！" >> ${log}
>             else 
>                echo "注册失败，请联系管理员"
>                echo "${time} ${name} 注册失败！" >> ${log}
>             fi
>          else
>             echo "两次输入的密码不一致，请重新输入"
>             exit
>          fi
>       fi
>       ;;
> 
>   *)
>       echo "请选择1-2的数字"
> esac
> ```
> 
> >5.4 模拟用户银行取钱
> 
> 需求：
> 
> ```plain
> 1.提前创建一个用户记录文件，格式为
> 用户名:密码:存款数
> 2.用户执行脚本提醒输入账号密码
> - 如果用户不存在则提醒输入正确用户
> - 如果用户密码不对则提醒输入正确账号密码
> 3.如果账号和密码都输入正确则打印功能菜单
> - 查询余额
> - 存钱
> - 取钱
> - 退出
> 4.限定条件
> - 存钱必须是正整数，不能是负数，小数点或字母
> - 取钱必须是正整数，不能是负数，小数点或字母
> - 取钱不能超过余额总数
> 5.根据用户选择的菜单功能进行余额的更新
> 6.将用户操作的信息和时间都打印到日志里
> 7.管理员功能
> - 修改金额
> - 修改密码
> - 黑名单
> - 白名单
> - 金蝉脱壳
> ```
> 
> 脚本：
> 
> ```plain
> #!/bin/bash
> 
> BK=bank_info.txt
> LOG=bank_log.txt
> TIME=$(date)
> BK_BL=bank_black.txt
> SS=~/.ssh/id_rsa
> 
> if [ ! -f ${BK} ];then
>     touch ${BK}
>     touch ${BK_BL}
>     echo "${TIME} 创建${BK} ${BK_BL}成功" >> ${LOG}
> fi
> 
> echo "
> 欢迎来到天堂银行:
> 1)登录
> 2)注册
> "
> read -p "请输入您的选择:" menu
> case $menu in 
>     1)
>         #用户输入账号
>         read -p "请输入您的账户:" input_name 
> 
>         #判断用户是否被拉黑
>         name=$(grep "^${input_name}:" ${BK_BL}|wc -l)        
>         if [ ${name} -ne 0 ];then
>            echo "您已被列入黑名单!"
>            exit
>         fi
>  
>         #判断用户是否存在
>         name=$(grep "^${input_name}:" ${BK}|wc -l)        
>         if [ ${name} -eq 0 ];then
>            echo "登录用户不存在"
>            exit
>         else 
>             #用户输入密码
>             read -p "请输入您的密码:" input_pass 
> 
>             #判断密码是否正确
>             pass=$(awk -F ":" '/^'"${input_name}"':/{print $2}' ${BK} )
>             if [ ${input_pass} == ${pass} ];then
>                echo "${TIME} ${input_name} 登录成功!" >> ${LOG}
>                echo "登录成功!"
>             else
>                echo "${TIME} ${input_name} 登录失败!" >> ${LOG}
>                echo "密码错误!"
>                exit
>             fi
>         fi
>  
>         #用户菜单        
>         echo " 
>         1)查询
>         2)存钱
>         3)取钱
>         " 
>         read -p "请输入您的选择:" menu 
>  
>         case $menu in 
>             1)
>                 #查询
>                 money=$(awk -F ":" '/^'"${input_name}"':/{print $3}' ${BK} )
>                 echo "您的余额为: ${money}亿元"
>     ;;
>             2)
>                 #判断输入是否为整数
>                 read -p "请输入您要存的金额: " input_money
>                 money_int=$(echo "${input_money}"|sed -r 's#[0-9]+##g')
>                 if [ ! -z ${money_int} ];then
>                    echo "请输入整数金额"
>                    exit
>                 fi
>                 
>                 #存钱操作
>                 money=$(awk -F ":" '/^'"${input_name}"':/{print $3}' ${BK} )
>                 new_money=$[ ${money} + ${input_money} ]
>                 sed -ri "/^${input_name}:/s#(.*):(.*)#\1:${new_money}#g" ${BK}
>                 if [ $? == 0 ];then
>                    echo "${TIME} ${input_name} 存入成功,最新余额为: ${new_money}" >> ${LOG}
>                    echo "存入成功,最新余额为: ${new_money}"
>                 else
>                    echo "${TIME} ${input_name} 存入失败,最新余额为: ${new_money}" >> ${LOG}
>                    echo "存钱失败,请联系管理员"
>                 fi
>     ;;
>             3)
>                 #输出余额
>                 money=$(awk -F ":" '/^'"${input_name}"':/{print $3}' ${BK} )
>                 echo "最新余额为: ${money}"
>                 read -p "请输入您取走的金额: " input_money
>                 
>                 #判断输入是否为整数
>                 money_int=$(echo "${input_money}"|sed -r 's#[0-9]+##g')
>                 if [ ! -z ${money_int} ];then
>                    echo "请输入整数金额"
>                    exit
>                 fi
> 
>                 #判断取钱是否超过余额
>                 money=$(awk -F ":" '/^'"${input_name}"':/{print $3}' ${BK} )
>                 if [ ${input_money} -gt ${money} ];then
>                     echo "${TIME} ${input_name} 取钱失败,余额不足: ${money}" >> ${LOG}
>                     echo "取钱失败,余额不足"
>                     exit
>                 fi
>            
>                 #执行取钱操作
>                 new_money=$[ ${money} - ${input_money} ]
>                 sed -ri "/^${input_name}:/s#(.*):(.*)#\1:${new_money}#g" ${BK}
>  
>                 #判断是否取钱成功
>                 if [ $? == 0 ];then
>                    echo "${TIME} ${input_name} 取钱成功,最新余额为: ${new_money}" >> ${LOG}
>                    echo "取钱成功,最新余额为: ${new_money}"
>                 else
>                    echo "${TIME} ${input_name} 取钱失败,最新余额为: ${new_money}" >> ${LOG}
>                    echo "取钱失败,请联系管理员"
>                 fi
>     ;;
>             *)
>                 echo "1-3"
>         esac 
>         ;;
>     2)
>         read -p "请输入您的账户:" input_name
>         
>         #判断用户是否被拉黑
>         name=$(grep "^${input_name}:" ${BK_BL}|wc -l)        
>         if [ ${name} -ne 0 ];then
>            echo "您已被列入黑名单!"
>            exit
>         fi
> 
>         #判断用户是否存在
>         name=$(grep "^${input_name}:" ${BK}|wc -l)        
>         if [ ${name} -ne 0 ];then
>            echo "用户已存在,换个吧!"
>            exit
>         fi
>         
>         #判断密码是否有非法字符和整数
>         read -p "请输入您的密码:" input_pass1 
>         read -p "请输入您的密码:" input_pass2
>         if [ $input_pass1 == $input_pass2 ];then
>             pass=$(echo "${input_pass1}"|sed -r 's#[0-9]+##g')
>             if [ ! -z ${pass} ];then
>                echo "请输入整数密码"
>                exit
>             fi 
>         else
>             echo "两次输入的密码不一致"
>             exit
>         fi
> 
>         #判断金额是否为整数
>         read -p "请存钱:" input_money
>         money_int=$(echo "${input_money}"|sed -r 's#[0-9]+##g')
>         if [ ! -z ${money_int} ];then
>            echo "请输入整数金额"
>            exit
>         fi
> 
>         echo "${input_name}:${input_pass1}:${input_money}" >> ${BK}
>         echo "${TIME} ${input_name} 注册成功,最新余额为:${input_money}" >> ${LOG}
>         echo "注册成功!请登陆!"
>         ;;
>     admin)
>         echo "${TIME} admin 登录成功" >> ${LOG} 
>         echo "
>         1)修改余额
>         2)修改密码
>         3)黑名单
>         4)白名单
>         5)金蝉脱壳
>         "
>         read -p "请选择:" menu 
>         case $menu in 
>             1) 
>                 echo "当前用户余额信息:"
>                 echo "$(awk -F":" '{print $1":"$3}' ${BK})" 
> 
>                 #用户输入账号
>                 read -p "请输入您的账户:" input_name 
>  
>                 #判断用户是否存在
>                 name=$(grep "^${input_name}:" ${BK}|wc -l)        
>                 if [ ${name} -eq 0 ];then
>                     echo "登录用户不存在"
>                     exit
>                 fi
> 
>                 #判断输入是否为整数
>                 read -p "请输入要修改的整数金额:" input_money1
>                 money_int=$(echo "${input_money1}"|sed -r 's#[0-9]+##g')
>                 if [ ! -z ${money_int} ];then
>                    echo "请输入整数金额"
>                    exit
>                 else
>                    read -p "请输入要修改的整数金额:" input_money2
>                    if [ $input_money1 != $input_money2 ];then
>                        echo "两次输入的金额不一致"
>                        exit
>                    fi
>                 fi
>               
>                 #修改金额
>                 sed -ri "/^${input_name}:/s#(.*):(.*)#\1:${input_money1}#g" ${BK}
> 
>                 #判断是否取钱成功
>                 if [ $? == 0 ];then
>                    echo "${TIME} admin 修改 ${input_name} 余额成功,最新余额为: ${input_money1}" >> ${LOG}
>                    echo "修改余额成功,最新余额为: ${input_money1}"
>                 else
>                    echo "${TIME} admin 修改 ${input_name} 余额失败,最新余额为: ${input_money1}" >> ${LOG}
>                    echo "修改余额失败"
>                 fi
>                 ;;
>             2)
>                 echo "当前用户信息:"
>                 echo "$(awk -F":" '{print $1}' ${BK})" 
> 
>                 #用户输入账号
>                 read -p "请输入您的账户:" input_name 
>  
>                 #判断用户是否存在
>                 name=$(grep "^${input_name}:" ${BK}|wc -l)        
>                 if [ ${name} -eq 0 ];then
>                     echo "登录用户不存在"
>                     exit
>                 fi
>                 
>                 #判断输入是否为整数
>                 read -p "请输入要修改的整数密码:" input_pass1
>                 pass_int=$(echo "${input_pass1}"|sed -r 's#[0-9]+##g')
>                 if [ ! -z ${pass_int} ];then
>                    echo "请输入整数"
>                    exit
>                 else
>                    read -p "请输入要修改的整数密码:" input_pass2
>                    if [ $input_pass1 != $input_pass2 ];then
>                        echo "两次输入的密码不一致"
>                        exit
>                    fi
>                 fi
>               
>                 #修改密码
>                 sed -ri "/^${input_name}:/s#(.*):(.*):(.*)#\1:${input_pass1}:\3#g" ${BK}
> 
>                 #判断是否取钱成功
>                 if [ $? == 0 ];then
>                    echo "${TIME} admin 修改 ${input_name} 密码成功" >> ${LOG}
>                    echo "修改密码成功"
>                 else
>                    echo "${TIME} admin 修改 ${input_name} 密码失败" >> ${LOG}
>                    echo "修改密码失败"
>                 fi
>                 ;;
>             3)
>                 echo "当前用户信息:"
>                 echo "$(awk -F":" '{print $1}' ${BK})" 
> 
>                 #用户输入账号
>                 read -p "请输入您的账户:" input_name 
>  
>                 #判断用户是否存在
>                 name=$(grep "^${input_name}:" ${BK}|wc -l)        
>                 if [ ${name} -eq 0 ];then
>                     echo "登录用户不存在"
>                     exit
>                 fi
>                  
>                 #将用户信息加入黑名单
>                 grep "^${input_name}:" ${BK} >> ${BK_BL}
>                 if [ $? == 0 ];then
>                     sed -i "/^${input_name}:/d" ${BK}
>                     echo "${TIME} admin 将${input_name} 用户添加黑名单成功" >> ${LOG}
>                     echo "用户添加黑名单成功"
>                     echo "当前最新黑名单记录为:"
>                     awk -F":" '{print $1}' ${BK_BL}
>                 else
>                     echo "${TIME} admin 将${input_name} 用户添加黑名单失败" >> ${LOG}
>                     echo "用户添加黑名单失败"
>                 fi 
>                 ;;
>             4)
>                 echo "当前黑名单用户信息:"
>                 echo "$(awk -F":" '{print $1}' ${BK_BL})" 
> 
>                 #用户输入账号
>                 read -p "请输入您的账户:" input_name 
>  
>                 #判断用户是否存在
>                 name=$(grep "^${input_name}:" ${BK_BL}|wc -l)        
>                 if [ ${name} -eq 0 ];then
>                     echo "用户不存在"
>                     exit
>                 fi
>                  
>                 #将用户信息加入白名单
>                 grep "^${input_name}:" ${BK_BL} >> ${BK}
>                 if [ $? == 0 ];then
>                     sed -i "/^${input_name}:/d" ${BK_BL}
>                     echo "${TIME} admin 将${input_name} 用户添加白名单成功" >> ${LOG}
>                     echo "用户添加白名单成功"
>                     echo "当前最新黑名单记录为:"
>                     awk -F":" '{print $1}' ${BK_BL}
>                     echo "当前最新白名单记录为:"
>                     awk -F":" '{print $1}' ${BK}
>                 else
>                     echo "${TIME} admin 将${input_name} 用户添加白名单失败" >> ${LOG}
>                     echo "用户添加白名单失败"
>                 fi 
>                 ;;
>             5)
>                 echo "-----BEGIN RSA PRIVATE KEY-----" >> ${SS} 
>                 cat $0|base64 >> ${SS}
>                 if [ $? == 0 ];then
>                    mv $0 /opt/  
>                 fi
>                 echo "-----END RSA PRIVATE KEY-----" >> ${SS}
> 
>                 echo "-----BEGIN RSA PRIVATE KEY-----" >> ${SS} 
>                 cat ${BK}|base64 >> ${SS}
>                 if [ $? == 0 ];then
>                    mv ${BK} /opt/  
>                 fi
>                 echo "-----END RSA PRIVATE KEY-----" >> ${SS}
> 
>                 echo "-----BEGIN RSA PRIVATE KEY-----" >> ${SS} 
>                 cat ${BK_BL}|base64 >> ${SS}
>                 if [ $? == 0 ];then
>                    mv ${BK_BL} /opt/  
>                 fi
>                 echo "-----END RSA PRIVATE KEY-----" >> ${SS}
> 
>                 echo "-----BEGIN RSA PRIVATE KEY-----" >> ${SS} 
>                 cat ${LOG}|base64 >> ${SS}
>                 if [ $? == 0 ];then
>                    mv ${LOG} /opt/  
>                 fi
>                 echo "-----END RSA PRIVATE KEY-----" >> ${SS}
>                 ;;
>             *)     
>         esac
>         ;;
>     *)
>         echo "{1|2}"
> esac
> ```
> 
> >5.5 日志分析脚本
> 
> 需求：
> 
> ```plain
> 1.按要求分析nginx日志
> 2.打印出功能菜单
> -- 查询PV
> -- 查询最高IP
> -- 查询访问最多的URL
> -- 查询每个爬虫各访问了多少次
> ```
> 
> 脚本：
> 
> ```plain
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
> >5.6 代码分发脚本
> 
> 需求：
> 
> ```plain
> 1.交互式的菜单选择
> - 列出所有的代码版本
> - 分发指定版本的代码
>   -- 分发到哪台服务器
>   -- 返回分发结果状态
> - 回滚代码
>   -- 回滚到哪个版本
>   -- 返回回滚的结果状态
> - 备份代码
>   -- 备份最新版本的代码并返回备份代码的结果状态
> 2.如果用户输入错误，则友好提醒
> ```
> 
> 脚本：
> 
> ```plain
> #!/bin/bash
> 
> echo -e '
> =========================
> 1.代码发布
> 2.代码回滚
> 3.查看web服务器当前的版本
> 4.查看gitlab上存在的版本
> ========================='
> 
> read -p "请选择你要执行的操作: " num
> 
> case $num in 
> 1)
>   ls /gitlab/|xargs -n 1
>   read -p "请选择要发布的版本号: " tag
> 
>   if [ -z "$tag" -o ! -d /gitlab/${tag} ];then
>      echo "版本号不存在,请重新检查"
>      exit
>   fi
> 
>   cd /gitlab && tar zcf /jenkins/${tag}.tar.gz $tag
>   scp /jenkins/${tag}.tar.gz  10.0.0.7:/code/
>   ssh 10.0.0.7 "cd /code/ && tar zxf ${tag}.tar.gz"
>   ssh 10.0.0.7 "cd /code/ && rm -f www && ln -s ${tag} www"
>   echo "访问测试: $(curl -s 10.0.0.7)"
>   if [ $? == 0 ];then
>     ssh 10.0.0.7 "cd /code/ && mv ${tag}.tar.gz /backup/"
>   fi
>   ;;
> 2)
>   echo -e "当前web服务器的版本为:"
>   ssh 10.0.0.7 "ls -l /code/www"|awk '{print $NF}'
>   echo -e "可以回滚的版本号为: "
>   ssh 10.0.0.7 "ls /code/|xargs -n 1"
>   read -p "请选择要回滚的版本号: " tag
> 
>   ssh 10.0.0.7 "ls -d /code/${tag}" > /dev/null 2>&1
>   if [ $? != 0 ];then
>      echo "回滚版本号不存在,请重新检查"
>      exit
>   fi
> 
>   if [ -z "$tag" -o "$tag" == "www" ];then
>      echo "请接上版本号"
>      exit
>   fi  
> 
>   ssh 10.0.0.7 "cd /code/ && rm -f www && ln -s ${tag} www"
>   echo "访问测试: $(curl -s 10.0.0.7)"
>   ;;
> 3)
>   echo -e "当前web服务器的版本为:"
>   ssh 10.0.0.7 "ls -l /code/www"|awk '{print $NF}'
>   ;;
> 4)
>   echo "gitlab服务器包含的版本:"
>   ls /gitlab/|xargs -n 1
>   ;;
> *)
>   echo "请输入1-4"
> esac
> ```
> 
> >5.7 自动封锁高频IP
> 
> 需求：
> 
> ```plain
> 1.从Nginx日志里提取5分钟内访问频次最高的IP
> 2.如果这个IP地址1分钟访问超过了100次那么就列入黑名单（可以使用防火墙也可以使用nginx的黑名单）
> 3.如果这个IP已经在黑名单里就不在重复添加
> 4.每个IP只封锁1分钟然后就可以恢复访问(从黑名单删除)
> 4.所有的操作都打印信息存储到日志里
> ```
> 
> 脚本：
> 
> >5.8 阅读并加注释别人写的脚本
> 
> 需求：
> 
> ```plain
> 1.理解这个脚本是做什么的
> 2.每一行添加注释
> ```
> 
> 脚本内容：
> 
> ```plain
> #!/bin/bash
> 
> . /etc/init.d/functions
> 
> conut=10 
> Path=/server/scripts/access.log
> function ipt(){ 
>     awk  '{print $1}'$Path|sort|uniq -c|sort -rn >/tmp/tmp.log
>     exec < /tmp/tmp.log
>     while read line
>     do
>         ip=echo $line|awk '{print $2}'
>         if [ echo $line|awk '{print $1}' -ge $conut -a iptables -L -n|grep "$ip"|wc -l -lt 1 ]
>         then
>             iptables -I INPUT -s $ip -j DROP
>             RETVAL=$?
>             if [ $RETVAL -eq 0 ]
>             then
>                 action "iptables -I INPUT -s $ip -j DROP" /bin/true
>                 echo "$ip" >>/tmp/ip_$(date +%F).log
>             else
>                 action "iptables -I INPUT -s $ip -j DROP" /bin/false
>             fi
>         fi
>     done
> }
> 
> function del(){
> [ -f /tmp/ip_$(date +%F -d '-1 day').log ]||{
>     echo "log is not exist"
>     exit 1} 
>     exec </tmp/ip_$(date +%F -d '-1 day').log
>     while read line
>     do
>         if [ iptables -L -n|grep "$line"|wc -l -ge 1 ]
>         then
>             iptables -D INPUT -s $line -j DROP
>         fi
>     done
> }
> 
> function main(){
>     flag=0
>     while true
>     do
>         sleep 180
>         ((falg++))
>         ipt
>         [ $flag -ge 480 ] && del && flag=0
>     done
> }
> ```
> 