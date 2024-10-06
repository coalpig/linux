修改列名：

```
ALTER TABLE st CHANGE shenfen cardnum CHAR(18) NOT NULL DEFAULT '0' COMMENT '身份证';
```

修改默认值：

```
ALTER TABLE st CHANGE cardnum cardnum CHAR(18) NOT NULL DEFAULT '1' COMMENT '身份证';
```

修改数据类型：

```
ALTER TABLE st MODIFY cardnum CHAR(20) NOT NULL DEFAULT '1' COMMENT '身份证';
```

