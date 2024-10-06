---
tags:
  - CICD/git
---

> [!run]- 在工作目录创建测试文件
> 
> 
> ```plain
> [root@gitlab /git_data]# touch a b c 
> [root@gitlab /git_data]# git status
> # 位于分支 master
> #
> # 初始提交
> #
> # 未跟踪的文件:
> #   （使用 "git add < file >..." 以包含要提交的内容）
> #
> #       a
> #       b
> #       c
> 提交为空，但是存在尚未跟踪的文件（使用 "git add" 建立跟踪）
> ```

> [!run]- 提交文件到暂存区
> 
> 
> 提交a文件到暂存区
> 
> ```plain
> [root@gitlab /git_data]# git add a
> [root@gitlab /git_data]# git status
> # 位于分支 master
> #
> # 初始提交
> #
> # 要提交的变更：
> #   （使用 "git rm --cached < file >..." 撤出暂存区）
> #
> #       新文件：    a
> #
> # 未跟踪的文件:
> #   （使用 "git add < file >..." 以包含要提交的内容）
> #
> #       b
> #       c
> ```
> 
> 查看隐藏目录
> 
> ```plain
> [root@gitlab /git_data]# ll .git/
> 总用量 20
> drwxr-xr-x 2 root root    6 5月  11 12:32 branches
> -rw-r--r-- 1 root root   92 5月  11 12:32 config
> -rw-r--r-- 1 root root   73 5月  11 12:32 description
> -rw-r--r-- 1 root root   23 5月  11 12:32 HEAD
> drwxr-xr-x 2 root root 4096 5月  11 12:32 hooks
> -rw-r--r-- 1 root root   96 5月  11 13:01 index        # git add a 把文件提交到了暂存区
> drwxr-xr-x 2 root root   20 5月  11 12:32 info
> drwxr-xr-x 5 root root   37 5月  11 13:01 objects
> drwxr-xr-x 4 root root   29 5月  11 12:32 refs
> ```
> 
> 提交所有文件
> 
> ```plain
> [root@gitlab /git_data]# git add .
> [root@gitlab /git_data]# git status
> # 位于分支 master
> #
> # 初始提交
> #
> # 要提交的变更：
> #   （使用 "git rm --cached < file >..." 撤出暂存区）
> #
> #       新文件：    a
> #       新文件：    b
> #       新文件：    c
> ```

> [!run]- 提交文件到暂存区
> 
> 
> ```plain
> [root@gitlab /git_data]# git rm --cached c
> rm 'c'
> 
> [root@gitlab /git_data]# git status       
> # 位于分支 master
> #
> # 初始提交
> #
> # 要提交的变更：
> #   （使用 "git rm --cached < file >..." 撤出暂存区）
> #
> #       新文件：    a
> #       新文件：    b
> #
> # 未跟踪的文件:
> #   （使用 "git add < file >..." 以包含要提交的内容）
> #
> #       c
> [root@git
> ```
> 

> [!run]- 删除提交到暂存区的文件
> 
> 
> 方法1: 先从暂存区撤回到工作区，然后直接删除文件
> 
> ```plain
> [root@gitlab /git_data]# rm -f c
> [root@gitlab /git_data]# git status
> # 位于分支 master
> #
> # 初始提交
> #
> # 要提交的变更：
> #   （使用 "git rm --cached < file >..." 撤出暂存区）
> #
> #       新文件：    a
> #       新文件：    b
> ```
> 
> 方法2:直接同时删除工作目录和暂存区的文件
> 
> ```plain
> [root@gitlab /git_data]# ll
> 总用量 0
> -rw-r--r-- 1 root root 0 5月  11 13:00 a
> -rw-r--r-- 1 root root 0 5月  11 13:00 b
> 
> [root@gitlab /git_data]# git rm -f b
> rm 'b'
> 
> [root@gitlab /git_data]# git status
> # 位于分支 master
> #
> # 初始提交
> #
> # 要提交的变更：
> #   （使用 "git rm --cached < file >..." 撤出暂存区）
> #
> #       新文件：    a
> #
> 
> [root@gitlab /git_data]# ll
> 总用量 0
> -rw-r--r-- 1 root root 0 5月  11 13:00 a
> ```

