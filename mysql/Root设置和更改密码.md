mysql初始化后是没有密码的，需要设置密码

```
mysqladmin password -uroot -p123
```

第二种方法：

```
set password=password('root');
```

```
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('新密码');
```

Root更改密码

```
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('新密码');
```

```
ALTER USER 'root'@'localhost' IDENTIFIED BY '新密码';
```

```
mysqladmin -u root -p当前密码 password '新密码'

#接下来进入交互模式
```