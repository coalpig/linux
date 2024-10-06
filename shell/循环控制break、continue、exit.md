---
tags:
  - Shell
---

- ~ 应用场景

```plain
1.有些时候我们可能希望在满足特定条件的情况下立刻终止循环，即使循环还没结束
2.比如如果输错3次密码就强制退出，如果输入了退出关键里立刻退出等
```

> [!info]- break
> 
> #Shell/循环控制/break
> 
> >2.1 break解释
> 
> 结束当前的循环，但会继续执行循环之后所有的代码
> 
> >2.2 break举例
> 
> ```plain
> #!/bin/bash
> 
> for i in {1..3}
> do
>     echo "123"
>     break
>     echo "456"
> done
> 
> echo "all is ok"
> ```
> 

> [!info]- continue
> 
> #Shell/循环控制/continue
> >3.1 continue解释
> 
> ```plain
> 1.忽略本次循环剩余的代码，直接进入下次循环，直到循环结束
> 2.循环结束之后，继续执行循环以外的代码。
> ```
> 
> >3.2 continue举例
> 
> ```plain
> #!/bin/bash
> 
> for i in {1..3}
> do
>     echo "123"
>     continue
>     echo "456" 
> done
> 
> echo "all is ok"
> ```
> 

> [!info]- exit
> 
> #Shell/循环控制/exit
> >4.1 exit解释
> 
> 遇到exit直接退出整个脚本，后面不管有多少命令都不执行
> 
> >4.2 exit举例
> 
> ```plain
> #!/bin/bash
> 
> for num in {1..3}
> do
>     echo "123"
>     exit
>     echo "456"
> done
> 
> echo "all is ok"
> ```
> 