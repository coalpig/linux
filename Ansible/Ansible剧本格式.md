---
tags:
  - ansible/剧本
---

- ~ YAML格式特点

变态的缩进要求，通过缩进表示层级关系

: 和 - 后面必须接空格

不要使用tab缩进

文件后缀名需要改为yaml或yml，vim可以智能高亮提示

- ~ 剧本的组成

```
hosts: 需要执行的主机组

tasks: 只要执行的任务

  - name: 任务名称

  yum: 模块名称

​    name: 软件名称

​	state: 状态
```
