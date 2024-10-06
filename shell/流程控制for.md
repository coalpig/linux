---
tags:
  - Shell
---

> [!info]- for循环使用场景
> 
> 
> ```plain
> 1.一次处理不完的任务或者需要重复执行多次的任务
> 2.比如创建生成100个用户，创建100个文件，批量判断文件是否存在等
> ```
> 

> [!info]- 循环基本语法
> 
> 
> ```plain
> for 变量名 in  取值列表
> do
>     每次循环要执行的内容
> done
> ```
> 

> [!info]- for循环的几种方法
> 
> 
> >3.1 手动给定多个字符串
> 
> 举例1：
> 
> ```plain
> #!/bin/bash
> 
> for name in name1 name2 name3
> do
>    echo ${name}
> done
> ```
> 
> 举例2: 提问，请问输出的是几个值
> 
> ```plain
> #!/bin/bash
> 
> for name in name1 "name2 name3" name4 "name5 name6" 
> do
>    echo ${name}
> done
> ```
> 
> >3.2 从变量里取值
> 
> ```plain
> #!/bin/bash
> 
> name_list="name1 name2 name3"
> 
> for name in ${name_list}
> do
>   echo "${name}"
> done
> ```
> 
> >3.3 从文件里取值
> 
> ```plain
> #!/bin/bash
> 
> for name in $(cat /etc/passwd)
> do
>     echo "${name}"|awk -F":" '{print $1}'
> done
> ```
> 
> >3.4 生成数字序列
> 
> 方法1: 
> 
> ```plain
> #!/bin/bash
> 
> for num in {1..100}
> do 
>     echo ${num}
> done
> ```
> 
> 方法2:
> 
> ```plain
> #!/bin/bash
> 
> for  (( num=0;num<10;num++ ))
> do 
>     echo ${num}
> done
> ```

