---
tags:
  - Shell
---

> [!info]- 函数的作用
> 
> 
> 函数的作用就是将需要重复运行的代码抽象出来然后封装成一个函数，后续需要使用的时候只需要引用函数就可以了，而不需要每次都写重复的内容。
> 

> [!info]- 函数的定义和调用
> 
> 
> >2.1 定义函数的两种方法
> 
> 第一种方法
> 
> ```plain
> start(){
>     command
> }
> ```
> 
> 第二种方法
> 
> ```plain
> function start(){
>     command
> }
> ```
> 
> >2.2 函数调用的方法
> 
> ```plain
> start(){
>     command
> }
> 
> function stop(){
>     command
> }
> 
> start
> stop
> ```
> 

> [!info]- 函数的传参
> 
> 
> >3.1 函数传参介绍
> 
> ```plain
> 1.用户执行脚本传递的位置参数和函数传递的参数事两回事
> 2.函数执行的时候需要将位置参数传递给函数，这样才会将参数带入函数执行。
> ```
> 
> >3.2 举例
> 
> ```plain
> #!/bin/bash
> 
> fun1() {
>     case $2 in 
>         +)
>             echo "$1 + $3 = $[ $1 + $3 ]"
>             ;;
>         -)
>             echo "$1 + $3 = $[ $1 + $3 ]"
>             ;;
>         x)
>             echo "$1 * $3 = $[ $1 * $3 ]"
>             ;;
>         /) 
>             echo "$1 + $3 = $[ $1 + $3 ]"
>             ;;
>         *)
>             echo "bash $0 num1 {+|-|x|/} num2"
>     esac
> }
> 
> fun1 $1 $2 $3
> ```
> 

