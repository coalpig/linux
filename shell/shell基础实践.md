---
tags:
  - Shell
---
> [!info]- shell脚本最佳实践
> 
> 
> 1.shell脚本名称必须要有含义，切忌随便起名，文件后缀名最好以.sh结尾。
> 2.shell脚本首行建议添加使用的解释器，如：#!/bin/bash
> 3.最好给自己的脚本加个注释，注释内容包含了脚本创建时间，作者，以及脚本作用等。
> 4.注释尽量不要有中文
> 5.脚本放在专门的目录里
> 
> 举例：
> 
> ```plain
> #!/bin/bash    #! 是一个约定的标记，它告诉系统这个脚本需要什么解释器来执行，即使用哪一种 Shell。
> # Author: lican@qq.com      #作者名称
> # Create Time 2024/06/02              		#创建日期
> # Script Description: this is my 1st shell script.     #脚本描述
> ```

> [!info]- 第一个shell脚本
> 
> 
> ```plain
> cat > hello.sh << 
> #!/bin/bash
> echo "Hello World"
> EOF
> ```

> [!info]- shell执行方式
> 3.shell执行方式
> 
> >3.1 执行脚本命令
> 
> ```plain
> ./test.sh
> bash test.sh
> source test.sh
> ```
> 
> >3.2 首行不指定解释器
> 
> 如果不在脚本首行指定 #!/bin/bash解释器，那么./执行的时候系统会默认调用bash来执行脚本。
> 如果我的脚本是python语言写的，那么执行的使用就会报错，因为默认会使用bash来执行而不是python来执行。
> 
> >3.3 首行指定解释器
> 
> 如果首行添加了解释器./执行的时候默认会读取脚本第一行，来确定使用什么解释器运行脚本。
> 
> >3.4 直接指定解释器运行
> 
> 我们也可以直接指定使用什么解释器来运行，那样即使脚本首行没有添加解释器也可以运行,例如
> bash test.sh
> python test.sh
> 
> >3.5 python的hello
> 
> ```plain
> #!/usr/bin/python3
> hello = 'hellooooo'
> print(hello)
> ```
> 