> [!run]- 提交当前暂存区的所有文件到本地仓库
> 
> 
> ```plain
> [root@gitlab /git_data]# git commit -m "commit a"
> [master（根提交） 1153f56] commit a
>  1 file changed, 0 insertions(+), 0 deletions(-)
>  create mode 100644 a
>  
> [root@gitlab /git_data]# git status
> # 位于分支 master
> 无文件要提交，干净的工作区
> ```

> [!run]- 重命名已提交到本地仓库的文件
> 
> 
> 方法1:手动修改
> 
> ```plain
> [root@gitlab /git_data]# mv a a.txt
> [root@gitlab /git_data]# git status
> # 位于分支 master
> # 尚未暂存以备提交的变更：
> #   （使用 "git add/rm < file>..." 更新要提交的内容）
> #   （使用 "git checkout -- < file>..." 丢弃工作区的改动）
> #
> #       删除：      a
> #
> # 未跟踪的文件:
> #   （使用 "git add < file>..." 以包含要提交的内容）
> #
> #       a.txt
> 修改尚未加入提交（使用 "git add" 和/或 "git commit -a"）
> 
> [root@gitlab /git_data]# git rm --cached a
> rm 'a'
> [root@gitlab /git_data]# git status
> # 位于分支 master
> # 要提交的变更：
> #   （使用 "git reset HEAD < file>..." 撤出暂存区）
> #
> #       删除：      a
> #
> # 未跟踪的文件:
> #   （使用 "git add < file>..." 以包含要提交的内容）
> #
> #       a.txt
> 
> [root@gitlab /git_data]# git add a.txt
> [root@gitlab /git_data]# git status
> # 位于分支 master
> # 要提交的变更：
> #   （使用 "git reset HEAD < file>..." 撤出暂存区）
> #
> #       重命名：    a -> a.txt
> 
> [root@gitlab /git_data]# git commit -m "commit a.txt"
> [master 42ede9c] commit a.txt
>  1 file changed, 0 insertions(+), 0 deletions(-)
>  rename a => a.txt (100%)
> [root@gitlab /git_data]# git status
> # 位于分支 master
> 无文件要提交，干净的工作区
> 
> [root@gitlab /git_data]# ll
> 总用量 0
> -rw-r--r-- 1 root root 0 5月  11 13:00 a.txt
> ```
> 
> 方法2:git修改
> 
> ```plain
> [root@gitlab /git_data]# git mv a.txt a
> [root@gitlab /git_data]# git status
> # 位于分支 master
> # 要提交的变更：
> #   （使用 "git reset HEAD < file>..." 撤出暂存区）
> #
> #       重命名：    a.txt -> a
> 
> [root@gitlab /git_data]# git commit -m "rename a.txt a"
> [master 5c3ddba] rename a.txt a
>  1 file changed, 0 insertions(+), 0 deletions(-)
>  rename a.txt => a (100%)
> [root@gitlab /git_data]# git status
> # 位于分支 master
> 无文件要提交，干净的工作区
> ```
> 

> [!run]- 对比工作目录的文件和暂存区文件的差异
> 
> 
> ```plain
> [root@gitlab /git_data]# echo aaaa > a
> [root@gitlab /git_data]# git diff
> diff --git a/a b/a
> index e69de29..5d308e1 100644
> --- a/a
> +++ b/a
> @@ -0,0 +1 @@
> +aaaa
> ```

> [!run]- 对比暂存区和本地仓库的文件内容的差异
> 
> 
> 提交a到本地暂存区，用git diff查看是相同的
> 
> ```plain
> [root@gitlab /git_data]# git add a
> [root@gitlab /git_data]# git diff
> ```
> 
> 对比暂存区和本地仓库文件的不同
> 
> ```plain
> [root@gitlab /git_data]# git diff --cached a
> diff --git a/a b/a
> index e69de29..5d308e1 100644
> --- a/a
> +++ b/a
> @@ -0,0 +1 @@
> +aaaa
> ```
> 
> 将暂存区文件提交到本地仓库后再对比
> 
> ```plain
> [root@gitlab /git_data]# git commit -m "modified a"
> [master 8203c87] modified a
>  1 file changed, 1 insertion(+)
> [root@gitlab /git_data]# git diff --cached a
> ```

