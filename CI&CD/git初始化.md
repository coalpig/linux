
> [!run]- 创建工作目录
> 
> 
> ```plain
> mkdir /git_data
> ```

> [!run]- 初始化
> 
> 
> ```plain
> cd /git_data
> git init
> ```

> [!run]- 查看状态
> 
> 
> ```plain
> git status
> ```

> [!info]- 隐藏文件介绍
> 
> 
> ```plain
> [root@gitlab /git_data]# ls .git|xargs -n 1
> branches        #分支目录
> config          #定义项目的特有配置
> description     #描述
> HEAD            #当前分支
> hooks           #git钩子文件
> info            #包含一个全局排除文件
> objects         #存放所有数据，包含info和pack两个子文件夹
> refs            #存放指向数据（分支）的提交对象的指针
> index           #保存暂存区信息，在执行git init的时候，这个文件还没有
> ```
