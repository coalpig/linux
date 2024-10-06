---
tags:
  - CICD/git
---

> [!run]- 给当前版本创建标签
> 
> 
> ```plain
> [root@gitlab /git_data]# git tag v1.0 -m "aaa bbb master testing version v1.0"
> ```

> [!run]- 给指定版本打标签
> 
> 
> ```plain
> [root@gitlab /git_data]# git log --oneline 
> 921d88e merge testing to master
> 71c50c8 modified a on testing branch
> 38fd841 modified a master
> 6f38df1 Merge branch 'testing'
> 6f9e2f0 commit master
> d50853d commit test
> b11e0b2 add bbb
> 8203c87 modified a
> 5c3ddba rename a.txt a
> 42ede9c commit a.txt
> 1153f56 commit a
> [root@gitlab /git_data]# git tag -a v2.0 b11e0b2 -m "add bbb version v2.0"
> ```

> [!run]- 查看标签
> 
> 
> ```plain
> [root@gitlab /git_data]# git tag 
> v1.0
> v2.0
> ```

> [!run]- 回滚到指定标签
> 
> 
> 首先查看当前版本文件
> 
> ```plain
> [root@gitlab /git_data]# ll
> 总用量 4
> -rw-r--r-- 1 root root 16 5月  11 16:36 a
> -rw-r--r-- 1 root root  0 5月  11 16:33 master
> -rw-r--r-- 1 root root  0 5月  11 16:11 test
> ```
> 
> 回滚到指定版本
> 
> ```plain
> [root@gitlab /git_data]# git reset --hard v2.0
> HEAD 现在位于 b11e0b2 add bbb
> ```
> 
> 再次查看文件
> 
> ```plain
> [root@gitlab /git_data]# ll
> 总用量 4
> -rw-r--r-- 1 root root 9 5月  11 16:52 a
> ```