> [!test]- 函数的练习
> 
> 
> >4.1 编写nginx管理脚本
> 
> ```plain
> #!/bin/bash
> 
> UAGE(){
>     echo "UAGE: bash $0 {start|stop|restart}"
> }
> 
> start_nginx(){
>     echo "nginx is start"
> }
> 
> stop_nginx(){
>     echo "nginx is stop"
> }
> 
> case $1 in 
>     start)
>       start_nginx
>       ;;
>     stop)
>       stop_nginx
>       ;;
>     restart)
>       stop_nginx
>       start_nginx
>       ;;
>     *)
>       UAGE
> esac
> ```
> 
> >4.2 编写多极菜单
> 
> ```plain
> #!/bin/bash
> 
> #1级菜单
> menu1(){
> echo "
> -----------------------------
> 1.Install Nginx
> 2.Install PHP
> 3.Install MySQL
> 4.Quit
> -----------------------------
> "
> }
> 
> 
> #2级菜单
> menu2(){
> echo "
> -----------------------------
> 1.Install Nginx1.15
> 2.Install Nginx1.16 
> 3.Install Nginx1.17 
> 4.返回上一层
> -----------------------------
> "
> }
> 
> #打印1级菜单
> menu1
> 
> while true
> do
>     #选择1级菜单
>     read -p "选择对应的数字:" num1
> 
>     case $num1 in 
>        1)
>            #打印2级菜单
>            menu2 
>            while true
>            do
>                read -p "请选择您要安装的Nginx版本: " num2
>                case $num2 in 
>                    1)
>                        echo "Install Nginx1.15 is OK!"
>                        ;;
>                    2)
>                        echo "Install Nginx1.16 is OK!"
>                        ;;
>                    3)
>                        echo "Install Nginx1.17 is OK!"
>                        ;;
>                    4)
>                        clear
>                        menu1
>                        break
>                        ;;
>                    *)
>                        continue
>                esac 
>            done
>            ;;    
>        2)
>            echo "Install PHP"
>            ;;
>        3)
>            echo "Install Mysql"
>            ;;
>        4)
>            exit
>            ;;
>        *) 
>            continue
>     esac
> done
> ```
> 
> >4.3 深圳6期多级菜单脚本
> 
> 原始脚本:
> 
> ```plain
> #!/bin/bash
> while true
> do 
>   echo -e "
>   1.Install Nginx
>   2.Install PHP
>   3.Quit"
>   
>   read -p "please input num" num
>   
>   case $num in 
>   1)
>     while true
>     do
>       echo -e "
>       1.Install Nginx1.15
>       2.Install Nginx1.16 
>       3.Install Nginx1.17 
>       4.return"
>       
>       read -p "please input num" num
>       
>       case $num in 
>       1)
>         echo "Nginx1.15 is installed"
>         break
>       ;;
>       2)
>         echo "Nginx1.16 is installed"
>         break
>       ;;
>       3)
>         echo "Nginx1.17 is installed"
>         break
>       ;;
>       4)
>         break
>           ;;
>       *)
>         echo "1-4"
>       esac
>     done
>     ;;
>   2)
>     while true
>     do
>       echo -e "
>       1.Install php-5.5
>       2.Install php-5.7
>       3.Install php-7.2
>       4.return"
>       
>       read -p "please input num" num
>       
>       case $num in 
>       1)
>         echo "php-5.5 is installed"
>         break
>       ;;
>       2)
>         echo "php-5.7 is installed"
>         break
>       ;;
>       3)
>         echo "php-7.2 is installed"
>         break
>       ;;
>       4)
>         break
>     ;;
>       *)
>         echo "1-4"
>       esac
>     done
>     ;;
>   3)
>     exit
>     ;;
>   *)
>     echo "1-3"
>   esac
> done
> ```
> 
> 函数脚本:
> 
> ```plain
> #!/bin/bash
> menu(){
>   echo -e "
>   1.Install Nginx
>   2.Install PHP
>   3.mysql
>   4.Quit"
> }
> 
> nginx(){
>     while true
>         do
>           echo -e "
>           1.Install Nginx1.15
>           2.Install Nginx1.16 
>           3.Install Nginx1.17 
>           4.return"
>           
>           read -p "please input num" num
>           
>           case $num in 
>           1)
>             echo "Nginx1.15 is installed"
>             break
>           ;;
>           2)
>             echo "Nginx1.16 is installed"
>             break
>           ;;
>           3)
>             echo "Nginx1.17 is installed"
>             break
>           ;;
>           4)
>             break
>               ;;
>           *)
>             echo "1-4"
>           esac
>         done
> }
> 
> php(){
>     while true
>     do
>       echo -e "
>       1.Install php-5.5
>       2.Install php-5.7
>       3.Install php-7.2
>       4.return"
>       
>       read -p "please input num" num
>       
>       case $num in 
>       1)
>         echo "php-5.5 is installed"
>         break
>       ;;
>       2)
>         echo "php-5.7 is installed"
>         break
>       ;;
>       3)
>         echo "php-7.2 is installed"
>         break
>       ;;
>       4)
>         break
>     ;;
>       *)
>         echo "1-4"
>       esac
>     done
> }
> 
> mysql(){
>     while true
>     do
>       echo -e "
>       1.Install mysql-5.5
>       2.Install mysql-5.7
>       3.Install mysql-7.2
>       4.return"
>       
>       read -p "please input num" num
>       
>       case $num in 
>       1)
>         echo "mysql-5.5 is installed"
>         break
>       ;;
>       2)
>         echo "mysql-5.7 is installed"
>         break
>       ;;
>       3)
>         echo "mysql-7.2 is installed"
>         break
>       ;;
>       4)
>         break
>     ;;
>       *)
>         echo "1-4"
>       esac
>     done
> }
> 
> 
> main(){
>   while true
>   do 
>     menu
>     read -p "please input num" num
>     case $num in 
>     1)
>       nginx
>       ;;
>     2)
>       php
>       ;;
>     3)
>       mysql
>       ;;
>   4)
>     exit
>     ;;
>     *)
>       echo "1-3"
>     esac
>   done
> }
> 
> main
> ```
> 
> >4.3 编写跳板机脚本
> 
> ```plain
> #!/bin/bash
> 
> memu(){
> echo"
>     ===================
>     |   1.lb-5        | 
>     |   2.lb-6        |
>     |   3.web-7       |
>     |   4.web-8       |
>     |   5.exit        |
>     ===================
> "    
> 
> trap "" HUP INT QUIT TSTP
> 
> while true
> do
>     memu
>     read -p "请输入需要登陆的主机：" num
>     case $num in
>         1)
>             ssh root@10.0.0.5 
>             ;;
>         2)
>             ssh root@10.0.0.6
>             ;;
>         3)
>             ssh root@10.0.0.7
>             ;;
>         4)
>             ssh root@10.0.0.8
>             ;;
>         5)
>             exit
>             ;;
>         *)
>             continue 
>     esac 
> done
> ```
> 
> >综合练习题-将用户登陆注册功能修改为函数版本
> 
> 需求：
> 
> 把ATM机的用户登陆注册用函数，case,while，continue实现所有功能
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
> menu(){
>     echo "
>     ===========
>     1.登陆
>     2.注册
>     ===========
>     "
>     read -p "请选择需要的操作:" menu 
> }
> 
> check_login_name(){
>     read -p "请输入用户名:" name
>     grep -wo "${name}" ${name_list} >> /dev/null 2>&1
>     if [ $? != 0 ];then
>         echo "用户名不存在，请重新输入"
>         check_login_name
>     fi
> }
> 
> check_login_pass(){
>     read -p "请输入密码:" passwd_input
>     passwd_user=$(awk -F":" "/^${name}\:/"'{print $2}' ${name_list})
>     #passwd_user=$(sed -rn "s#${name}:(.*)#\1#g"p bank.txt)
>     if [ ${passwd_input} == ${passwd_user} ];then
>        echo "登陆成功！"
>        echo "${time} ${name} 登陆成功！" >> ${log}
>        exit
>     else 
>        echo "密码错误，请重新输入"
>        echo "${time} ${name} 登陆失败！" >> ${log}
>        check_login_pass
>     fi
> }
> 
> check_regist_name(){
>     read -p "请输入注册用户名:" name
>     grep -wo "${name}" ${name_list} >> /dev/null 2>&1
>     if [ $? = 0 ];then
>        echo "用户名已存在，再选一个吧"
>        check_regist_name
>     fi
> }
> 
> check_regist_pass(){
>     read -p "请输入密码:" passwd1
>     read -p "请再次输入密码:" passwd2
>     if [ ${passwd1} == ${passwd2} ];then
>        echo "${name}:${passwd1}" >> ${name_list}
>        if [ $? == 0 ];then
>           echo "注册成功，请登录"
>           echo "${time} ${name} 注册成功！" >> ${log}
>           main
>        else 
>           echo "注册失败，请联系管理员"
>           echo "${time} ${name} 注册失败！" >> ${log}
>           exit
>        fi
>     else
>        echo "两次输入的密码不一致，请重新输入"
>        check_regist_pass
>     fi
> }
> 
> main(){
>     while true
>     do
>         menu
>         case ${menu} in 
>         1)
>             check_login_name
>             check_login_pass
>             ;;
>         
>         2)
>             check_regist_name
>             check_regist_pass
>             ;;
>         
>         *)
>             echo "请选择1-2的数字"
>             main
>     esac
>     done
> }
> 
> main
> ```
> 
> >综合练习练习题-用户登录注册函数改写
> 
> ```plain
> #!/bin/bash
> 
> #定义登录函数
> check_login(){
>   read -p "请输入用户名:" input_username
>   check_name=$(grep "^$input_username:" name.txt |wc -l)
>   if [ $check_name == 0 ];then
>      echo "账户名不存在"
>      exit
>   fi  
> 
>   read -p "请输入密码:" input_passwd
>   pass=$(awk -F: "/^${input_username}:/"'{print $2}' name.txt)
>   if [ $pass == $input_passwd ];then
>      echo "登录成功!"
>   else 
>      echo "账号密码错误!"
>      exit
>   fi
> }
> 
> #定义注册函数
> check_regist(){
>   read -p "请输入用户名:" input_username
>   if [ -z "$input_username" ];then 
>      echo "用户名不能为空,请重新输入"
>      exit
>   fi  
> 
>   check_format=$(echo $input_username|egrep '[^0-9a-Z]+'|wc -l )
>   if [ $check_format != 0 ];then 
>      echo "输入的用户名不能包含特殊字符" 
>      exit
>   fi
> 
>   check_name=$(grep "^$input_username:" name.txt |wc -l)
>   if [ $check_name != 0 ];then
>      echo "账户名已存在,再选一个吧"
>      exit
>   fi
> 
>   input_username_lenth=$(echo ${input_username}|wc -L)
>   if [ "$input_username_lenth" -lt 4 -o "$input_username_lenth" -gt 8 ];then 
>      echo "注册的账号名小于4为并且不能大于8位"
>      exit
>   fi
> 
>   read -p "请输入密码:" input_passwd
>   check_format=$(echo $input_passwd|egrep '[^0-9a-Z]+'|wc -l )
>   if [ $check_format != 0 ];then 
>      echo "输入的密码不能包含特殊字符" 
>      exit
>   fi
>  
>   input_passwd_lenth=$(echo $input_passwd|wc -L)
>   if [ "$input_passwd_lenth" -le 4 -o "$input_passwd_lenth" -gt 8 ];then 
>      echo "注册的密码不能小于4位并且不能大于8位"
>      exit
>   fi 
> 
>   read -p "请再次输入密码:" input_passwd_check
> 
>   if [ "$input_passwd" != "$input_passwd_check" ];then
>      echo "两次输入的密码不一致"
>      exit
>   fi
>   echo "${input_username}:${input_passwd}" >> name.txt
>   echo "注册成功!"
> }
> 
> #定义菜单函数
> menu(){
>   echo -e '
>   ===========
>   1.注册
>   2.登录
>   ==========='
>   read -p "请输入1-2:" num
> }
> 
> #定义主函数
> main(){
>   menu
>   case $num in 
>   1)
>     check_login
>     ;;
>   2)
>     check_regist
>     ;;
>   *)
>     echo "请输入1-2"
>   esac
> }
> 
> #调用主函数
> main
> ```
> 
> >综合练习题-检查服务端口是否开启
> 
> ```plain
> exec < /scripts/ip-ports.txt 
> while read line 
> do 
>     count=0
>     nc -w 10 -z $line >> /tmp/ip.log 2>&1
>     if [ $? -ne 0 ];then
>       for i in {1..3}
>     do
>             nc -w 10 -z $line >> /tmp/ip.log 2>&1
>       if [ $? -ne 0 ];then
>          count=$[ ${count}+1 ]
>       else
>          break
>       fi
>       
>       if [ $count -eq 3 ];then
>          sleep 3
>              echo "民银牛app生产服务器${line}连接不通"|/usr/local/bin/mailx -v -s "test" 1214131982@qq.com >> /tmp/cron.log 2>&1
>             fi
>     done
  fi
done
> ```