> [!info]- for练习题
> 
> 
> >批量检测网段里存活的主机
> 
> 需求:
> 
> 检查10.0.0.1 - 10.0.0.100范围内存活的主机
> 
> 脚本:
> 
> ```plain
> #!/bin/bash
> 
> > ip.txt
> 
> for ip in {1..254}
> do  
>    ping -w 1 192.168.4.${ip} >> ip.txt &
> done
> 
> echo "存活主机如下:"
> awk -F"[: ]" '/seq/{print $4}' ip.txt|sort -t . -k 4 -n
> ```
> 
> >批量创建用户和密码
> 
> 需求:
> 
> ```plain
> 1.批量创建 user1admin - user10admin 个用户
> 2.密码为admin1user - admin10user
> ```
> 
> >批量创建用户和密码V2
> 
> 需求:
> 
> ```plain
> 用户: user1 - user10
> 密码: passwd10 - passwd1
> ```
> 
> >从指定的文本里给出的用户名密码批量创建用户
> 
> 需求:
> 
> >接上题，加上用户的uid和gid
> 
> >接上题，使用case提供添加和删除和查询功能
> 
> ```plain
> case菜单
> useradd
> userdel
> check
> ```
> 
> >获取本机所有的用户并按序号排列
> 
> 需求：
> 
> ```plain
> user1:root
> user2:man1
> user3:man2
> ```
> 
> >嵌套循环
> 
> 需求：
> 
> ```plain
> 有2个文本，一个IP文本，一个端口文本
> IP文本里存放存活主机
> 端口文本存放需要检查的端口
> 然后探测每个主机开放了哪些端口
> ```
> 
> 参考命令
> 
> ```plain
> ping -c1 $ip &>/dev/null
> nc -z -w 1 $ip $port &>/dev/null
> ```
> 
> 脚本:
> 
> >对比两个文本不同的内容
> 
> 需求：
> 
> ```plain
> 1.有两个用户名的文本user1.txt和user2.txt
> 2.对比user1的用户名是否存在与user2里
> ```
> 
> 脚本：
> 
> >mysql分库分表备份
> 
> 需求：
> 
> ```plain
> 1.数据库备份在/backup/mysql目录
> 2.按照"/backup/mysql/日期—IP/库名/表名"的格式备份数据
> ```
> 
> 脚本：
> 
> ```plain
> #!/bin/bash
> 
> for db_name in zh wordpress
> do
>   table_list=$(mysql -uroot -p123 -e "show tables from ${db_name};"|grep -v "Tables_in")
>   mkdir -p /backup/${db_name}
>   
>   for table_name in ${table_list}
>   do
>     mysqldump -uroot -p123 ${db_name} ${table_name} >> /backup/${db_name}/${table_name}.sql
>   done
>   
> done
> ```
> 
> >抓取blog的文章标题
> 
> 目标博客：
> 
> https://www.cnblogs.com/alaska/default.html?page=1
> 
> 需求：
> 
> ```plain
> 1.批量获取博客的所有文章链接
> 2.过滤和整理出所有的文章标题
> ```
> 
> 脚本：
> 
> ```plain
> #!/bin/bash
> 
> curl -s https://www.cnblogs.com/alaska/default.html?page=1 -o blog.html
> 
> PAGE_MAX=$(grep "page=" blog.html|sed -r 's#.*page=(.*)".*$#\1#g'|sort|tail -1)
> echo "一共有${PAGE_MAX}"
> 
> for line in $(seq 1 ${PAGE_MAX})
> do
>     curl -s https://www.cnblogs.com/alaska/default.html?page=${line} -o page_${line}.html
>     for num in $(awk '/postTitle2/{print NR}' page_${line}.html)
>     do
>         url=$(awk -F "\"" 'NR=='${num}'{print $4}' page_${line}.html ) 
>         title_line=$[ ${num} + 2 ]
>         title=$(sed -n "${title_line}"p page_${line}.html|awk '{print $1}')
>         echo -e "${title} \t ${url}" >> title.txt
>     done
> done
> ```
> 
> >json格式转换
> 
> 原始文本：
> 
> ```plain
> [root@m-61 shell]# cat json.txt 
> aaa:111
> bbb:222
> ccc:333
> ```
> 
> 转换为：
> 
> ```plain
> [root@m-61 shell]# bash json.sh 
> {
> "data":[
> {"aaa":"111"},
> {"bbb":"222"},
> {"ccc":"333"}
> ]}
> ```
> 
> 优秀的炜神:
> 
> ```plain
> #!/bin/bash
> echo "{"
> echo "\"data\":["
> 
> max_line=$(cat json.txt|wc -l)
> sed -rn 's#(.*):(.*)#\{"\1":"\2"}\,#gp' json.txt|sed -r "${max_line}s#\,##g"
> 
> echo "]}"
> ```
> 
> 数组战士-怀钰
> 
> ```plain
> #!/bin/bash
> export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
> num=`cat 1.txt | wc -l`
> v1=(`awk -F ":" '{print $1}' 1.txt`)
> v2=(`awk -F ":" '{print $2}' 1.txt`)
> echo -e '{\n"data":['
> for (( i = 0; i < ${num}; i++ )); do
>   if [ ${i} != $[num - 1]  ]; then
>     echo "{\"${v1[i]}\":\"${v2[i]}\"}",
>   else
>     echo "{\"${v1[i]}\":\"${v2[i]}\"}"
>   fi
> done
> echo ']}'
> ```
> 
> 小张笨拙的脚本：
> 
> ```plain
> [root@m-61 shell]# cat json.sh 
> #!/bin/bash
> 
> echo '{' 
> echo '"data":[' 
> 
> max_line=$(cat json.txt|wc -l)
> for i in $(seq 1 $(max_line))
> do
>     if [ $i -lt $max_line ];then
>        echo "{\"$(awk -F: "NR==$i"'{print $1}' json.txt)\":\"$(awk -F: "NR==$i"'{print $2}' json.txt)\"}",
>     else
>        echo "{\"$(awk -F: "NR==$i"'{print $1}' json.txt)\":\"$(awk -F: "NR==$i"'{print $2}' json.txt)\"}"
>     fi 
> done 
> 
> echo "]}"
> ]}
> ```
> 
> >按范围输出文本
> 
> 原始文本：
> 
> ```plain
> 有文本如下：
> 1
> 2
> 3
> 4
> 5
> 6
> 7
> 8
> 9
> 10
> 11
> 12
> ```
> 
> 需求：
> 
> 每四行输出到一个文本，文件名按文本里第一行命名
> 
> CK实现:
> 
> ```plain
> #!/bin/bash
> 
> cat num.txt|xargs -n 4 > num_v2.txt
> max_line=$(cat num_v2.txt|wc -l)
> for num in $(seq 1 ${max_line})
> do
>   sed -n "$num"p num_v2.txt|xargs -n 1 >> ${num}.txt
> done
> ```
> 
> 胖虎实现:
> 
> ```plain
> #!/bin/bash
> for (( i = 0; i < 5; i++ )); do
>   echo $(cat num.txt|xargs -n 4|awk "NR==${i}"'{print}') > ${i}.txt
> done
> ```
> 
> 实现：
> 
> ```plain
> #!/bin/bash
> 
> max_line=$(cat num.txt|wc -l)
> 
> for i in $( seq 1 4 ${max_line}  )
> do
>    num=$[ ${i} + 3 ]
>    sed -n "$[i],${num}"p num.txt >> ${i}.txt
> done
> ```
> 
> 
