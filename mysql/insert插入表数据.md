INSERT 插入表数据

```
use school;
CREATE TABLE `st` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '学号',
  `name` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT '学生姓名',
  `age` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '学生年龄',
  `gender` char(1) COLLATE utf8mb4_bin NOT NULL DEFAULT 'n' COMMENT '学生性别',
  `address` enum('北京','深圳','上海','广州','重庆','未知') COLLATE utf8mb4_bin NOT NULL DEFAULT '未知' COMMENT '省份',
  `intime` datetime NOT NULL COMMENT '入学时间',
  `cardnum` char(18) COLLATE utf8mb4_bin NOT NULL COMMENT '身份证',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
```

标准：

```
INSERT INTO 
st(id,NAME,age,gender,address,intime,cardnum)
VALUES(1,'张三',18,'m','北京','2020-09-06','666666');
SELECT * FROM st;
```

部分列录入：

```
INSERT INTO 
st(NAME,intime)
VALUES('李四',NOW());
SELECT * FROM st;
```

修改时间列的默认值为NOW()

```
ALTER TABLE st MODIFY intime DATETIME NOT NULL DEFAULT NOW() COMMENT '入学时间';
DESC st;
```

再次插入数据:

```
INSERT INTO 
st(NAME,num)
VALUES('王五',11112);
SELECT * FROM st;
```

省略写法:

```
desc st;
insert into 
st
values(5,'张三',18,'m','北京','2020-04-27','666666');
select * from st;
```
