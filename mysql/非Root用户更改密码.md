非Root用户修改自己的密码

第一种方法：

```
mysqladmin password -uabc -p111
```

第二种方法：

```
set password=password('abc');
```


3.root在登陆了mysql后修改普通用户密码(不需要知道普通用户原来的密码)

```
set password for abc@localhost=PASSWORD('123');
```
