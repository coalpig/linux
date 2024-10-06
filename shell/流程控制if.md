---
tags:
  - Shell
---
 
> [!info]- 单分支
> 
> 
> 伪代码：
> 
> ```plain
> if [ 你是男孩子 ];then
>    出门在外要保护好自己
> fi
> 
> if [ 你是女孩子 ]
> then
>    无论什么时候都不要相信男人说的话
> fi
> ```
> 
> 举例：
> 
> ```plain
> [root@m-61 ~/scripts]# cat if-1.sh 
> #!/bin/bash
> 
> if [ "$1" -eq "$2" ]
> then
>    echo "ok"
> fi
> 
> [root@m-61 ~/scripts]# bash if-1.sh 2 2
> ok
> [root@m-61 ~/scripts]# bash if-1.sh 2 4
> [root@m-61 ~/scripts]#
> ```
> 

> [!info]- 双条件分支
> 
> 
> 伪代码：
> 
> ```plain
> if [ 你是男孩子 ]
> then
>    出门在外要保护好自己
> else
>    不要相信男人说的话
> fi
> ```
> 
> 举例：
> 
> ```plain
> if [ "$1" -eq "$2" ]
> then
>    echo "ok"
> else
>    echo "error"
> fi
> ```
> 

> [!info]- 多条件分支
> 
> 
> ```plain
> if [ 你是男孩子 ];then
>     出门在外要保护好自己
> elif [ 你是女孩子 ];then
>     不要相信男人说的话
> else 
>     你是吃什么长大的
> fi
> ```
> 
> 举例：
> 
> ```plain
> #!/bin/bash
> 
> if [ $1 -eq $2 ];then
>    echo "=="
> elif [ $1 -gt $2 ];then
>    echo ">"
> else 
>    echo "= or >"
> fi
> ```
> 


