```
CREATE DATABASE school CHARSET utf8mb4;
use school;
CREATE TABLE `student` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '学号',
  `name` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT '学生姓名',
  `age` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '学生年龄',
  `gender` char(1) COLLATE utf8mb4_bin NOT NULL DEFAULT 'n' COMMENT '学生性别',
  `address` enum('北京','深圳','上海','广州','重庆','未知') COLLATE utf8mb4_bin NOT NULL DEFAULT '未知' COMMENT '省份',
  `intime` datetime NOT NULL COMMENT '入学时间',
  `shenfen` char(18) COLLATE utf8mb4_bin NOT NULL COMMENT '身份证',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
```