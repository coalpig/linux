DELETE/UPDATE/TRUNCATE 删除表数据

### 3.1 DELETE

```
DELETE FROM st WHERE id=3;
SELECT * FROM st;
```

### 3.2 伪删除

update 替代 dalete, 添加状态列，1代表存在，0代表删除

第一步：增加状态列

```
ALTER TABLE st ADD COLUMN state TINYINT NOT NULL DEFAULT 1 COMMENT '状态列,0是删除,1是存在';
DESC st;
```

第二步：使用update 替换 delete

```
原： 
delete from st where id=4

修改后： 
UPDATE st SET state=0 WHERE id=4;
```

第三步：替换原来查询业务语句

```
原：　
select * from st;

改变后：　
SELECT * FROM st WHERE state=1;
```
