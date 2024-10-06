---
tags:
  - Shell
---

- ~ 数组介绍

数组主要是用来存值，只不过可以存储多个值。

- ~ 数组分类

```plain
普通数组: 当一个数组定义多个值，需要取值时，只能通过整数来 取值 0 1 2 3 4 5
关联数组:他可以自定义索引名称，当需要取值时，只需要通过 数组的名称[索引] ---> 值
```

> [!info]- 数组的赋值与取值
> 
> 
> >不用数组取内容
> 
> ```plain
> #!/bin/bash
> 
> name_list="user1 user2 user3 user4"
> num=0
> num2=0
> 
> for i in ${name_list}
> do
>     num=$[ $num + 1 ]
>         if [ "$num" == "3" ];then
>            echo $i
>         fi
> done
> 
> for i in ${name_list}
> do
>     num2=$[ $num2 + 1 ]
>         if [ "$i" == "user3" ];then
>            echo $num2
>         fi
> done
> ```
> 
> >普通数组赋值
> 
> [root@m-61 ~/scripts]# books=(linux nginx shell)
> 
> >关联数组赋值
> 
> 注意: 必须先声明这是关联数组
> 
> [root@m-61 ~/scripts]# declare -A info
> 
> 方法1:（数组名=( [索引1]=值1 [索引2]=值2) ）
> 
> ```plain
> [root@m-61 ~/scripts]# info=([index1]=linux [index2]=nginx [index3]=docker [index4]='bash shell') 
> [root@m-61 ~/scripts]# echo ${info[@]}
> bash shell linux nginx docker
> [root@m-61 ~/scripts]# echo ${!info[@]}
> index4 index1 index2 index3
> ```
> 
> 方法2:( 数组名[索引]=变量值 )
> 
> ```plain
> [root@m-61 ~/scripts]# info2[index1]=value1
> [root@m-61 ~/scripts]# info2[index2]=value2
> [root@m-61 ~/scripts]# info2[index3]=value3
> ```
> 
> >取单个值
> 
> ```plain
> [root@m-61 ~/scripts]# echo ${books[0]}
> linux
> [root@m-61 ~/scripts]# echo ${books[1]}
> nginx
> [root@m-61 ~/scripts]# echo ${books[2]}
> shell
> [root@m-61 ~/scripts]# echo ${info2[index1]}
> value1
> [root@m-61 ~/scripts]# echo ${info2[index2]}
> value2
> [root@m-61 ~/scripts]# echo ${info2[index3]}
> value3
> ```
> 
> >取所有值
> 
> ```plain
> [root@m-61 ~/scripts]# echo ${books[@]}
> linux nginx shell
> [root@m-61 ~/scripts]# echo ${info2[@]}    
> value1 value2 value3
> ```
> 
> >取出所有索引
> 
> ```plain
> [root@m-61 ~/scripts]# echo ${!books[@]}
> 0 1 2
> [root@m-61 ~/scripts]# echo ${!info2[@]}  
> index1 index2 index3
> ```
> 
> >数组取值小结
> 
> ```plain
> echo ${!array[*]}  #取关联数组所有键
> echo ${!array[@]}  #取关联数组所有键
> echo ${array[*]}   #取关联数组所有值
> echo ${array[@]}   #取关联数组所有值
> echo ${#array[*]}  #取关联数组长度
> echo ${#array[@]}  #取关联数组长度
> ```
> 

> [!info]- 数组的遍历
> 
> 
> >需求1:统计/etc/passwd里每个用户shell出现的次数
> 
> 脚本：
> 
> ```plain
> [root@m-61 ~/scripts]# cat set.sh 
> #!/bin/bash
> 
> declare -A shell_num
> 
> exec < /etc/passwd 
> while read line
> do
>     shell=$(echo $line | awk -F ":" '{print $NF}')
> 
>     #要统计谁，就将谁作为索引，然后让其自增
>     let shell_num[$shell]++
> done
>     
> #批量取值
> for item in ${!shell_num[@]}
> do
>     echo "索引是: $item 出现的次数为: ${shell_num[$item]}"
> done
> ```
> 
> 执行结果：
> 
> ```plain
> [root@m-61 ~/scripts]# bash set.sh 
> 索引是: /sbin/nologin 出现的次数为: 18
> 索引是: /bin/sync 出现的次数为: 1
> 索引是: /bin/bash 出现的次数为: 1
> 索引是: /sbin/shutdown 出现的次数为: 1
> 索引是: /sbin/halt 出现的次数为: 1
> ```
> 
> >需求2: 使用数组统计Nginx日志排名前10IP
> 
> 脚本：
> 
> ```plain
> #!/bin/bash
> 
> declare -A IP
> 
> exec < bbs.xxxx.com_access.log 
> while read line
> do
>     num=$(echo $line | awk '{print $1}')
>     #要统计谁，就将谁作为索引，然后让其自增
>     let IP[$num]++
> done
>     
> #批量取值 10.0.0.61 10.0.0.6
> for item in ${!IP[@]}
> do
>     echo "${item} ${IP[$item]}"
> done
> ```
> 
> 如果使用AWK处理，效率要比数组高很多倍
> 
> time awk '{Ip[$1]++} END { for (item in Ip) print Ip[item],item }' bbs.xxxx.com_access.log
> 

> [!test]- 数组练习题
> 
> 
> 需求:
> 
> ```plain
> 文本内容:
> a
> b
> c
> 1
> 2
> 3
> 
> 处理后结果
> 1 a
> 2 b
> 3 c
> ```
> 
> 脚本1:
> 
> ```plain
> #!/bin/bash
> 
> num=$[ $(cat num.txt|wc -l)/2 ]
> 
> S1=($(sed -n "1,$num"p num.txt))
> S2=($(sed -n "$[$num+1],\$"p num.txt))
> 
> for i in $(seq 0 $[$num-1])
> do
>     echo ${S2[$i]} ${S1[$i]}
> done
> ```
> 
> 脚本2:
> 
> ```plain
> #!/bin/bash
> 
> num=$[ $(cat num.txt|wc -l)/2 ]
> 
> for i in $(seq 1 $num)
> do
>     S1=$(sed -n "$i"p num.txt)
>     S2_num=$[ $i + $num ]
>     S2=$(sed -n "$S2_num"p num.txt)
>     echo ${S2} ${S1}
> done
> ```
> 
> 