> [!test]- if练习题
> 
> 
> >4.1 完善的计算机脚本
> 
> ```plain
> #!/bin/bash
> 
> #read -p "请输入:" memu 
> num1=$1
> num2=$2
> int=$(echo ${num1}${num2}|sed -r 's#[0-9]+##g')
> 
> if [ $# -ne 2 ];then
>    echo "请输入2个参数"
>    exit
> elif [ -z ${int} ];then
>    echo "${num1} + ${num2} = $[ ${num1} + ${num2} ]"
>    echo "${num1} - ${num2} = $[ ${num1} - ${num2} ]"
>    echo "${num1} * ${num2} = $[ ${num1} * ${num2} ]"
>    echo "${num1} / ${num2} = $[ ${num1} / ${num2} ]"
> else
>    echo "请输入2个整数"
> fi
> ```
> 
> >4.2 使用IF选择的计算器
> 
> 需求：
> 
> ```plain
> 1.使用rede读取用户输入的数字和符号
> 2.符号使用菜单供用户选择
> 3.符号使用if作为判断
> 
> 菜单如下：
> 请输入第一个数字：10
> 请输入第二个数字：20
> 请选择运算符号：
> 1. +
> 2. - 
> 3. *
> 4. / 
> 请输入您的选择：1
> 
> 显示结果：
> 10 + 20 = 30
> ```
> 
> 脚本：
> 
> ```plain
> #!/bin/bash
> 
> read -p "请输入要计算的第一个数字: " num1
> read -p "请输入要计算的第二个数字: " num2
> echo -e "请选择运算符号：
> 1. + 
> 2. - 
> 3. * 
> 4. /"
> 
> read -p "请输入您的选择: " fuhao
> 
> if [ $fuhao == 1 ];then
>    echo "$num1 + $num2 = $(( $num1 + $num2 ))"
> elif [ $fuhao == 2 ];then
>    echo "$num1 - $num2 = $(( $num1 - $num2 ))"
> elif [ $fuhao == 3 ];then
>   echo "$num1 * $num2 = $(( $num1 * $num2 ))"
> elif [ $fuhao == 4 ];then
>   echo "$num1 / $num2 = $(( $num1 / $num2 ))"
> else 
>   echo "请输入1-4"
> fi
> ```
> 
> 加入输错判断的脚本:
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
> if [ $fuhao == 1 ];then
>    echo "$num1 + $num2 = $(( $num1 + $num2 ))"
> elif [ $fuhao == 2 ];then
>    echo "$num1 - $num2 = $(( $num1 - $num2 ))"
> elif [ $fuhao == 3 ];then
>   echo "$num1 * $num2 = $(( $num1 * $num2 ))"
> elif [ $fuhao == 4 ];then
>   echo "$num1 / $num2 = $(( $num1 / $num2 ))"
> else 
>   echo "请输入1-4"
> fi
> ```
> 
> >4.3 备份文件，如果目录不存在就自动创建
> 
> ```plain
> #!/bin/bash
> 
> if [ -e /backup/ ];then
>    echo "目录已经存在"
> else
>    mkdir /backup/ -p
> ```
> 
> >4.4 接上一题，判断备份的文件是否存在，如果不存在就提示，然后推出
> 
> ```plain
> #!/bin/bash 
> 
> if [ -e /backup/ ];then
>    echo "目录已经存在"
> else
>    mkdir /backup/ -p
> fi
> 
> if [ -f /backup/tar.gz ];then
>    echo "文件已经存在"
> else
>    echo "备份文件中..."
>    echo "文件已经创建"
> fi
> ```
> 
> >4.5 接上一题，判断备份文件是否为空，如果空就提示，然后推出
> 
> ```plain
> if [ -e /backup/ ];then
>    echo "目录已经存在"
> else
>    mkdir /backup/ -p
> fi
> 
> if [ -f /backup/tar.gz ];then
>    echo "文件已经存在"
> else
>    echo "备份文件中..."
>    echo "文件已经创建"
> fi
> 
> if [ -s /backup/tar.gz ];then
>    echo "文件为空"
> else
>    echo "文件不为空"
> fi
> ```
> 
> >4.6 用户执行脚本，传递一个参数作为服务名，检查服务状态。
> 
> ```plain
> #!/bin/bash
> 
> if [ $# -eq 1 ];then 
>     #检查服务的状态
>     systemctl status $1 &>/dev/null 
>     #判断服务运行的结果
>     if [ $? -eq 0 ];then
>         echo "$1 服务正在运行" 
>     else
>         echo "$1 服务没有运行" 
>     fi
> else
>     echo "USAGE: sh $0 service_name"
>     exit 
> fi
> ```
> 
> >4.7 查看磁盘/当前使用状态，如果使用率超过30%则报警发邮件
> 
> 梳理思路：
> 
> ```plain
> 1.查看磁盘分区的状态命令是什么？
> 2.提取/分区的状态百分比命令是什么？
> 3.将提取出来的状态百分比和我们设置的阈值进行对比，超过30%报警，不超过就不处理
> 4.将处理结果写入到文件里
> ```
> 
> 脚本：
> 
> ```plain
> #!/bin/bash
> 
> #1.提取磁盘使用的百分比
> Disk_Status=$(df -h | grep '/$' |awk '{print $5}'|sed 's#%##g')
> Time=$(date +%F-%T)
> 
> #2.判断磁盘使用百分比是否超过30，如果超过，则写入一个文件中。 
> if [ ${Disk_Status} -ge 30 ];then
>     echo "${USER}:${Time}: Disk Is Use ${Disk_Status}" >> /tmp/disk_use.txt
> fi
> ```
> 
> >4.8 判断用户输入的内容是否为空，如果为空或者直接按回车，则提醒，否则输出用户输入的内容。
> 
> ```plain
> #!/bin/bash
> 
> read -p "请输入内容: " word
> 
> if [ -z ${word} ];then
>     echo "输入的内容为空."
> else
>     echo "输入的内容为：${word}" 
> fi
> ```
> 
> >4.9 编写一个用来检查用户的uid和gid是否一致的脚本
> 
> ```plain
> 1.使用交互式接收用户输入的用户名作为参数
> 2.如果用户不存在，就输出提醒然后退出脚本
> 3.如果用户存在，判断这个用户的uid和gid是否一致
> 4.如果uid和gid一致，则输出正确信息并打印出用户的uid和gid，如果不一致则输出实际的uid和gid
> ```
> 
> 思路：
> 
> ```plain
> 1.判断用户是否存在的命令是什么？
> 2.提取uid和gid的命令是什么？
> 3.对比uid和gid的命令是什么？
> ```
> 
> 第一种写法：思考，这样写有没有问题
> 
> ```plain
> #!/bin/bash
> 
> USER=$1
> USER_OK=$(grep -w "^${User}" /etc/passwd|wc -l)
> UID=$(awk -F":" "\$1 ~ /^${User}$/"'{print $3}' /etc/passwd)
> GID=$(awk -F":" "\$1 ~ /^${User}$/"'{print $4}' /etc/passwd)
> 
> if [ "${USER_OK}" -eq 1 ] && [ "${UID}" -eq "${GID}" ];then
>     echo "用户uid与gid一致"
>     echo "UID: ${UID}"
>     echo "GID: ${GID}"
> elif [ "${USER_OK}" -eq 1 -a "${UID}" ! -eq "${GID}" ];then
>     echo "用户uid与gid不一致"
>     echo "UID: ${UID}"
>     echo "GID: ${GID}"
> else
>     echo "查询的用户不存在" 
> fi
> ```
> 
> 完善的判断脚本：
> 
> ```plain
> #!/bin/bash
> 
> USER=$1
> USER_Ok=$(grep -w "^${User}" /etc/passwd|wc -l)
> UID=$(awk -F":" "\$1 ~ /^${User}$/"'{print $3}' /etc/passwd)
> GID=$(awk -F":" "\$1 ~ /^${User}$/"'{print $4}' /etc/passwd)
> 
> #1.判断是否存在这个用户
> if [ "${USER_Ok}" -eq 0 ];then
>     echo "查询的用户用户不存在"
>     exit
> elif [ "${UID}" -eq "${GID}" ];then
>     echo "用户uid与gid一致"
> else
>     echo "用户uid与gid不一致"
> fi
> 
> echo "UID: ${UID}"
> echo "GID: ${GID}"
> ```
> 
> 难点：
> 
> ```plain
> 1.awk如何使用变量
> 2.如果用户名字符串有重复的内容如何精确定位
> 3.判断的逻辑如何精简
> ```
> 
> >4.10 成绩查询
> 
> ```plain
> 提醒用户输入自己的成绩
> 1.如果分数大于0小于59则提示需要补考
> 2.如果分数大于60小于85则提示成绩良好
> 3.如果分数大于86小于100提示成绩优秀
> ```
> 
> 脚本:
> 
> ```plain
> #!/bin/bash
> 
> read -p "来查成绩吧：" score
> 
> if [ ${score} -ge 0 ] && [ ${score} -le 59 ];then
>     echo "补考吧兄弟"
> elif [ ${score} -ge 59 ] && [ ${score} -le 85 ];then
>     echo "这次饶你一命"
> elif [ ${score} -ge 86 ] && [ ${score} -le 100 ];then
>     echo "这么厉害，你是吃什么长大的"
> else 
>     echo "查询范围是0-100哦"
>     exit
> fi
> ```
> 
> 思考：这个脚本存在的缺陷
> 
> ```plain
> 1.如果用户输入了多个参数或者没有输入参数呢
> 2.如果用户输入的不是说字而是字符串呢
> ```
> 
> 完善之后的脚本：
> 
> ```plain
> #!/bin/bash
> 
> if [ $# != 0 ];then
>     echo "请不要带参数查询"
>     exit
> else 
>     read -p "来查成绩吧：" score
>     if_num=$(echo "${score}"|sed -r 's#[0-9]+##g')
>     
>     if [ -n "${if_num}" ];then
>         echo "请输入整数"
>         exit 
>     elif [ ${score} -ge 0 ] && [ ${score} -le 59 ];then
>         echo "补考吧兄弟"
>     elif [ ${score} -ge 59 ] && [ ${score} -le 85 ];then
>         echo "这次饶你一命"
>     elif [ ${score} -ge 86 ] && [ ${score} -le 100 ];then
>         echo "这么厉害，你是吃什么长大的"
>     else 
>         echo "查询范围是0-100哦"
>         exit
>     fi
> fi
> ```
> 
> >4.11 判断输入的数字是否为整数方法
> 
> ```plain
> #!/bin/bash
> 
> input=$1 
> 
> #第一种方法
> expr ${input} + 1 > /dev/null 2>&1
> if [ $? != 0 ];then
>     echo "请输入整数"
> fi
> 
> #第二种方法
> num=$(echo ${input}|sed -r 's#^[0-9]+##g')
> if [ -n "${num}" ];then
>     echo "请输入整数"
> fi
> 
> #第三种方法
> if [[ ! "${input}" =~ ^[0-9]+$ ]];then 
>     echo "请输入纯数字"
> fi
> ```
> 
> >4.12 查询nginx服务状态
> 
> ```bash
> #!/bin/bash
> . /etc/init.d/functions
> 
> read -p "
> 1.重载
> 2.重启
> 3.启动
> 4.停止
> 请选择你需要的操作:" num
> 
> if [ "$num" -eq 1 ];then
>    systemctl reload nginx
>    if [ $? -eq 0 ];then
>       action 停止成功 /bin/true
>    else
>       action 停止失败 /bin/false
>    fi 
> elif [ "$num" -eq 2 ];then
>    systemctl restart nginx
>    if [ $? -eq 0 ];then
>       action "重启成功" /bin/true
>    else
>       action "重启失败" /bin/false
>    fi   
> elif [ "$num" -eq 3 ];then
>    systemctl start nginx
>    if [ $? -eq 0 ];then
>       action "启动成功" /bin/true
>    else
>       action "启动失败" /bin/false
>    fi   
> elif [ "$num" -eq 4 ];then
>    systemctl stop nginx
>    if [ $? -eq 0 ];then
>       action "停止成功" /bin/true
>    else
>       action "停止失败" /bin/false
>    fi   
> else
>    echo "just 1234"
> fi
> ```
> 

> [!info]- 练习
> 
> 
> ```plain
> 1.猜数字
> 2.多极菜单
> 3.根据选择安装不同软件
> 4.编写服务启动脚本
> 5.编写系统优化脚本
> - 根据系统版本选择对应的YUM源
> - 关闭防火墙和selinux
> - 将时间同步写入定时任务
> - 安装常用软件
> - 修改主机名和IP地址
> 6.日志切割脚本
> ```
> 