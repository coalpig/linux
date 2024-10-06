
增加列：增加telnum列

推荐的方式，在最后一列后添加，

```
use school;
DESC `student`;
ALTER TABLE `student` 
ADD COLUMN telnum CHAR(11) NOT NULL UNIQUE KEY DEFAULT '0' COMMENT '手机号' ;
```

不建议的方式：

在gender列后增加列

```
alter table luffy.student 
add column a CHAR(11) not null unique key default '0' comment '手机号' after gender ;
desc student;
```

在第一列添加列

```
alter table luffy.student 
add column b CHAR(11) not null unique key default '0' comment '手机号' first ;
desc student;
```

删除列：（不代表生产操作，危险！！！！）

```
alter table student drop  a;
alter table student drop  b;
alter table student drop  telnum;
```