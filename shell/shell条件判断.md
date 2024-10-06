---
tags:
  - Shell
---

> [!info]- 基于文件进行判断
> 
> 
> | **参数** | **说明**                            | **举例**    |
> | -------- | ----------------------------------- | ----------- |
> | -e       | 如果文件或目录存在则为真-常用       | [ -e file ] |
> | -s       | 如果文件存在且至少有一个字符则为真  | [ -s file ] |
> | -d       | 如果文件存在且为目录则为真-常用     | [ -d file ] |
> | -f       | 如果文件存在且为普通文件则为真-常用 | [ -s file ] |
> | -r       | 如果文件存在且可读则为真            | [ -r file ] |
> | -w       | 如果文件存在且可写则为真            | [ -w file ] |
> | -x       | 如果文件存在且可执行则为真          | [ -x file ] |
> 

> [!info]- 条件判断语法
> 
> 
> 第一种写法
> 
> ```plain
> test -f /etc/passwd && echo "true" || echo "false"
> ```
> 
> 第二种写法
> 
> ```plain
> [ -f /etc/passwdd ] && echo "true" || echo "false"
> ```
> 

> [!info]- 条件判断练习
> 
> 
> ```plain
> [ -f /etc/passwd ] && echo "文件存在" || echo "文件不存在"
> [ -e /etc/passwd ] && echo "文件存在" || echo "文件不存在"
> [ -r /etc/passwd ] && echo "文件可读" || echo "文件不可读"
> [ -w /etc/passwd ] && echo "文件可写" || echo "文件不可写"
> [ -x /etc/passwd ] && echo "文件可执行" || echo "文件不可执行"
> 
> [ -s /dev/zero ] && echo "true"||echo "false"
> [ -s /dev/null ] && echo "true"||echo "false"
> [ -s /etc/passwd ] && echo "true"||echo "false"
> 
> [ -f /dev/zero ] && echo "true"||echo "false"
> [ -f /dev/null ] && echo "true"||echo "false"
> [ -f /etc/passwd ] && echo "true"||echo "false"
> ```
> 

> [!info]- 基于整数进行判断
> 
> 
> | **参数** | **说明**                  | **举例**       |
> | ------ | ----------------------- | ------------ |
> | -eq    | 等于则条件为真 equal           | [ 1 -eq 10 ] |
> | -ne    | 不等于则条件为整 not equal      | [ 1 -ne 10 ] |
> | -gt    | 大于则条件为真 greater than    | [ 1 -gt 10 ] |
> | -lt    | 小于则条件为真 less than       | [ 1 -lt 10 ] |
> | -ge    | 大于等于则条件为真 greater equal | [ 1 -ge 10 ] |
> | -le    | 小于等于则条件为真 less equal    | [ 1 -le 10 ] |
> 

> [!info]- 举例练习和action颜色
> 
> 
> 单个条件
> 
> ```plain
> #!/bin/bash
> read -p "please input num1:" num1
> read -p "please input num2:" num2
> 
> [ $num1 -eq $num2 ] && echo "-eq ok" || echo "-eq no"
> [ $num1 -ne $num2 ] && echo "-ne ok" || echo "-ne no"
> [ $num1 -gt $num2 ] && echo "-gt ok" || echo "-gt no"
> [ $num1 -lt $num2 ] && echo "-lt ok" || echo "-lt no"
> [ $num1 -ge $num2 ] && echo "-ge ok" || echo "-ge no"
> [ $num1 -le $num2 ] && echo "-le ok" || echo "-le no"
> ```
> 
> 优化输出效果：
> 
> ```plain
> #!/bin/bash
> source /etc/init.d/functions 
> read -p "please input num1:" num1
> read -p "please input num2:" num2
> 
> [ $num1 -eq $num2 ] && action '-eq OK' /bin/true || action '-eq NO' /bin/false
> [ $num1 -ne $num2 ] && action '-ne OK' /bin/true || action '-ne NO' /bin/false
> [ $num1 -gt $num2 ] && action '-gt OK' /bin/true || action '-gt NO' /bin/false
> [ $num1 -lt $num2 ] && action '-lt OK' /bin/true || action '-lt NO' /bin/false
> [ $num1 -ge $num2 ] && action '-ge OK' /bin/true || action '-ge NO' /bin/false
> [ $num1 -le $num2 ] && action '-le OK' /bin/true || action '-le NO' /bin/false
> ```

> [!info]- 综合练习
> 
> 
> ```plain
> 1.判断用户输入的是否为整数
> 2.判断用户输入的是否为包含特殊字符
> 3.判断用户输入的参数是否满足2个
> 4.判断用户输入的数字是否不超过4位
> 5.编写加判断的计算器
> ```
> 

> [!info]- 基于字符串进行判断
> 
> 
> | **参数** | **说明**               | **举例**         |
> | -------- | ---------------------- | ---------------- |
> | ==       | 等于则条件为真         | [ "$a" == "$b" ] |
> | !=       | 不等于则条件为真       | [ "$a" != "$b" ] |
> | -z       | 字符串内容为空则为真   | [ -z "$a" ]      |
> | -n       | 字符串内容不为空则为真 | [ -n "$a" ]      |
> 

> [!info]- 字符判断举例
> 
> 
> ```plain
> [ 10 == 10 ] && echo "==" || "><"
> [ 10 != 5 ] && echo "==" || "><"
> name=123
> [ -z "$name" ] && echo "true"||echo "false"
> [ -n "$name" ] && echo "true"||echo "false"
> ```

> [!info]- 多个条件and和or的判断
> 
> 
> | **参数** | **说明**                       | **举例**               |
> | -------- | ------------------------------ | ---------------------- |
> | -a       | 左右两边的条件同时为真才为真   | [ 1 -eq 1 -a 2 -gt 1 ] |
> | -o       | 左右两边的条件有一个为真则为真 | [ 1 -eq 1 -o 2 -gt 2 ] |
> 

> [!info]- 举例
> 
> 
> ```plain
> [ 1 -eq 1 -a 2 -gt 1 ] && action OK /bin/true || action NO /bin/false
> [ 1 -eq 1 -o 2 -gt 2 ] && action OK /bin/true || action NO /bin/false
> ```
> 
> 
