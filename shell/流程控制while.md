---
tags:
  - Shell
---

> [!while循环使用场景]- while循环
> while循环使用场景
> >1.for是明确知道要循环多少次，while可以在不知道要循环多少次的场景下使用
>
> >2.比如如果用户输入错了，可以尝试重新输入，而不是退出
>
> >3.比如除非用户输入了退出指令才退出，否则一直不退出  

> [!info]- 循环基本语法
> 
> 
> ```plain
> while 条件测试      #如果条件成立，则执行循环
> do
>     循环执行的命令
> done
> ```
> 

> [!info]- 用法举例
> 
> 
> >直到满足条件退出
> 
> ```plain
> #!/bin/bash
> 
> num=0
> 
> while [ ${num} -lt 10 ]
> do
>     echo "num is ${num}"
>     num=$[ ${num} + 1 ]
> done
> ```
> 
> >从文件里读取数据
> 
> 方法1:
> 
> ```plain
> exec < test.txt
> while read line
> do
>     echo $line
> done
> ```
> 
> 方法2:
> 
> ```plain
> while read line
> do
>     echo $line
> done < test.txt
> ```
> 
> 方法3:
> 
> ```plain
> cat test.txt|while read line
> do
>     echo $line
> done
> ```
> 

> [!info]- 练习
> 
> 
> >计算器
> 
> 需求：使用while输出如下格式
> 
> ```plain
> 9*1 =9 
> 8*2 =16 
> 7*3 =21 
> 6*4 =24 
> 5*5 =25 
> 4*6 =24
> 3*7 =21
> 2*8 =16
> 1*9 =9
> ```
> 
> 脚本1：
> 
> ```plain
> #!/bin/bash
> 
> num=9
> while [ ${num} -ge 1 ]
> do
>     echo "$num * $num = $[ $num * $num ]"
>     num=$[ $num -1 ]
> done
> ```
> 
> 脚本2:
> 
> ```plain
> #!/bin/bash
> 
> a=9
> b=1
> while [ ${a} -ge 1 ]
> do
>     echo "$a * $b = $[ $a * $b ]"
>     a=$[ $a -1 ]
>     b=$[ $b -1 ]
> done
> ```
> 
> >直到输对了才退出
> 
> 需求：
> 
> ```plain
> 1.提示用户输入账号
> 2.除非输入了root，否则一直提示输入
> ```
> 
> 脚本：
> 
> ```plain
> #!/bin/bash
> while [ "$user" != "root" ]
> do
>     read -p "请输入root:" user
> done
> ```
> 
> >从文本里获取要创建的用户名:密码:uid:gid
> 
> ```plain
> #!/bin/bash 
> 
> exec < name.txt
> while read line 
> do
>     GROUP=$(echo ${line}|awk -F ":" '{print $1}')
>     GID=$(echo ${line}|awk -F ":" '{print $4}')
>     USER=$(echo ${line}|awk -F ":" '{print $1}')
>     UID=$(echo ${line}|awk -F ":" '{print $3}')
>     PASS=$(echo ${line}|awk -F ":" '{print $2}')
>     groupadd ${GROUP} -g ${GID}
>     useradd ${USER} -u ${UID} -g ${GID}
>     echo ${PASS}|passwd --stdin
> done
> ```
> 
> >猜数字游戏
> 
> 需求
> 
> ```plain
> 1.随机生成一个1-100的数字 
> 2.要求用户输入的必须是数字 
> 3.友好提示，如果用户输入的数字比随机数大，则提醒大了，否则提醒小了
> 4.只有输入正确才退出，输入错误就一直循环 
> 5.最后统计猜了多少次
> ```
> 
> 6期脚本:
> 
> ```plain
> 需求: 猜数字大小
> 用户输入一个数字
> 如果大了,提示大了
> 如果小了,提示小了
> 提示完不退出,继续猜
> 如果猜中了,提示中奖了并退出
> 
> 脚本如下:
> #!/bin/bash
> 
> ok_num=$(echo $[$RANDOM%100 + 1])
> read -p "please input num:" num
> 
> while [ "${num}" != "${ok_num}" ]
> do
>   if [ "$num" -lt "$ok_num" ];then
>      echo "小了"
>   else
>      echo "大了"
>   fi
>   read -p "please input num:" num
> done
> 
> echo "去领奖吧"
> ```
> 
> 脚本：
> 
> ```plain
> #!/bin/bash
> 
> sj=$(echo $[$RANDOM%100 + 1])
> count=0
> 
> while true
> do
>     read -p "来下注吧,请输入整数: " num
>     count=$[ $count+1 ]
>     if [ ! -z $(echo ${num}|sed -r 's#[0-9]+##g') ];then
>         echo "你是zzy吗?"
>         continue
>     fi
> 
>     if [ $num == $sj ];then
>        echo "您成功打爆了zzy的gt ${count}次! 正确数字为: $sj"
>        exit
>     fi
> 
>     if [ $num -gt $sj ];then
>         echo "你输大了"
>     else
>         echo "你输小了"
>     fi
> 
> done
> ```
> 
> 外挂脚本:
> 
> ```plain
> #!/bin/bash
> 
> #for方法
> #for i in {1..100}
> #do
> #  jieguo=$(bash while_v2.sh ${i})
> #  if [ "$jieguo" == "去找浩斌领奖吧" ];then
> #     echo "中奖数字为: ${i}"
> #     exit
> #  fi
> #done
> 
> #while方法
> num=0
> jieguo=0
> while [ "$jieguo" != "去找浩斌领奖吧" ]
> do
>    jieguo=$(bash while_v2.sh ${num})
>    num=$[ $num + 1 ]
> done
> echo "$[ $num - 1 ]"
> ```
> 
> >限制输错次数
> 
> ```plain
> #!/bin/bash
> ok_num=10
> num=1
> while true
> do
>    read -p "please input num:" input_num
>    if [ "$input_num" -eq ${ok_num} ];then
>       echo "你猜对了"
>       exit
>    else 
>       echo "你输错了"
>       echo "你还有 $[ 3 - $num ] 次机会"
>    fi
> 
>    if [ "$num" -eq 3 ];then
>       echo "你输错太多了"  
>       exit
>    fi
>    num=$[ num + 1 ]
> done
> ```
> 
> >不退出的菜单
> 
> ```plain
> #!/bin/bash
> 
> while true 
> do
>     read -p "请输入您的选择:" num
>     case $num in
>         1)
>             echo "选择1"
>             ;;
>         2)
>             echo "选择2"
>             ;;
>         3)
>             echo "选择3"
>             ;;
>         exit)
>             echo "bye"
>             exit
>             ;;
>         *)   
>             echo "选择1-3"
>     esac
> done
> ```
> 
> >跳板机脚本
> 
> ```plain
> #!/bin/bash
> 
> trap "" HUP INT QUIT TSTP
> 
> while true
> do
>     echo "
>         ===================
>         |   1.lb-5        | 
>         |   2.lb-6        |
>         |   3.web-7       |
>         |   4.web-8       |
>         |   5.exit        |
>         ===================
>     "    
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