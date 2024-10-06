---
tags:
  - CICD/git
---
- ~ git安装配置

> [!info]- 版本控制系统介绍
> 
> 
> vcs "version control system"
> 版本控制系统是⼀一种记录⼀一个或若⼲干个⽂文件内容变化，以便便将来查阅特定版本内容情况的系统  
> 记录⽂文件的所有历史变化 随时可恢复到任何⼀一个历史状态 多⼈人协作开发

> [!install]- 安装命令
> 
> 
> ```
> yum install git -y
> ```

> [!config]- 查看配置
> 
> 
> ```
> [root@gitlab ~]# git config 
> 用法：git config [选项]
> 
> 配置文件位置
>     --global              使用全局配置文件
>     --system              使用系统级配置文件
>     --local               使用版本库级配置文件
>     -f, --file <文件>      使用指定的配置文件
> ```

> [!run]- 配置使用git的用户
> 
> ```
> git config --global user.name "abc"
> ```

> [!run]- 配置使用git的邮箱
> 
> 
> ```
> git config --global user.email "abc@qq.com"
> ```

> [!run]- 设置语法高亮
> 
> 
> ```plain
> git config --global color.ui true
> ```

> [!run]- 查看配置
> 
> 
> ```
> [root@gitlab ~]# git config --list
> user.name=zhangya
> user.email=526195417@qq.com
> color.ui=true
> 
> [root@gitlab ~]# cat .gitconfig 
> [user]
>         name = zhangya
>         email = 526195417@qq.com
> [color]
>         ui = true
> ```