> [!run]- 查看历史的提交记录
> 
> 
> 查看详细信息
> 
> ```plain
> [root@gitlab /git_data]# git log
> commit 8203c878bc30c3bd23ee977e5980232fa660ddae
> Author: zhangya <526195417@qq.com>
> Date:   Mon May 11 13:38:22 2020 +0800
> 
>     modified a
> 
> commit 5c3ddba7bc8de6b8575e77513ee9805021ffc5ef
> Author: zhangya <526195417@qq.com>
> Date:   Mon May 11 13:26:10 2020 +0800
> 
>     rename a.txt a
> 
> commit 42ede9cc10865b67e4b1e8ad58a601eadf45cd61
> Author: zhangya <526195417@qq.com>
> Date:   Mon May 11 13:24:35 2020 +0800
> 
>     commit a.txt
> 
> commit 1153f564c45678cc9d4c265a1b55f5ba7b610ac9
> Author: zhangya <526195417@qq.com>
> Date:   Mon May 11 13:16:13 2020 +0800
> 
>     commit a
> ```
> 
> 查看简单的信息一行现实
> 
> ```plain
> [root@gitlab /git_data]# git log --oneline 
> 8203c87 modified a
> 5c3ddba rename a.txt a
> 42ede9c commit a.txt
> 1153f56 commit a
> ```
> 
> 显示当前的指针指向
> 
> ```plain
> [root@gitlab /git_data]# git log --oneline --decorate
> 8203c87 (HEAD, master) modified a
> 5c3ddba rename a.txt a
> 42ede9c commit a.txt
> 1153f56 commit a
> ```
> 
> 显示具体内容的变化
> 
> ```
> [root@gitlab /git_data]# git log -p
> ```
> 
> 只显示最新的内容
> 
> ```plain
> [root@gitlab /git_data]# git log -1
> commit 8203c878bc30c3bd23ee977e5980232fa660ddae
> Author: zhangya <526195417@qq.com>
> Date:   Mon May 11 13:38:22 2020 +0800
> 
>     modified a
> ```

> [!run]- 回滚到指定版本
> 
> 
> 提交新内容bbb到文件a
> 
> ```plain
> [root@gitlab /git_data]# echo bbb >> a
> [root@gitlab /git_data]# git add a
> [root@gitlab /git_data]# git commit -m "add bbb"
> [master b11e0b2] add bbb
>  1 file changed, 1 insertion(+)
> ```
> 
> 提交新内容ccc到文件a
> 
> ```plain
> [root@gitlab /git_data]# echo ccc >> a
> [root@gitlab /git_data]# git add a
> [root@gitlab /git_data]# git commit -am "add ccc"
> [master 4df18d4] add ccc
>  1 file changed, 1 insertion(+)
> ```
> 
> 查看版本号
> 
> ```plain
> [root@gitlab /git_data]# git log --oneline 
> 4df18d4 add ccc
> b11e0b2 add bbb
> 8203c87 modified a
> 5c3ddba rename a.txt a
> 42ede9c commit a.txt
> 1153f56 commit a
> ```
> 
> 回滚到指定版本 modified a
> 
> ```plain
> [root@gitlab /git_data]# git reset --hard 8203c87
> HEAD 现在位于 8203c87 modified a
> [root@gitlab /git_data]# cat a 
> aaaa
> ```
> 
> 此时发现回滚错了，应该回退到bbb
> 
> 此时查看历史会发现并没有bbb,因为回到了过去，那时候提交bbb还没发生，所有看不到记录
> 
> ```plain
> [root@gitlab /git_data]# git log --oneline 
> 8203c87 modified a
> 5c3ddba rename a.txt a
> 42ede9c commit a.txt
> 1153f56 commit a
> ```
> 
> 我们可以使用reflog来查看总的历史记录
> 
> ```plain
> [root@gitlab /git_data]# git reflog 
> 8203c87 HEAD@{0}: reset: moving to 8203c87
> 4df18d4 HEAD@{1}: commit: add ccc
> b11e0b2 HEAD@{2}: commit: add bbb
> 8203c87 HEAD@{3}: commit: modified a
> 5c3ddba HEAD@{4}: commit: rename a.txt a
> 42ede9c HEAD@{5}: commit: commit a.txt
> 1153f56 HEAD@{6}: commit (initial): commit a
> ```
> 
> 然后再指定回退到bbb版本
> 
> ```plain
> [root@gitlab /git_data]# git reset --hard b11e0b2
> HEAD 现在位于 b11e0b2 add bbb
> [root@gitlab /git_data]# cat a 
> aaaa
> bbb
> ```
> 